// lib/domain/entities/analysis_metric.dart
import 'dart:ui';

class AnalysisMetric {
  final String name;
  final double score; // 0.0 to 1.0
  final double severity; // 0.0 to 1.0 (higher means more concerning)
  final String description;
  final List<String> recommendations;
  final Map<String, dynamic> metadata;

  const AnalysisMetric({
    required this.name,
    required this.score,
    required this.severity,
    required this.description,
    required this.recommendations,
    this.metadata = const {},
  });

  String get scorePercentage => '${(score * 100).round()}%';

  String get severityLevel {
    if (severity >= 0.8) return 'High';
    if (severity >= 0.5) return 'Medium';
    if (severity >= 0.2) return 'Low';
    return 'Minimal';
  }

  Color get severityColor {
    if (severity >= 0.8) return const Color(0xFFF44336); // Red
    if (severity >= 0.5) return const Color(0xFFFF9800); // Orange
    if (severity >= 0.2) return const Color(0xFFFFC107); // Yellow
    return const Color(0xFF4CAF50); // Green
  }

  AnalysisMetric copyWith({
    String? name,
    double? score,
    double? severity,
    String? description,
    List<String>? recommendations,
    Map<String, dynamic>? metadata,
  }) {
    return AnalysisMetric(
      name: name ?? this.name,
      score: score ?? this.score,
      severity: severity ?? this.severity,
      description: description ?? this.description,
      recommendations: recommendations ?? this.recommendations,
      metadata: metadata ?? this.metadata,
    );
  }
}