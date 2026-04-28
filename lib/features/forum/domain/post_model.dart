// ============================================================
// lib/features/forum/domain/post_model.dart
// ============================================================

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String userNom;
  final String contenu;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final String? categorie;
  final List<String> likedBy; // UIDs des gens qui ont liké

  PostModel({
    required this.id,
    required this.userId,
    required this.userNom,
    required this.contenu,
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.categorie,
    this.likedBy = const [],
  });

  bool isLikedBy(String uid) => likedBy.contains(uid);

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      userId: d['userId'] ?? '',
      userNom: d['userNom'] ?? 'Anonyme',
      contenu: d['contenu'] ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likesCount: d['likesCount'] ?? 0,
      commentsCount: d['commentsCount'] ?? 0,
      categorie: d['categorie'],
      likedBy: List<String>.from(d['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userNom': userNom,
    'contenu': contenu,
    'createdAt': FieldValue.serverTimestamp(),
    'likesCount': likesCount,
    'commentsCount': commentsCount,
    'categorie': categorie,
    'likedBy': likedBy,
  };
}

// ============================================================
// CommentModel
// ============================================================

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String userNom;
  final String contenu;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userNom,
    required this.contenu,
    required this.createdAt,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      postId: d['postId'] ?? '',
      userId: d['userId'] ?? '',
      userNom: d['userNom'] ?? 'Anonyme',
      contenu: d['contenu'] ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'postId': postId,
    'userId': userId,
    'userNom': userNom,
    'contenu': contenu,
    'createdAt': FieldValue.serverTimestamp(),
  };
}