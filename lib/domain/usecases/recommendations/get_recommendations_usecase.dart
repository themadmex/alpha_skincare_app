import '../../repositories/recommendations_repository.dart';

class GetRecommendationsUsecase {
  final RecommendationsRepository repository;

  GetRecommendationsUsecase(this.repository);

  Future<List<dynamic>> call(String userId) {
    return repository.getRecommendations(userId);
  }
}
