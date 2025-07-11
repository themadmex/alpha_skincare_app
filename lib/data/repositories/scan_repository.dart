// lib/data/repositories/scan_repository_impl.dart
import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_repository.dart';

class ScanRepositoryImpl implements ScanRepository {
  // In a real app, this would be stored in a database
  final List<ScanResult> _scanResults = [];

  @override
  Future<ScanResult> analyzeSkin(String imagePath) async {
    // Mock analysis - in real app, this would use ML model
    await Future.delayed(const Duration(seconds: 3));

    final analysisResults = {
      'acne': 0.2 + (DateTime.now().millisecond % 100) / 500,
      'wrinkles': 0.1 + (DateTime.now().millisecond % 100) / 600,
      'dark_spots': 0.3 + (DateTime.now().millisecond % 100) / 400,
      'skin_tone': 0.7 + (DateTime.now().millisecond % 100) / 300,
      'texture': 0.6 + (DateTime.now().millisecond % 100) / 400,
      'hydration': 0.5 + (DateTime.now().millisecond % 100) / 500,
      'pores': 0.4 + (DateTime.now().millisecond % 100) / 400,
      'redness': 0.2 + (DateTime.now().millisecond % 100) / 600,
    };

    final overallScore = ((analysisResults.values.reduce((a, b) => a + b) / analysisResults.length) * 100).round();

    final recommendations = [
      'Use a gentle cleanser twice daily',
      'Apply sunscreen with SPF 30+ every morning',
      'Consider using a retinol serum for anti-aging',
      'Keep your skin hydrated with a good moisturizer',
      'Exfoliate 1-2 times per week to improve texture',
    ];

    final result = ScanResult(
      id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'mock_user_id',
      imagePath: imagePath,
      overallScore: overallScore,
      analysisResults: analysisResults,
      recommendations: recommendations,
      createdAt: DateTime.now(),
    );

    _scanResults.insert(0, result);
    return result;
  }

  @override
  Future<List<ScanResult>> getScanHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock data if empty
    if (_scanResults.isEmpty) {
      await _generateMockData(userId);
    }

    return _scanResults.where((result) => result.userId == userId).toList();
  }

  @override
  Future<ScanResult?> getScanResult(String scanId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _scanResults.firstWhere((result) => result.id == scanId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteScanResult(String scanId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _scanResults.removeWhere((result) => result.id == scanId);
  }

  @override
  Future<List<ScanResult>> getRecentScans(String userId, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate mock data if empty
    if (_scanResults.isEmpty) {
      await _generateMockData(userId);
    }

    return _scanResults
        .where((result) => result.userId == userId)
        .take(limit)
        .toList();
  }

  Future<void> _generateMockData(String userId) async {
    // Generate 5 mock scan results
    for (int i = 0; i < 5; i++) {
      final daysAgo = i * 7;
      final analysisResults = {
        'acne': 0.2 + (i * 0.1),
        'wrinkles': 0.1 + (i * 0.05),
        'dark_spots': 0.3 + (i * 0.08),
        'skin_tone': 0.7 - (i * 0.02),
        'texture': 0.6 + (i * 0.05),
        'hydration': 0.5 + (i * 0.07),
        'pores': 0.4 + (i * 0.06),
        'redness': 0.2 + (i * 0.03),
      };

      final overallScore = ((analysisResults.values.reduce((a, b) => a + b) / analysisResults.length) * 100).round();

      final result = ScanResult(
        id: 'scan_mock_${i}',
        userId: userId,
        imagePath: 'mock_image_${i}.jpg',
        overallScore: overallScore,
        analysisResults: analysisResults,
        recommendations: [
          'Use a gentle cleanser twice daily',
          'Apply sunscreen with SPF 30+ every morning',
          'Consider using a retinol serum for anti-aging',
        ],
        createdAt: DateTime.now().subtract(Duration(days: daysAgo)),
      );

      _scanResults.add(result);
    }
  }
}