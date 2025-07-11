// lib/domain/entities/scan_result.dart
class ScanResult {
  final String id;
  final String userId;
  final String imagePath;
  final int overallScore;
  final Map<String, double> analysisResults;
  final List<String> recommendations;
  final Map<String, dynamic>? detailedAnalysis;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ScanResult({
    required this.id,
    required this.userId,
    required this.imagePath,
    required this.overallScore,
    required this.analysisResults,
    required this.recommendations,
    this.detailedAnalysis,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  ScanResult copyWith({
    String? id,
    String? userId,
    String? imagePath,
    int? overallScore,
    Map<String, double>? analysisResults,
    List<String>? recommendations,
    Map<String, dynamic>? detailedAnalysis,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScanResult(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imagePath: imagePath ?? this.imagePath,
      overallScore: overallScore ?? this.overallScore,
      analysisResults: analysisResults ?? this.analysisResults,
      recommendations: recommendations ?? this.recommendations,
      detailedAnalysis: detailedAnalysis ?? this.detailedAnalysis,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imagePath': imagePath,
      'overallScore': overallScore,
      'analysisResults': analysisResults,
      'recommendations': recommendations,
      'detailedAnalysis': detailedAnalysis,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      id: json['id'] as String,
      userId: json['userId'] as String,
      imagePath: json['imagePath'] as String,
      overallScore: json['overallScore'] as int,
      analysisResults: Map<String, double>.from(
        (json['analysisResults'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      recommendations: List<String>.from(json['recommendations'] as List),
      detailedAnalysis: json['detailedAnalysis'] as Map<String, dynamic>?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  // Helper methods for analysis results
  double getMetricScore(String metric) {
    return analysisResults[metric] ?? 0.0;
  }

  List<MapEntry<String, double>> get sortedMetrics {
    final entries = analysisResults.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  List<String> get concerningMetrics {
    return analysisResults.entries
        .where((entry) => entry.value < 0.5)
        .map((entry) => entry.key)
        .toList();
  }

  List<String> get goodMetrics {
    return analysisResults.entries
        .where((entry) => entry.value >= 0.7)
        .map((entry) => entry.key)
        .toList();
  }

  String get scoreCategory {
    if (overallScore >= 80) return 'Excellent';
    if (overallScore >= 60) return 'Good';
    if (overallScore >= 40) return 'Fair';
    return 'Needs Attention';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ScanResult(id: $id, userId: $userId, overallScore: $overallScore, createdAt: $createdAt)';
  }
}