import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}

class SignInUseCase implements UseCase<AppUser, SignInParams> {
  final AuthRepository repository;

  const SignInUseCase(this.repository);

  @override
  call(SignInParams params) => repository.signIn(
        email: params.email,
        password: params.password,
      );
}
