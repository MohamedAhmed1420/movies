import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String? avatarUrl;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
  });
}

class RegisterUseCase implements UseCase<AppUser, RegisterParams> {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  @override
  call(RegisterParams params) => repository.register(
        name: params.name,
        email: params.email,
        password: params.password,
        avatarUrl: params.avatarUrl,
      );
}
