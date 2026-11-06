import 'package:flutter/widgets.dart';
import 'package:movies/l10n/app_localizations.dart';

String authErrorMessage(BuildContext context, String? code) {
  final localizations = AppLocalizations.of(context)!;

  return switch (code) {
    'weak-password' => localizations.authWeakPassword,
    'email-already-in-use' => localizations.authEmailAlreadyInUse,
    'invalid-email' => localizations.authInvalidEmail,
    'user-not-found' => localizations.authUserNotFound,
    'wrong-password' || 'invalid-credential' =>
      localizations.authInvalidCredential,
    'user-disabled' => localizations.authUserDisabled,
    'too-many-requests' => localizations.authTooManyRequests,
    'operation-not-allowed' => localizations.authOperationNotAllowed,
    'network-request-failed' => localizations.authNetworkError,
    _ => localizations.authUnknownError,
  };
}
