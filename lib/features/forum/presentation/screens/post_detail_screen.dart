// ============================================================
// lib/features/forum/presentation/screens/post_detail_screen.dart
// Détail d'un post + commentaires
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/post_model.dart';
import '../providers/forum_providers.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({super.key});
  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _ctrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _sendComment(String postId) async {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() => _sending = true);
    await ref.read(forumNotifierProvider.notifier)
        .addComment(postId, _ctrl.text);
    _ctrl.clear();
    FocusScope.of(context).unfocus();
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as PostModel;
    final commentsAsync = ref.watch(commentsProvider(post.id));
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Discussion')),
      backgroundColor: AppColors.background,
      body: Column(children: [
        // ── Post original ────────────────────────────────
        Expanded(
          child: ListView(children: [
            // Post
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primarySurface,
                    child: Text(
                      post.userNom.isNotEmpty ? post.userNom[0].toUpperCase() : '?',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(post.userNom,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(_timeAgo(post.createdAt),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textLight)),
                  ]),
                  if (post.categorie != null) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(post.categorie!,
                          style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ]),
                const SizedBox(height: 12),
                Text(post.contenu,
                    style: const TextStyle(fontSize: 15, height: 1.6)),
                const SizedBox(height: 12),
                Row(children: [
                  GestureDetector(
                    onTap: () => ref
                        .read(forumNotifierProvider.notifier)
                        .toggleLike(post.id),
                    child: Row(children: [
                      Icon(
                          post.isLikedBy(uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 18,
                          color: post.isLikedBy(uid)
                              ? AppColors.danger
                              : AppColors.textLight),
                      const SizedBox(width: 4),
                      Text('${post.likesCount}',
                          style: const TextStyle(fontSize: 12)),
                    ]),
                  ),
                  const SizedBox(width: 16),
                  Text('${post.commentsCount} réponses',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textLight)),
                ]),
              ]),
            ),

            // ── Séparateur ───────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text('RÉPONSES',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary)),
            ),

            // ── Commentaires ─────────────────────────────
            commentsAsync.when(
              loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (comments) {
                if (comments.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text('Aucune réponse. Soyez le premier !',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  );
                }
                return Column(
                  children: comments.map((c) => _CommentTile(
                    comment: c,
                    currentUid: uid,
                    postId: post.id,
                  )).toList(),
                );
              },
            ),
          ]),
        ),

        // ── Champ commentaire ────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
          ),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                decoration: InputDecoration(
                  hintText: 'Votre réponse...',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border)),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sending ? null : () => _sendComment(post.id),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: _sending ? AppColors.border : AppColors.primary,
                    shape: BoxShape.circle),
                child: _sending
                    ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours}h';
    return 'il y a ${diff.inDays}j';
  }
}

class _CommentTile extends ConsumerWidget {
  final CommentModel comment;
  final String currentUid;
  final String postId;

  const _CommentTile({
    required this.comment,
    required this.currentUid,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwn = comment.userId == currentUid;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColors.primarySurface,
          child: Text(
            comment.userNom.isNotEmpty ? comment.userNom[0].toUpperCase() : '?',
            style: const TextStyle(
                color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(comment.userNom,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              Text(_timeAgo(comment.createdAt),
                  style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
              if (isOwn)
                GestureDetector(
                  onTap: () => ref.read(forumNotifierProvider.notifier)
                      .deleteComment(comment.id, postId),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.delete_outline,
                        size: 14, color: AppColors.textLight),
                  ),
                ),
            ]),
            const SizedBox(height: 4),
            Text(comment.contenu,
                style: const TextStyle(fontSize: 13, height: 1.4)),
          ]),
        ),
      ]),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}j';
  }
}