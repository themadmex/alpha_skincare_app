enum AnalysisStatus { processing, completed, failed }

class SkinAnalysis {
  final String id;
  final String userId;
  final DateTime analysisDate;
  final String imageUrl;
  final String? thumbnailUrl;
  final int? overallScore;
  final AnalysisStatus status;
  final Map<String, dynamic> metrics;
  final Map<String, dynamic> aiAnalysisResults;
  final double? processingTimeSeconds;
  final double? confidenceScore;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SkinAnalysis({
    required this.id,
    required this.userId,
    required this.analysisDate,
    required this.imageUrl,
    this.thumbnailUrl,
    this.overallScore,
    required this.status,
    required this.metrics,
    required this.aiAnalysisResults,
    this.processingTimeSeconds,
    this.confidenceScore,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SkinAnalysis.fromJson(Map<String, dynamic> json) {
    return SkinAnalysis(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      analysisDate: DateTime.parse(json['analysis_date']),
      imageUrl: json['image_url'] as String,
      thumbnailUrl: json['thumbnail_url'],
      overallScore: json['overall_score']?.toInt(),
      status: AnalysisStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AnalysisStatus.processing,
      ),
      metrics: Map<String, dynamic>.from(json['metrics'] ?? {}),
      aiAnalysisResults:
          Map<String, dynamic>.from(json['ai_analysis_results'] ?? {}),
      processingTimeSeconds: json['processing_time_seconds']?.toDouble(),
      confidenceScore: json['confidence_score']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'analysis_date': analysisDate.toIso8601String(),
      'image_url': imageUrl,
      'thumbnail_url': thumbnailUrl,
      'overall_score': overallScore,
      'status': status.name,
      'metrics': metrics,
      'ai_analysis_results': aiAnalysisResults,
      'processing_time_seconds': processingTimeSeconds,
      'confidence_score': confidenceScore,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  SkinAnalysis copyWith({
    String? id,
    String? userId,
    DateTime? analysisDate,
    String? imageUrl,
    String? thumbnailUrl,
    int? overallScore,
    AnalysisStatus? status,
    Map<String, dynamic>? metrics,
    Map<String, dynamic>? aiAnalysisResults,
    double? processingTimeSeconds,
    double? confidenceScore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SkinAnalysis(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      analysisDate: analysisDate ?? this.analysisDate,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      overallScore: overallScore ?? this.overallScore,
      status: status ?? this.status,
      metrics: metrics ?? this.metrics,
      aiAnalysisResults: aiAnalysisResults ?? this.aiAnalysisResults,
      processingTimeSeconds:
          processingTimeSeconds ?? this.processingTimeSeconds,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isCompleted => status == AnalysisStatus.completed;
  bool get isProcessing => status == AnalysisStatus.processing;
  bool get hasFailed => status == AnalysisStatus.failed;
}

class SkinMetric {
  final String id;
  final String analysisId;
  final String metricName;
  final int score;
  final String improvementStatus;
  final int? previousScore;
  final double confidence;
  final Map<String, dynamic> details;
  final DateTime createdAt;

  const SkinMetric({
    required this.id,
    required this.analysisId,
    required this.metricName,
    required this.score,
    required this.improvementStatus,
    this.previousScore,
    required this.confidence,
    required this.details,
    required this.createdAt,
  });

  factory SkinMetric.fromJson(Map<String, dynamic> json) {
    return SkinMetric(
      id: json['id'] as String,
      analysisId: json['analysis_id'] as String,
      metricName: json['metric_name'] as String,
      score: json['score'] as int,
      improvementStatus: json['improvement_status'] as String,
      previousScore: json['previous_score']?.toInt(),
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      details: Map<String, dynamic>.from(json['details'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'analysis_id': analysisId,
      'metric_name': metricName,
      'score': score,
      'improvement_status': improvementStatus,
      'previous_score': previousScore,
      'confidence': confidence,
      'details': details,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
