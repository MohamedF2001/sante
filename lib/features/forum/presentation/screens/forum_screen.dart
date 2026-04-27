import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/features/forum/domain/post_model.dart';
import '../providers/forum_provider.dart';

class ForumScreen extends ConsumerWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: AppColors.vertBg,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ask a Pro'),
            Text('Questions validées par des médecins', style: TextStyle(fontSize: 12, color: AppColors.vertClair)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: postsAsync.when(
              data: (posts) {
                // Mock data to match mockup if empty
                final displayPosts = posts.isEmpty ? _mockPosts : posts;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: displayPosts.length,
                  itemBuilder: (context, index) {
                    final post = displayPosts[index];
                    return _buildForumCard(post);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Erreur: $e')),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildForumCard(dynamic post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [BoxShadow(color: AppColors.vertForet.withOpacity(0.06), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(color: AppColors.vertPastel, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(post.userName.contains('Dr.') ? '👩‍⚕️' : '👤', style: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.noirDoux)),
                  Text('Pédiatre · Répondu il y a 1h', style: const TextStyle(fontSize: 10, color: AppColors.grisTexte)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Fièvre après le vaccin DTC, normal ?', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.noirDoux)),
          const SizedBox(height: 4),
          Text(
            post.content,
            style: const TextStyle(fontSize: 11, color: AppColors.grisTexte, height: 1.6),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: AppColors.vertPastel, borderRadius: BorderRadius.circular(20)),
                child: const Text('Vaccination', style: TextStyle(color: AppColors.vertForet, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              const Text('💬 12 réponses', style: TextStyle(fontSize: 10, color: AppColors.grisTexte)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grisDoux)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(color: AppColors.vertBg, borderRadius: BorderRadius.circular(20)),
              child: const Text('Posez votre question...', style: TextStyle(color: AppColors.grisTexte, fontSize: 12)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(color: AppColors.vertForet, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Icon(Icons.arrow_upward, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  static final _mockPosts = [
    PostModel(id: '1', userId: '1', userName: 'Dr. Kossou Marie', content: 'Oui, une légère fièvre (38-38.5°C) dans les 24h après le DTC est tout à fait normale. Vous pouvez donner du paracétamol...', date: DateTime.now()),
  ];
}
