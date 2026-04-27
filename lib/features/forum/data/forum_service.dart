import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/post_model.dart';

class ForumService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<void> createPost(PostModel post) async {
    await _firestore.collection('posts').add(post.toMap());
  }

  Future<void> likePost(String postId) async {
    await _firestore.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }
}
