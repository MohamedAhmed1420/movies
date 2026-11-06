import 'package:dartz/dartz.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetParams {
  final String email;

  const SendPasswordResetParams(this.email);
}

class SendPasswordResetUseCase
    implements UseCase<Unit, SendPasswordResetParams> {
  final AuthRepository repository;

  const SendPasswordResetUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SendPasswordResetParams params) =>
      repository.sendPasswordResetEmail(email: params.email);
}
