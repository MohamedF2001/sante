import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/forum_service.dart';
import '../../domain/post_model.dart';

final forumServiceProvider = Provider<ForumService>((ref) => ForumService());

final postsProvider = StreamProvider<List<PostModel>>((ref) {
  return ref.watch(forumServiceProvider).getPosts();
});
