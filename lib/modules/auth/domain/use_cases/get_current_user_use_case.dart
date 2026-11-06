import '../../../../core/usecase/usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<AppUser?, NoParams> {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  @override
  call(NoParams params) => repository.getCurrentUser();
}
