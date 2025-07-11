// lib/presentation/widgets/home/skin_progress_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scan_provider.dart';

class SkinProgressCard extends ConsumerWidget {
  const SkinProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanControllerProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Skin Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/progress'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          scanState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stack) => const Text(
              'Unable to load progress data',
              style: TextStyle(color: Colors.grey),
            ),
            data: (scanResults) {
              if (scanResults.isEmpty) {
                return Column(
                  children: [
                    Icon(
                      Icons.insights,
                      size: 48,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No scan data yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Take your first scan to track progress',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }

              final latestScan = scanResults.first;
              final previousScan = scanResults.length > 1 ? scanResults[1] : null;
              final progressChange = previousScan != null
                  ? latestScan.overallScore - previousScan.overallScore
                  : 0;

              return Column(
                children: [
                  // Current score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Current Score',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '${latestScan.overallScore}/100',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(latestScan.overallScore),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Progress indicator
                  LinearProgressIndicator(
                    value: latestScan.overallScore / 100,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getScoreColor(latestScan.overallScore),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Progress change
                  if (previousScan != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Since last scan',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Row(
                          children: [
                            Icon(
                              progressChange >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              size: 16,
                              color: progressChange >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${progressChange > 0 ? '+' : ''}$progressChange',
                              style: TextStyle(
                                fontSize: 12,
                                color: progressChange >= 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}