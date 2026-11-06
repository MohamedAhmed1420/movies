import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GoogleSignInUseCase implements UseCase<AppUser?, NoParams> {
  final AuthRepository repository;

  const GoogleSignInUseCase(this.repository);

  @override
  call(NoParams params) => repository.signInWithGoogle();
}
