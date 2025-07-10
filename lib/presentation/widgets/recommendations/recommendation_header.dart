// lib/presentation/widgets/recommendations/recommendation_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/profile_provider.dart';

class RecommendationHeader extends ConsumerWidget {
  const RecommendationHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Text('Error loading profile'),
        data: (profile) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 8),
                Text(
                  'Your Skin Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildProfileItem('Skin Type', profile.skinType),
                ),
                Expanded(
                  child: _buildProfileItem('Age', '${profile.age} years'),
                ),
              ],
            ),

            if (profile.skinConcerns.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Concerns: ${profile.skinConcerns.join(', ')}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recommendations based on your profile',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/scan'),
                  child: const Text(
                    'Update Analysis',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}