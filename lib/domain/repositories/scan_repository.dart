// lib/domain/repositories/scan_repository.dart
import '../entities/scan_result.dart';

abstract class ScanRepository {
  Future<ScanResult> analyzeSkin(String imagePath);
  Future<List<ScanResult>> getScanHistory(String userId);
  Future<ScanResult?> getScanResult(String scanId);
  Future<void> deleteScanResult(String scanId);
  Future<List<ScanResult>> getRecentScans(String userId, {int limit = 10});
}