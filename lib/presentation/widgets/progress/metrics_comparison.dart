// lib/presentation/widgets/progress/metrics_comparison.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../domain/entities/scan_result.dart';

class MetricsComparison extends StatefulWidget {
  final List<ScanResult> scanResults;

  const MetricsComparison({super.key, required this.scanResults});

  @override
  State<MetricsComparison> createState() => _MetricsComparisonState();
}

class _MetricsComparisonState extends State<MetricsComparison> {
  String _selectedTimeRange = '3 months';
  final List<String> _timeRanges = ['1 month', '3 months', '6 months', 'All time'];

  @override
  Widget build(BuildContext context) {
    if (widget.scanResults.length < 2) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Not enough data for comparison',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Take at least 2 scans to see metrics comparison',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final filteredResults = _getFilteredResults();
    final latestResult = filteredResults.first;
    final firstResult = filteredResults.last;
    final allMetrics = _getAllMetrics(filteredResults);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time range selector
          _buildTimeRangeSelector(),
          const SizedBox(height: 24),

          // Overall progress summary
          _buildProgressSummary(latestResult, firstResult),
          const SizedBox(height: 24),

          // Radar chart for latest vs first scan
          _buildRadarChart(latestResult, firstResult),
          const SizedBox(height: 24),

          // Individual metric trends
          _buildMetricTrends(allMetrics, filteredResults),
          const SizedBox(height: 24),

          // Improvement highlights
          _buildImprovementHighlights(latestResult, firstResult),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Time Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _timeRanges.map((range) {
              final isSelected = _selectedTimeRange == range;
              return FilterChip(
                label: Text(range),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedTimeRange = range;
                    });
                  }
                },
                backgroundColor: Colors.grey.withOpacity(0.1),
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                checkmarkColor: Theme.of(context).primaryColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSummary(ScanResult latest, ScanResult first) {
    final overallChange = latest.overallScore - first.overallScore;
    final isImprovement = overallChange >= 0;
    final daysDifference = latest.createdAt.difference(first.createdAt).inDays;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isImprovement ? Colors.green : Colors.orange,
            (isImprovement ? Colors.green : Colors.orange).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Over $daysDifference days',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        isImprovement ? Icons.trending_up : Icons.trending_down,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${overallChange > 0 ? '+' : ''}$overallChange',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'points',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScoreIndicator('First Scan', first.overallScore),
              Icon(
                Icons.arrow_forward,
                color: Colors.white.withOpacity(0.7),
              ),
              _buildScoreIndicator('Latest Scan', latest.overallScore),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator(String label, int score) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$score',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRadarChart(ScanResult latest, ScanResult first) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metrics Comparison',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: RadarChart(
              RadarChartData(
                dataSets: [
                  RadarDataSet(
                    dataEntries: _getRadarEntries(first),
                    fillColor: Colors.blue.withOpacity(0.1),
                    borderColor: Colors.blue,
                    borderWidth: 2,
                  ),
                  RadarDataSet(
                    dataEntries: _getRadarEntries(latest),
                    fillColor: Colors.green.withOpacity(0.1),
                    borderColor: Colors.green,
                    borderWidth: 2,
                  ),
                ],
                radarShape: RadarShape.polygon,
                radarBorderData: const BorderSide(color: Colors.transparent),
                titleTextStyle: const TextStyle(fontSize: 12),
                gridBorderData: BorderSide(color: Colors.grey.withOpacity(0.3)),
                radarBackgroundColor: Colors.transparent,
                tickBorderData: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ticksTextStyle: const TextStyle(fontSize: 10, color: Colors.grey),
                titlePositionPercentageOffset: 0.2,
                getTitle: (index, angle) {
                  final metrics = latest.analysisResults.keys.toList();
                  if (index < metrics.length) {
                    return RadarChartTitle(
                      text: _formatMetricName(metrics[index]),
                      angle: angle,
                    );
                  }
                  return const RadarChartTitle(text: '');
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('First Scan', Colors.blue),
              const SizedBox(width: 20),
              _buildLegendItem('Latest Scan', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 2,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMetricTrends(List<String> metrics, List<ScanResult> results) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Individual Metric Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...metrics.map((metric) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildMetricTrendCard(metric, results),
          )),
        ],
      ),
    );
  }

  Widget _buildMetricTrendCard(String metric, List<ScanResult> results) {
    final values = results.map((r) => r.getMetricScore(metric) * 100).toList();
    final latest = values.first;
    final first = values.last;
    final change = latest - first;
    final isImprovement = change >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatMetricName(metric),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
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
                    '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isImprovement ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (values.length - 1).toDouble(),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: values.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value);
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        isImprovement ? Colors.green : Colors.orange,
                        (isImprovement ? Colors.green : Colors.orange).withOpacity(0.5),
                      ],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          (isImprovement ? Colors.green : Colors.orange).withOpacity(0.1),
                          (isImprovement ? Colors.green : Colors.orange).withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'From: ${first.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                'To: ${latest.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementHighlights(ScanResult latest, ScanResult first) {
    final improvements = <String, double>{};
    final concerns = <String, double>{};

    for (final metric in latest.analysisResults.keys) {
      final change = (latest.getMetricScore(metric) - first.getMetricScore(metric)) * 100;
      if (change >= 5) {
        improvements[metric] = change;
      } else if (change <= -5) {
        concerns[metric] = change.abs();
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Changes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (improvements.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.green[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Improvements',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...improvements.entries.map((entry) =>
                _buildChangeItem(entry.key, entry.value, true)),
            const SizedBox(height: 16),
          ],

          if (concerns.isNotEmpty) ...[
            Row(
              children: [
                Icon(Icons.trending_down, color: Colors.red[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Areas for Attention',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...concerns.entries.map((entry) =>
                _buildChangeItem(entry.key, entry.value, false)),
          ],

          if (improvements.isEmpty && concerns.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'No significant changes detected between scans. Continue your skincare routine for gradual improvements.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChangeItem(String metric, double change, bool isImprovement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isImprovement ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              _formatMetricName(metric),
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            '${isImprovement ? '+' : '-'}${change.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isImprovement ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  List<ScanResult> _getFilteredResults() {
    if (_selectedTimeRange == 'All time') {
      return widget.scanResults;
    }

    final now = DateTime.now();
    int daysToSubtract;

    switch (_selectedTimeRange) {
      case '1 month':
        daysToSubtract = 30;
        break;
      case '3 months':
        daysToSubtract = 90;
        break;
      case '6 months':
        daysToSubtract = 180;
        break;
      default:
        return widget.scanResults;
    }

    final cutoffDate = now.subtract(Duration(days: daysToSubtract));
    return widget.scanResults
        .where((result) => result.createdAt.isAfter(cutoffDate))
        .toList();
  }

  List<String> _getAllMetrics(List<ScanResult> results) {
    if (results.isEmpty) return [];
    return results.first.analysisResults.keys.toList();
  }

  List<RadarEntry> _getRadarEntries(ScanResult result) {
    return result.analysisResults.entries.map((entry) {
      return RadarEntry(value: entry.value * 100);
    }).toList();
  }

  String _formatMetricName(String key) {
    return key.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }
}