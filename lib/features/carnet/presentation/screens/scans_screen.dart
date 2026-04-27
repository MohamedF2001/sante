import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sante_famille/core/constants/app_colors.dart';
import 'package:sante_famille/core/utils/date_formatter.dart';
import 'package:sante_famille/features/auth/presentation/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/carnet_provider.dart';

class ScansScreen extends ConsumerStatefulWidget {
  const ScansScreen({super.key});

  @override
  ConsumerState<ScansScreen> createState() => _ScansScreenState();
}

class _ScansScreenState extends ConsumerState<ScansScreen> {
  bool _isUploading = false;

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() => _isUploading = true);
    try {
      final user = ref.read(authStateProvider).valueOrNull;
      if (user == null) return;

      await ref.read(carnetServiceProvider).uploadScan(user.uid, File(image.path));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document ajouté avec succès !'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scansAsync = ref.watch(scansProvider);

    return Scaffold(
      appBar: _isUploading ? null : AppBar(
        title: const Text('Mes Documents', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                'MODE DEMO',
                style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
      body: _isUploading
          ? const Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Téléchargement du document...'),
              ],
            ))
          : scansAsync.when(
              data: (scans) {
                if (scans.isEmpty) {
                  return const Center(child: Text('Aucun document scanné.'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: scans.length,
                  itemBuilder: (context, index) {
                    final scan = scans[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: scan.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[200]),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              DateFormatter.formatDate(scan.date),
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Erreur: $e')),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndUpload,
        backgroundColor: AppColors.primary,
        tooltip: 'Scanner un document',
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }
}
