import 'package:dartz/dartz.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  const SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      repository.signOut();
}
