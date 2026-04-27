import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime date;
  final int likes;
  final int commentCount;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.date,
    this.likes = 0,
    this.commentCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'content': content,
      'date': Timestamp.fromDate(date),
      'likes': likes,
      'commentCount': commentCount,
    };
  }

  factory PostModel.fromFirestore(Map<String, dynamic> map, String id) {
    return PostModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonyme',
      content: map['content'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      likes: map['likes'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
    );
  }
}
