import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser?>> getCurrentUser();

  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
  });

  Future<Either<Failure, AppUser?>> signInWithGoogle();

  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  });

  Future<Either<Failure, Unit>> signOut();
}
