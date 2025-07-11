// lib/domain/entities/skin_analysis.dart
import 'analysis_metric.dart';

class SkinAnalysis {
  final String id;
  final String userId;
  final String imagePath;
  final Map<String, AnalysisMetric> metrics;
  final DateTime analyzedAt;
  final String modelVersion;
  final double confidence;

  const SkinAnalysis({
    required this.id,
    required this.userId,
    required this.imagePath,
    required this.metrics,
    required this.analyzedAt,
    required this.modelVersion,
    required this.confidence,
  });

  double get overallScore {
    if (metrics.isEmpty) return 0.0;
    final total = metrics.values.map((m) => m.score).reduce((a, b) => a + b);
    return total / metrics.length;
  }

  List<String> get topConcerns {
    final sortedMetrics = metrics.entries.toList()
      ..sort((a, b) => b.value.severity.compareTo(a.value.severity));

    return sortedMetrics
        .where((entry) => entry.value.severity >= 0.7)
        .map((entry) => entry.key)
        .take(3)
        .toList();
  }

  SkinAnalysis copyWith({
    String? id,
    String? userId,
    String? imagePath,
    Map<String, AnalysisMetric>? metrics,
    DateTime? analyzedAt,
    String? modelVersion,
    double? confidence,
  }) {
    return SkinAnalysis(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imagePath: imagePath ?? this.imagePath,
      metrics: metrics ?? this.metrics,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      modelVersion: modelVersion ?? this.modelVersion,
      confidence: confidence ?? this.confidence,
    );
  }
}