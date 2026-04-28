// ============================================================
// lib/features/forum/data/forum_service.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/post_model.dart';

class ForumService {
  final _db = FirebaseFirestore.instance;

  // ─── POSTS ───────────────────────────────────────────────

  /// Stream temps réel de tous les posts (du plus récent)
  Stream<List<PostModel>> watchPosts() {
    return _db
        .collection('posts')
        .snapshots()
        .map((snap) {
      final list = snap.docs.map(PostModel.fromFirestore).toList();
      // Trier côté client — du plus récent au plus ancien
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  /// Créer un post
  Future<void> createPost(PostModel post) async {
    await _db.collection('posts').add(post.toMap());
  }

  /// Supprimer un post
  Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
    // Supprimer aussi les commentaires associés
    final comments = await _db
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .get();
    for (final doc in comments.docs) {
      await doc.reference.delete();
    }
  }

  /// Liker / unliker un post
  Future<void> toggleLike(String postId, String userId) async {
    final ref = _db.collection('posts').doc(postId);
    final doc = await ref.get();
    final likedBy = List<String>.from(doc.data()?['likedBy'] ?? []);

    if (likedBy.contains(userId)) {
      // Retirer le like
      await ref.update({
        'likedBy': FieldValue.arrayRemove([userId]),
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      // Ajouter le like
      await ref.update({
        'likedBy': FieldValue.arrayUnion([userId]),
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  // ─── COMMENTAIRES ────────────────────────────────────────

  /// Stream des commentaires d'un post
  Stream<List<CommentModel>> watchComments(String postId) {
    return _db
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map(CommentModel.fromFirestore).toList();
      // Trier côté client — du plus ancien au plus récent
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return list;
    });
  }

  /// Ajouter un commentaire
  Future<void> addComment(CommentModel comment) async {
    await _db.collection('comments').add(comment.toMap());
    // Incrémenter le compteur de commentaires sur le post
    await _db.collection('posts').doc(comment.postId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }

  /// Supprimer un commentaire
  Future<void> deleteComment(String commentId, String postId) async {
    await _db.collection('comments').doc(commentId).delete();
    await _db.collection('posts').doc(postId).update({
      'commentsCount': FieldValue.increment(-1),
    });
  }
}