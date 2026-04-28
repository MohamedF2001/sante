// ============================================================
// lib/features/forum/presentation/providers/forum_provider.dart
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/forum_service.dart';
import '../../domain/post_model.dart';

final forumServiceProvider = Provider<ForumService>((_) => ForumService());

// Stream de tous les posts
final postsProvider = StreamProvider<List<PostModel>>((ref) {
  return ref.watch(forumServiceProvider).watchPosts();
});

// Stream des commentaires d'un post spécifique
final commentsProvider =
StreamProvider.family<List<CommentModel>, String>((ref, postId) {
  return ref.watch(forumServiceProvider).watchComments(postId);
});

// ─── Notifier actions Forum ──────────────────────────────────

class ForumNotifier extends StateNotifier<AsyncValue<void>> {
  final ForumService _service;
  ForumNotifier(this._service) : super(const AsyncData(null));

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';
  String get _nom =>
      FirebaseAuth.instance.currentUser?.displayName ?? 'Utilisateur';

  Future<void> createPost(String contenu, {String? categorie}) async {
    if (contenu.trim().isEmpty) return;
    state = const AsyncLoading();
    try {
      final post = PostModel(
        id: '',
        userId: _uid,
        userNom: _nom,
        contenu: contenu.trim(),
        createdAt: DateTime.now(),
        categorie: categorie,
      );
      await _service.createPost(post);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleLike(String postId) async {
    await _service.toggleLike(postId, _uid);
  }

  Future<void> addComment(String postId, String contenu) async {
    if (contenu.trim().isEmpty) return;
    final comment = CommentModel(
      id: '',
      postId: postId,
      userId: _uid,
      userNom: _nom,
      contenu: contenu.trim(),
      createdAt: DateTime.now(),
    );
    await _service.addComment(comment);
  }

  Future<void> deletePost(String postId) async {
    await _service.deletePost(postId);
  }

  Future<void> deleteComment(String commentId, String postId) async {
    await _service.deleteComment(commentId, postId);
  }
}

final forumNotifierProvider =
StateNotifierProvider<ForumNotifier, AsyncValue<void>>((ref) {
  return ForumNotifier(ref.read(forumServiceProvider));
});