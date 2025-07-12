import '../../repositories/auth_repository.dart';

class SignupUsecase {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  Future<void> call(String email, String password, String name) {
    return repository.signUp(email, password, name);
  }
}
