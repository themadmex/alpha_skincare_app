// lib/presentation/widgets/progress/progress_overview.dart
import 'package:flutter/material.dart';
import '../../../domain/entities/scan_result.dart';
import '../scan/analysis_chart.dart';

class ProgressOverview extends StatelessWidget {
  final List<ScanResult> scanResults;

  const ProgressOverview({super.key, required this.scanResults});

  @override
  Widget build(BuildContext context) {
    final latestResult = scanResults.first;
    final firstResult = scanResults.last;
    final progressChange = latestResult.overallScore - firstResult.overallScore;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Current Score',
                  '${latestResult.overallScore}',
                  Icons.face,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Total Scans',
                  '${scanResults.length}',
                  Icons.camera_alt,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Progress',
                  '${progressChange > 0 ? '+' : ''}$progressChange',
                  progressChange >= 0 ? Icons.trending_up : Icons.trending_down,
                  progressChange >= 0 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Days Tracked',
                  '${_calculateDaysTracked()}',
                  Icons.calendar_today,
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Progress chart
          const Text(
            'Progress Over Time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          AnalysisChart(scanResults: scanResults),

          const SizedBox(height: 24),

          // Recent improvements
          const Text(
            'Recent Improvements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...latestResult.analysisResults.entries.map((entry) {
            final improvement = _calculateImprovement(entry.key, entry.value);
            return _buildImprovementItem(
              _formatMetricName(entry.key),
              improvement,
            );
          }),

          const SizedBox(height: 24),

          // Milestones
          _buildMilestonesSection(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementItem(String metric, double improvement) {
    final isImprovement = improvement >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            metric,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              Icon(
                isImprovement ? Icons.trending_up : Icons.trending_down,
                size: 16,
                color: isImprovement ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                '${improvement > 0 ? '+' : ''}${improvement.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: isImprovement ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber[700]),
              const SizedBox(width: 8),
              Text(
                'Milestones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMilestone('First Scan Completed', true),
          _buildMilestone('7 Days of Tracking', scanResults.length >= 7),
          _buildMilestone('30 Days of Tracking', _calculateDaysTracked() >= 30),
          _buildMilestone('Score Above 80', scanResults.first.overallScore >= 80),
        ],
      ),
    );
  }

  Widget _buildMilestone(String title, bool achieved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            achieved ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: achieved ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: achieved ? Colors.black : Colors.grey,
              decoration: achieved ? null : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDaysTracked() {
    if (scanResults.length < 2) return 1;
    return scanResults.first.createdAt.difference(scanResults.last.createdAt).inDays + 1;
  }

  double _calculateImprovement(String metric, double currentValue) {
    if (scanResults.length < 2) return 0.0;

    final firstResult = scanResults.last;
    final firstValue = firstResult.analysisResults[metric] ?? 0.0;

    return ((currentValue - firstValue) * 100);
  }

  String _formatMetricName(String key) {
    return key.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }
}