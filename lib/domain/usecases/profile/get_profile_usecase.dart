import '../../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<dynamic> call(String userId) {
    return repository.getProfile(userId);
  }
}
