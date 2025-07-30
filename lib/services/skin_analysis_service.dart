import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../services/supabase_service.dart';
import '../services/auth_service.dart';
import '../models/skin_analysis.dart';

class SkinAnalysisService {
  static final SkinAnalysisService _instance = SkinAnalysisService._internal();
  factory SkinAnalysisService() => _instance;
  SkinAnalysisService._internal();

  final SupabaseService _supabaseService = SupabaseService();
  final AuthService _authService = AuthService();

  // Create new skin analysis
  Future<SkinAnalysis> createAnalysis({
    required String imageUrl,
    String? thumbnailUrl,
  }) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('User not authenticated');

      // Create initial analysis record
      final response = await _supabaseService.from('skin_analyses');
      final data = await response
          .insert({
            'user_id': user.id,
            'image_url': imageUrl,
            'thumbnail_url': thumbnailUrl,
            'status': 'processing',
            'analysis_date': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final analysis = SkinAnalysis.fromJson(data);

      // Start AI analysis in background
      _processAnalysis(analysis.id);

      return analysis;
    } catch (e) {
      throw Exception('Failed to create analysis: $e');
    }
  }

  // Process AI analysis (simulated)
  Future<void> _processAnalysis(String analysisId) async {
    try {
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 3));

      // Generate mock AI analysis results
      final mockResults = _generateMockAnalysisResults();

      // Update analysis with results
      final response = await _supabaseService.from('skin_analyses');
      await response.update({
        'status': 'completed',
        'overall_score': mockResults['overall_score'],
        'metrics': mockResults['metrics'],
        'ai_analysis_results': mockResults['ai_analysis_results'],
        'confidence_score': mockResults['confidence_score'],
        'processing_time_seconds': mockResults['processing_time_seconds'],
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', analysisId);

      // Create detailed metrics
      await _createDetailedMetrics(analysisId, mockResults['metrics']);

      // Decrement user's scan count
      final user = await _authService.getCurrentUser();
      if (user != null) {
        await _authService.decrementScanCount(user.id);
      }
    } catch (e) {
      // Mark analysis as failed
      await _markAnalysisAsFailed(analysisId);
    }
  }

  // Generate mock AI analysis results
  Map<String, dynamic> _generateMockAnalysisResults() {
    final random = Random();

    final metrics = {
      'wrinkles': 70 + random.nextInt(25), // 70-95
      'dark_spots': 60 + random.nextInt(30), // 60-90
      'hydration': 65 + random.nextInt(25), // 65-90
      'texture': 70 + random.nextInt(25), // 70-95
      'pore_visibility': 60 + random.nextInt(30), // 60-90
      'redness': 75 + random.nextInt(20), // 75-95
      'skin_tone_evenness': 70 + random.nextInt(25), // 70-95
    };

    final overallScore =
        (metrics.values.reduce((a, b) => a + b) / metrics.length).round();

    return {
      'overall_score': overallScore,
      'metrics': metrics,
      'confidence_score': 0.85 + (random.nextDouble() * 0.1), // 0.85-0.95
      'processing_time_seconds':
          2.5 + (random.nextDouble() * 2), // 2.5-4.5 seconds
      'ai_analysis_results': {
        'skin_age_estimate': 25 + random.nextInt(20),
        'primary_concerns': _getRandomConcerns(random),
        'skin_type_prediction': [
          'normal',
          'oily',
          'dry',
          'combination',
          'sensitive'
        ][random.nextInt(5)],
        'improvement_areas': _getImprovementAreas(metrics),
      },
    };
  }

  List<String> _getRandomConcerns(Random random) {
    final allConcerns = [
      'wrinkles',
      'dark_spots',
      'dryness',
      'acne',
      'sensitivity',
      'pores',
      'redness'
    ];
    final numConcerns = 2 + random.nextInt(3); // 2-4 concerns
    allConcerns.shuffle(random);
    return allConcerns.take(numConcerns).toList();
  }

  List<String> _getImprovementAreas(Map<String, dynamic> metrics) {
    final areas = <String>[];
    metrics.forEach((key, value) {
      if (value < 75) {
        areas.add(key);
      }
    });
    return areas;
  }

  // Create detailed metrics records
  Future<void> _createDetailedMetrics(
      String analysisId, Map<String, dynamic> metrics) async {
    final metricsData = metrics.entries.map((entry) {
      final random = Random();
      return {
        'analysis_id': analysisId,
        'metric_name': _formatMetricName(entry.key),
        'score': entry.value,
        'improvement_status': _getRandomImprovementStatus(random),
        'confidence': 0.8 + (random.nextDouble() * 0.15), // 0.8-0.95
        'details': {
          'category': _getMetricCategory(entry.key),
          'recommendations': _getMetricRecommendations(entry.key),
        },
      };
    }).toList();

    final response = await _supabaseService.from('skin_metrics');
    await response.insert(metricsData);
  }

