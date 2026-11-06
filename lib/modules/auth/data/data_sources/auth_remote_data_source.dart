import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/config/google_sign_in_config.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<User?> getCurrentUser();
  Future<User> signIn({required String email, required String password});
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
  });
  Future<User?> signInWithGoogle();
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> signOut();
}

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  FirebaseAuthRemoteDataSource({
    required this.auth,
    required this.googleSignIn,
  });

  Future<void>? _googleSignInInitialization;

  Future<void> _ensureGoogleSignInInitialized() async {
    try {
      await (_googleSignInInitialization ??= googleSignIn.initialize(
        serverClientId: GoogleSignInConfig.serverClientId,
      ));
    } catch (_) {
      _googleSignInInitialization = null;
      rethrow;
    }
  }

  @override
  Future<User?> getCurrentUser() async => auth.currentUser;

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _requireUser(result.user);
    } on FirebaseAuthException catch (error) {
      throw ServerException(_authMessage(error), code: error.code);
    } catch (error) {
      if (error is ServerException) rethrow;
      throw ServerException('Failed to sign in: $error', code: 'unknown');
    }
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
  }) async {
    try {
      final result = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = _requireUser(result.user);
      if (name.trim().isNotEmpty) {
        await user.updateDisplayName(name.trim());
      }
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        await user.updatePhotoURL(avatarUrl);
      }
      await user.reload();
      return auth.currentUser ?? user;
    } on FirebaseAuthException catch (error) {
      throw ServerException(_authMessage(error), code: error.code);
    } catch (error) {
      if (error is ServerException) rethrow;
      throw ServerException('Failed to create account: $error', code: 'unknown');
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      final account = await googleSignIn.authenticate();
      final credential = GoogleAuthProvider.credential(
        idToken: account.authentication.idToken,
      );
      final result = await auth.signInWithCredential(credential);
      return result.user;
    } on FirebaseAuthException catch (error) {
      throw ServerException(_authMessage(error), code: error.code);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      throw ServerException(
        'Google sign-in failed: ${error.description ?? error}',
        code: 'google-sign-in-failed',
      );
    } catch (error) {
      throw ServerException('Google sign-in failed: $error', code: 'unknown');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw ServerException(_authMessage(error), code: error.code);
    } catch (error) {
      throw ServerException('Failed to send password reset email: $error', code: 'unknown');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final isGoogleAccount = auth.currentUser?.providerData.any(
            (provider) => provider.providerId == 'google.com',
          ) ??
          false;

      // Firebase owns the app session and must be signed out for every user.
      await auth.signOut();

      // The Google Sign-In plugin requires initialization before all instance
      // methods. Avoid initializing or calling it for email-only accounts.
      if (isGoogleAccount) {
        try {
          await _ensureGoogleSignInInitialized();
          await googleSignIn.signOut();
        } catch (_) {
          // Firebase is already signed out, so the app session is closed.
        }
      }
    } catch (error) {
      throw ServerException('Failed to sign out: $error', code: 'unknown');
    }
  }

  User _requireUser(User? user) {
    if (user == null) throw const ServerException('User was not returned.', code: 'unknown');
    return user;
  }

  String _authMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase Console.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return error.message ?? 'An unknown authentication error occurred.';
    }
  }
}
