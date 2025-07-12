import '../../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<void> call(String email, String password) {
    return repository.signIn(email, password);
  }
}
