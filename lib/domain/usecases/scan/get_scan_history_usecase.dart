import '../../repositories/scan_repository.dart';

class GetScanHistoryUsecase {
  final ScanRepository repository;

  GetScanHistoryUsecase(this.repository);

  Future<List<dynamic>> call(String userId) {
    return repository.getScanHistory(userId);
  }
}
