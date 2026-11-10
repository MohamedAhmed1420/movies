import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/service_locator.dart';
import 'package:movies/core/locale/language_cubit.dart';
import 'package:movies/core/routes/app_routes.dart';
import 'package:movies/core/theme/app_theme.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/auth/domain/entities/app_user.dart';
import 'package:movies/modules/auth/presentation/manager/auth_cubit.dart';
import 'package:movies/modules/auth/presentation/screens/forget_password_screen.dart';
import 'package:movies/modules/auth/presentation/screens/login_screen.dart';
import 'package:movies/modules/auth/presentation/screens/register_screen.dart';
import 'package:movies/modules/home/presentation/screens/layout_screen.dart';
import 'package:movies/modules/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:movies/modules/splash/presentation/screens/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _buildSplash() => BlocProvider(
        create: (_) => sl<AuthCubit>(),
        child: const SplashScreen(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LanguageCubit(),
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            routes: {
              AppRoutes.splash: (_) => _buildSplash(),
              AppRoutes.onboarding: (context) {
                final user = ModalRoute.of(context)?.settings.arguments;
                return OnboardingScreen(
                  user: user is AppUser ? user : null,
                );
              },
              AppRoutes.login: (_) => const LoginScreen(),
              AppRoutes.register: (_) => const RegisterScreen(),
              AppRoutes.forgetPassword: (_) => const ForgetPasswordScreen(),
              AppRoutes.home: (context) {
                final user = ModalRoute.of(context)?.settings.arguments;
                if (user is! AppUser) return const LoginScreen();
                return LayoutScreen(user: user);
              },
            },
            home: _buildSplash(),
          );
        },
      ),
    );
  }
}
