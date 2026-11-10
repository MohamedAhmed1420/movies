import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/routes/app_routes.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/modules/auth/presentation/manager/auth_cubit.dart';
import 'package:movies/modules/auth/presentation/manager/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) context.read<AuthCubit>().restoreSession();
    });
  }

  void _handleSessionState(AuthState state) {
    if (state is SessionAuthenticatedState) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.onboarding,
        arguments: state.user,
      );
    } else if (state is SessionUnauthenticatedState ||
        state is SessionRestoreErrorState) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) => _handleSessionState(state),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: Image.asset('assets/logo/movies_logo.png')),
              Image.asset('assets/logo/route_logo.png', width: 150),
              const Text(
                'Supervised by Mohamed Ahmed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
