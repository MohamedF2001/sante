import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/utils/date_formatter.dart';
import 'package:sante_famille/features/auth/presentation/providers/auth_provider.dart';
import 'package:sante_famille/features/forum/domain/post_model.dart';
import '../providers/forum_provider.dart';

class ForumScreen extends ConsumerWidget {
  const ForumScreen({super.key});

  void _showCreatePost(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Poser une question',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Décrivez votre situation ou posez votre question...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isEmpty) return;

                final user = ref.read(userProfileProvider).valueOrNull;
                final auth = ref.read(authStateProvider).valueOrNull;

                if (auth == null) return;

                final post = PostModel(
                  id: '',
                  userId: auth.uid,
                  userName: user != null ? '${user.prenom} ${user.nom}' : 'Parent',
                  content: controller.text.trim(),
                  date: DateTime.now(),
                );

                await ref.read(forumServiceProvider).createPost(post);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Publier'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Forum - Entraide Parents')),
      body: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('Aucun message pour le moment.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primarySurface,
                            child: Text(post.userName[0].toUpperCase()),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  DateFormatter.timeAgo(post.date),
                                  style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(post.content),
                      const SizedBox(height: 12),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                            onPressed: () => ref.read(forumServiceProvider).likePost(post.id),
                            icon: const Icon(Icons.thumb_up_outlined, size: 20),
                            label: Text('${post.likes}'),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.comment_outlined, size: 20),
                            label: Text('${post.commentCount}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Erreur: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePost(context, ref),
        label: const Text('Question'),
        icon: const Icon(Icons.add_comment),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
