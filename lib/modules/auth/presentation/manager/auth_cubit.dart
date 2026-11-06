import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movies/core/usecase/usecase.dart';
import 'package:movies/modules/auth/domain/failures/auth_failure.dart';
import 'package:movies/modules/auth/domain/use_cases/get_current_user_use_case.dart';
import 'package:movies/modules/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:movies/modules/auth/domain/use_cases/register_use_case.dart';
import 'package:movies/modules/auth/domain/use_cases/send_password_reset_use_case.dart';
import 'package:movies/modules/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:movies/modules/auth/domain/use_cases/sign_out_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignInUseCase signInUseCase;
  final RegisterUseCase registerUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final SendPasswordResetUseCase sendPasswordResetUseCase;
  final SignOutUseCase signOutUseCase;

  AuthCubit({
    required this.getCurrentUserUseCase,
    required this.signInUseCase,
    required this.registerUseCase,
    required this.googleSignInUseCase,
    required this.sendPasswordResetUseCase,
    required this.signOutUseCase,
  }) : super(const AuthInitialState());

  Future<void> restoreSession() async {
    emit(const SessionLoadingState());
    final result = await getCurrentUserUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(SessionRestoreErrorState(failure.message)),
      (user) => emit(
        user == null
            ? const SessionUnauthenticatedState()
            : SessionAuthenticatedState(user),
      ),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoadingState());
    final result = await signInUseCase(
      SignInParams(email: email, password: password),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        LoginErrorState(
          failure.message,
          code: failure is AuthFailure ? failure.code : null,
        ),
      ),
      (user) => emit(LoginSuccessState(user)),
    );
  }

  Future<void> createAccount({
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
  }) async {
    emit(const RegisterLoadingState());
    final result = await registerUseCase(
      RegisterParams(
        name: name,
        email: email,
        password: password,
        avatarUrl: avatarUrl,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        RegisterErrorState(
          failure.message,
          code: failure is AuthFailure ? failure.code : null,
        ),
      ),
      (user) => emit(RegisterSuccessState(user)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(const GoogleSignInLoadingState());
    final result = await googleSignInUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        GoogleSignInErrorState(
          failure.message,
          code: failure is AuthFailure ? failure.code : null,
        ),
      ),
      (user) => emit(
        user == null ? const AuthInitialState() : GoogleSignInSuccessState(user),
      ),
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    emit(const ResetPasswordLoadingState());
    final result = await sendPasswordResetUseCase(
      SendPasswordResetParams(email),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        ResetPasswordErrorState(
          failure.message,
          code: failure is AuthFailure ? failure.code : null,
        ),
      ),
      (_) => emit(const ResetPasswordSuccessState()),
    );
  }

  Future<void> signOut() async {
    emit(const SignOutLoadingState());
    final result = await signOutUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        SignOutErrorState(
          failure.message,
          code: failure is AuthFailure ? failure.code : null,
        ),
      ),
      (_) => emit(const SignOutSuccessState()),
    );
  }
}
