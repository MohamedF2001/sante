// ============================================================
// lib/features/forum/presentation/screens/forum_screen.dart
// Écran 12 — Forum / Ask a Pro
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../domain/post_model.dart';
import '../providers/forum_providers.dart';

class ForumScreen extends ConsumerStatefulWidget {
  const ForumScreen({super.key});
  @override
  ConsumerState<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends ConsumerState<ForumScreen> {
  final _ctrl = TextEditingController();
  String? _selectedCategorie;
  final _categories = ['Vaccination', 'Nutrition', 'Pleurs', 'Croissance', 'Autre'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _publier() async {
    if (_ctrl.text.trim().isEmpty) return;
    await ref.read(forumNotifierProvider.notifier)
        .createPost(_ctrl.text, categorie: _selectedCategorie);
    _ctrl.clear();
    setState(() => _selectedCategorie = null);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ask a Pro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text('Questions validées par des médecins',
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      backgroundColor: AppColors.background,
      body: Column(children: [
        // ── Liste des posts ──────────────────────────────
        Expanded(
          child: postsAsync.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
            error: (e, _) => Center(child: Text('Erreur : $e')),
            data: (posts) {
              if (posts.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('💬', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 12),
                      Text('Soyez le premier à poser une question !',
                          style: TextStyle(
                              fontSize: 15, color: AppColors.textSecondary)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                itemCount: posts.length,
                itemBuilder: (_, i) => _PostCard(post: posts[i]),
              );
            },
          ),
        ),

        // ── Zone de saisie nouvelle question ────────────
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
          ),
          child: Column(children: [
            // Sélecteur catégorie
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _categories.map((cat) {
                  final sel = _selectedCategorie == cat;
                  return GestureDetector(
                    onTap: () => setState(() =>
                    _selectedCategorie = sel ? null : cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: sel ? AppColors.primary : AppColors.border),
                      ),
                      child: Center(
                        child: Text(cat,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: sel ? Colors.white : AppColors.primaryLight)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            // Champ texte + bouton envoyer
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  maxLines: 2,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Posez votre question...',
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _publier,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _PostCard extends ConsumerWidget {
  final PostModel post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid   = FirebaseAuth.instance.currentUser?.uid ?? '';
    final liked = post.isLikedBy(uid);
    final time  = _timeAgo(post.createdAt);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.postDetail,
          arguments: post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── En-tête auteur ───────────────────────────
          Row(children: [
            // Avatar initiales
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primarySurface,
              child: Text(
                post.userNom.isNotEmpty ? post.userNom[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(post.userNom,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              Text(time,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textLight)),
            ]),
            const Spacer(),
            if (post.categorie != null)
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
          ]),
          const SizedBox(height: 10),

          // ── Contenu ──────────────────────────────────
          Text(post.contenu,
              style: const TextStyle(fontSize: 14, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),

          // ── Actions like / commentaires ──────────────
          Row(children: [
            // Like
            GestureDetector(
              onTap: () => ref
                  .read(forumNotifierProvider.notifier)
                  .toggleLike(post.id),
              child: Row(children: [
                Icon(
                    liked ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: liked ? AppColors.danger : AppColors.textLight),
                const SizedBox(width: 4),
                Text('${post.likesCount}',
                    style: TextStyle(
                        fontSize: 12,
                        color: liked ? AppColors.danger : AppColors.textLight)),
              ]),
            ),
            const SizedBox(width: 16),
            // Commentaires
            Row(children: [
              const Icon(Icons.chat_bubble_outline,
                  size: 16, color: AppColors.textLight),
              const SizedBox(width: 4),
              Text('${post.commentsCount} réponses',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textLight)),
            ]),
            const Spacer(),
            // Supprimer si auteur
            if (post.userId == uid)
              GestureDetector(
                onTap: () => ref
                    .read(forumNotifierProvider.notifier)
                    .deletePost(post.id),
                child: const Icon(Icons.delete_outline,
                    size: 16, color: AppColors.textLight),
              ),
          ]),
        ]),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'il y a ${diff.inHours}h';
    return 'il y a ${diff.inDays}j';
  }
}