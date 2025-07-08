import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_service.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebase;
  AuthRepositoryImpl(this._firebase);

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final model = await _firebase.signInWithEmail(email, password);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

// ... signUp & signOut similarly
}