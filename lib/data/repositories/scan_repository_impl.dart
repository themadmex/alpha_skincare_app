// lib/data/repositories/scan_repository_impl.dart
import '../../domain/entities/scan_result.dart';
import '../../domain/repositories/scan_repository.dart';

class ScanRepositoryImpl implements ScanRepository {
  final List<ScanResult> _scanHistory = [];

  @override
  Future<ScanResult> analyzeSkin(String imagePath) async {
    // Simulate ML processing time
    await Future.delayed(const Duration(seconds: 3));

    // Mock analysis result
    final scanResult = ScanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id',
      imagePath: imagePath,
      timestamp: DateTime.now(),
      overallScore: 78.5,
      acneLevel: 23.2,
      wrinkleLevel: 15.8,
      darknessLevel: 12.5,
      rednessLevel: 8.3,
      recommendations: [
        'Use a gentle cleanser twice daily',
        'Apply moisturizer with SPF 30+',
        'Consider retinol treatment for fine lines',
      ],
      analysis: 'Your skin shows good overall health with minor concerns in acne-prone areas. Regular cleansing and proper moisturizing will help maintain your skin barrier.',
    );

    _scanHistory.add(scanResult);
    return scanResult;
  }

  @override
  Future<List<ScanResult>> getScanHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _scanHistory.where((scan) => scan.userId == userId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<ScanResult?> getScanResult(String scanId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _scanHistory.firstWhere((scan) => scan.id == scanId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteScanResult(String scanId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _scanHistory.removeWhere((scan) => scan.id == scanId);
  }

  @override
  Future<List<ScanResult>> getRecentScans(String userId, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final userScans = _scanHistory.where((scan) => scan.userId == userId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return userScans.take(limit).toList();
  }
}