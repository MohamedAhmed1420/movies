import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/widgets/custom_button.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/modules/auth/domain/entities/app_user.dart';
import 'package:movies/modules/auth/presentation/manager/auth_cubit.dart';
import 'package:movies/modules/auth/presentation/manager/auth_state.dart';
import 'package:movies/modules/home/presentation/widgets/home_widgets.dart';

class ProfileScreen extends StatelessWidget {
  final AppUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 28),
          Center(child: UserAvatar(user: user, radius: 48)),
          const SizedBox(height: 18),
          Text(
            user.displayName ?? user.email ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            user.email ?? '',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white.withValues(alpha: 0.68),
                ),
          ),
          const SizedBox(height: 36),
          CustomButton(
            text: localizations.signOut,
            isLoading: state is SignOutLoadingState,
            backgroundColor: AppColors.gray,
            textColor: AppColors.white,
            onPressed: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
    );
  }
}