  String _formatMetricName(String key) {
    switch (key) {
      case 'wrinkles':
        return 'Wrinkles & Fine Lines';
      case 'dark_spots':
        return 'Dark Spots & Hyperpigmentation';
      case 'hydration':
        return 'Hydration Levels';
      case 'texture':
        return 'Skin Texture & Smoothness';
      case 'pore_visibility':
        return 'Pore Visibility';
      case 'redness':
        return 'Redness & Inflammation';
      case 'skin_tone_evenness':
        return 'Skin Tone Evenness';
      default:
        return key.replaceAll('_', ' ').toUpperCase();
    }
  }

  String _getRandomImprovementStatus(Random random) {
    return ['improved', 'stable', 'declined'][random.nextInt(3)];
  }

  String _getMetricCategory(String key) {
    if (['wrinkles', 'texture'].contains(key)) return 'Anti-Aging';
    if (['dark_spots', 'skin_tone_evenness'].contains(key))
      return 'Brightening';
    if (['hydration'].contains(key)) return 'Hydration';
    if (['redness', 'pore_visibility'].contains(key)) return 'Skin Health';
    return 'General';
  }

  List<String> _getMetricRecommendations(String key) {
    switch (key) {
      case 'wrinkles':
        return [
          'Use retinol products',
          'Apply sunscreen daily',
          'Consider anti-aging serums'
        ];
      case 'dark_spots':
        return [
          'Use vitamin C serum',
          'Apply broad-spectrum SPF',
          'Consider brightening treatments'
        ];
      case 'hydration':
        return [
          'Use hyaluronic acid',
          'Apply moisturizer twice daily',
          'Drink more water'
        ];
      case 'texture':
        return [
          'Gentle exfoliation',
          'Use AHA/BHA products',
          'Maintain consistent routine'
        ];
      default:
        return [
          'Maintain consistent skincare routine',
          'Consult with dermatologist'
        ];
    }
  }

  // Mark analysis as failed
  Future<void> _markAnalysisAsFailed(String analysisId) async {
    try {
      final response = await _supabaseService.from('skin_analyses');
      await response.update({
        'status': 'failed',
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', analysisId);
    } catch (e) {
      // Silent fail - we've already tried to update
    }
  }

  // Get user's analyses
  Future<List<SkinAnalysis>> getUserAnalyses({int limit = 10}) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) throw Exception('User not authenticated');

      final response = await _supabaseService.from('skin_analyses');
      final data = await response
          .select()
          .eq('user_id', user.id)
          .order('analysis_date', ascending: false)
          .limit(limit);

      return data
          .map<SkinAnalysis>((item) => SkinAnalysis.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch analyses: $e');
    }
  }

  // Get analysis by ID
  Future<SkinAnalysis?> getAnalysisById(String analysisId) async {
    try {
      final response = await _supabaseService.from('skin_analyses');
      final data = await response.select().eq('id', analysisId).single();

      return SkinAnalysis.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  // Get detailed metrics for analysis
  Future<List<SkinMetric>> getAnalysisMetrics(String analysisId) async {
    try {
      final response = await _supabaseService.from('skin_metrics');
      final data = await response
          .select()
          .eq('analysis_id', analysisId)
          .order('score', ascending: false);

      return data.map<SkinMetric>((item) => SkinMetric.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch metrics: $e');
    }
  }

  // Upload image to Supabase Storage
  Future<String> uploadImage(XFile imageFile, String userId) async {
    try {
      final storage = await _supabaseService.storage;
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'skin_analyses/$fileName';

      await storage.from('images').upload(filePath, File(imageFile.path));

      return storage.from('images').getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Get progress data
  Future<Map<String, dynamic>> getProgressData(String userId) async {
    try {
      final response = await _supabaseService.from('skin_analyses');
      final analyses = await response
          .select('analysis_date, overall_score, metrics')
          .eq('user_id', userId)
          .eq('status', 'completed')
          .order('analysis_date', ascending: true);

      if (analyses.isEmpty) return {};

      // Calculate progress trends
      final scores = analyses.map<int>((a) => a['overall_score'] ?? 0).toList();
      final latest = analyses.last;
      final previous =
          analyses.length > 1 ? analyses[analyses.length - 2] : null;

      return {
        'current_score': latest['overall_score'],
        'previous_score': previous?['overall_score'],
        'trend': _calculateTrend(scores),
        'total_analyses': analyses.length,
        'average_score': scores.isNotEmpty
            ? scores.reduce((a, b) => a + b) / scores.length
            : 0,
        'progress_data': analyses,
      };
    } catch (e) {
      throw Exception('Failed to fetch progress data: $e');
    }
  }

  String _calculateTrend(List<int> scores) {
    if (scores.length < 2) return 'stable';

    final recent = scores.sublist(scores.length - 3); // Last 3 scores
    final average = recent.reduce((a, b) => a + b) / recent.length;
    final previousAverage = scores.length > 3
        ? scores
                .sublist(scores.length - 6, scores.length - 3)
                .reduce((a, b) => a + b) /
            3
        : scores.first.toDouble();

    if (average > previousAverage + 2) return 'improving';
    if (average < previousAverage - 2) return 'declining';
    return 'stable';
  }
}
