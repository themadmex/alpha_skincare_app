import '../../repositories/profile_repository.dart';

class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<dynamic> call(dynamic profile) {
    return repository.updateProfile(profile);
  }
}
