import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() =>
      _guard(() async {
        final user = await remoteDataSource.getCurrentUser();
        return user == null ? null : _mapUser(user);
      });

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) =>
      _guard(() async => _mapUser(
            await remoteDataSource.signIn(email: email, password: password),
          ));

  @override
  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
  }) =>
      _guard(() async => _mapUser(
            await remoteDataSource.register(
              name: name,
              email: email,
              password: password,
              avatarUrl: avatarUrl,
            ),
          ));

  @override
  Future<Either<Failure, AppUser?>> signInWithGoogle() =>
      _guard(() async {
        final user = await remoteDataSource.signInWithGoogle();
        return user == null ? null : _mapUser(user);
      });

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail({
    required String email,
  }) =>
      _guard(() async {
        await remoteDataSource.sendPasswordResetEmail(email: email);
        return unit;
      });

  @override
  Future<Either<Failure, Unit>> signOut() => _guard(() async {
        await remoteDataSource.signOut();
        return unit;
      });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() operation) async {
    try {
      return Right(await operation());
    } on ServerException catch (error) {
      return Left(
        AuthFailure(code: error.code ?? 'unknown', message: error.message),
      );
    } on FirebaseException catch (error) {
      return Left(
        AuthFailure(
          code: error.code,
          message: error.message ?? 'Firebase operation failed.',
        ),
      );
    } catch (error) {
      return Left(AuthFailure(code: 'unknown', message: error.toString()));
    }
  }

  AppUser _mapUser(User user) => AppUser(
        id: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
}
