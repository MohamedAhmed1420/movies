import 'package:movies/core/error/failures.dart';

class AuthFailure extends Failure {
  final String code;

  const AuthFailure({required this.code, required String message})
      : super(message);

  @override
  List<Object?> get props => [code, message];
}
