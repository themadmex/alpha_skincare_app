// lib/presentation/screens/scan/scan_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scan_provider.dart';
import '../../widgets/scan/result_card.dart';
import '../../widgets/scan/analysis_chart.dart';
import '../../widgets/common/custom_button.dart';

class ScanResultsScreen extends ConsumerWidget {
  const ScanResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing not implemented yet.')),
              );
            },
          ),
        ],
      ),
      body: scanState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Analysis failed: $error'),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Try Again',
                onPressed: () => context.go('/scan'),
              ),
            ],
          ),
        ),
        data: (scanResults) {
          if (scanResults.isEmpty) {
            return const Center(
              child: Text('No scan results available'),
            );
          }

          final latestResult = scanResults.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Scan date
                Text(
                  'Scanned on ${_formatDate(latestResult.createdAt)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Overall skin health score
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Skin Health Score',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${latestResult.overallScore}/100',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getScoreDescription(latestResult.overallScore),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Analysis breakdown
                const Text(
                  'Detailed Analysis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Analysis metrics
                ...latestResult.analysisResults.entries.map((entry) =>
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ResultCard(
                        title: _formatMetricName(entry.key),
                        score: entry.value,
                        description: _getMetricDescription(entry.key),
                      ),
                    ),
                ),

                const SizedBox(height: 24),

                // Analysis chart
                const Text(
                  'Progress Chart',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                AnalysisChart(scanResults: scanResults),
                const SizedBox(height: 24),

                // Recommendations section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Recommendations',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...latestResult.recommendations.map((rec) =>
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(top: 6, right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[700],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    rec,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'View Products',
                        onPressed: () => context.go('/recommendations'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: 'New Scan',
                        isOutlined: true,
                        onPressed: () => context.go('/scan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                CustomButton(
                  text: 'Save to Progress',
                  backgroundColor: Colors.green,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Results saved to progress!')),
                    );
                    context.go('/progress');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getScoreDescription(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Attention';
  }

  String _formatMetricName(String key) {
    return key.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  String _getMetricDescription(String metric) {
    switch (metric) {
      case 'acne':
        return 'Presence of acne, blackheads, and blemishes';
      case 'wrinkles':
        return 'Fine lines and wrinkles around eyes and mouth';
      case 'dark_spots':
        return 'Hyperpigmentation and age spots';
      case 'skin_tone':
        return 'Overall evenness of skin tone';
      case 'texture':
        return 'Skin smoothness and texture quality';
      case 'hydration':
        return 'Skin moisture and hydration levels';
      default:
        return 'Skin health metric analysis';
    }
  }
}