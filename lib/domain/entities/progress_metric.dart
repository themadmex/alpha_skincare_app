// lib/domain/entities/progress_metric.dart
class ProgressMetric {
  final String id;
  final String userId;
  final String metricType;
  final double value;
  final DateTime recordedAt;
  final String? notes;

  const ProgressMetric({
    required this.id,
    required this.userId,
    required this.metricType,
    required this.value,
    required this.recordedAt,
    this.notes,
  });

  ProgressMetric copyWith({
    String? id,
    String? userId,
    String? metricType,
    double? value,
    DateTime? recordedAt,
    String? notes,
  }) {
    return ProgressMetric(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      metricType: metricType ?? this.metricType,
      value: value ?? this.value,
      recordedAt: recordedAt ?? this.recordedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProgressMetric && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}