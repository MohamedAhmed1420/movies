import 'package:equatable/equatable.dart';
import 'package:movies/modules/auth/domain/entities/app_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => const [];
}

class SessionLoadingState extends AuthState {
  const SessionLoadingState();
}

class SessionAuthenticatedState extends AuthState {
  final AppUser user;
  const SessionAuthenticatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class SessionUnauthenticatedState extends AuthState {
  const SessionUnauthenticatedState();
}

class SessionRestoreErrorState extends AuthState {
  final String message;
  const SessionRestoreErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class LoginLoadingState extends AuthState {
  const LoginLoadingState();
}

class LoginSuccessState extends AuthState {
  final AppUser user;
  const LoginSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginErrorState extends AuthState {
  final String message;
  final String? code;
  const LoginErrorState(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class RegisterLoadingState extends AuthState {
  const RegisterLoadingState();
}

class RegisterSuccessState extends AuthState {
  final AppUser user;
  const RegisterSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class RegisterErrorState extends AuthState {
  final String message;
  final String? code;
  const RegisterErrorState(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class GoogleSignInLoadingState extends AuthState {
  const GoogleSignInLoadingState();
}

class GoogleSignInSuccessState extends AuthState {
  final AppUser user;
  const GoogleSignInSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class GoogleSignInErrorState extends AuthState {
  final String message;
  final String? code;
  const GoogleSignInErrorState(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class ResetPasswordLoadingState extends AuthState {
  const ResetPasswordLoadingState();
}

class ResetPasswordSuccessState extends AuthState {
  const ResetPasswordSuccessState();
}

class ResetPasswordErrorState extends AuthState {
  final String message;
  final String? code;
  const ResetPasswordErrorState(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

class SignOutLoadingState extends AuthState {
  const SignOutLoadingState();
}

class SignOutSuccessState extends AuthState {
  const SignOutSuccessState();
}

class SignOutErrorState extends AuthState {
  final String message;
  final String? code;
  const SignOutErrorState(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}
