import '../../repositories/scan_repository.dart';

class AnalyzeSkinUsecase {
  final ScanRepository repository;

  AnalyzeSkinUsecase(this.repository);

  Future<dynamic> call(String imagePath) {
    return repository.analyzeSkin(imagePath);
  }
}
