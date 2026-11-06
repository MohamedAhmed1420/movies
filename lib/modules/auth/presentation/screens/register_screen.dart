import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/service_locator.dart';
import 'package:movies/core/routes/app_routes.dart';
import 'package:movies/core/widgets/app_toast.dart';
import 'package:movies/core/widgets/custom_button.dart';
import 'package:movies/core/widgets/custom_text_field.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/modules/auth/presentation/manager/auth_cubit.dart';
import 'package:movies/modules/auth/presentation/manager/auth_state.dart';
import 'package:movies/modules/auth/presentation/utils/auth_error_localizer.dart';
import 'package:movies/modules/auth/presentation/widgets/avatar_selector.dart';
import 'package:movies/modules/auth/presentation/widgets/language_switch.dart';
import 'package:movies/l10n/app_localizations.dart';

import 'package:movies/core/locale/language_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final TapGestureRecognizer _loginRecognizer;
  int _selectedAvatarIndex = 1;

  @override
  void initState() {
    super.initState();
    _loginRecognizer = TapGestureRecognizer()..onTap = _onLoginTap;
  }

  @override
  void dispose() {
    _loginRecognizer.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onLoginTap() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.yellow,
            ),
            onPressed: _onLoginTap,
          ),
          title: Text(
            localizations.register,
            style: const TextStyle(
              color: AppColors.yellow,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is RegisterSuccessState) {
                AppToast.show(title: localizations.accountCreatedSuccess, context: context);
                _onLoginTap();
              } else if (state is RegisterErrorState) {
                AppToast.show(
                  title: authErrorMessage(context, state.code),
                  context: context,
                  type: AppToastType.error,
                );
              }
            },
            builder: (context, state) {
              final isRegisterLoading = state is RegisterLoadingState;
              final cubit = context.read<AuthCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),

                      // Avatar Carousel Selector
                      AvatarSelector(
                        initialIndex: _selectedAvatarIndex,
                        onAvatarSelected: (index) {
                          setState(() {
                            _selectedAvatarIndex = index;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      // Name Field
                      CustomTextField(
                        controller: _nameController,
                        hintText: localizations.name,
                        prefixIcon: const Icon(
                          Icons.badge_outlined,
                          color: AppColors.white,
                          size: 24,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return localizations.enterName;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        hintText: localizations.email,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: AppColors.white,
                          size: 24,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return localizations.enterEmail;
                          }
                          if (!value.contains('@')) {
                            return localizations.validEmail;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        hintText: localizations.password,
                        isPassword: true,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.white,
                          size: 24,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.enterPassword;
                          }
                          if (value.length < 6) {
                            return localizations.passwordLength;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Confirm Password Field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: localizations.confirmPassword,
                        isPassword: true,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.white,
                          size: 24,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.confirmPasswordRequired;
                          }
                          if (value != _passwordController.text) {
                            return localizations.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      // Create Account Button
                      CustomButton(
                        text: localizations.createAccount,
                        isLoading: isRegisterLoading,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final avatarUrl = _selectedAvatarIndex <
                                AvatarSelector.avatars.length
                                ? AvatarSelector.avatars[_selectedAvatarIndex]
                                : null;

                            cubit.createAccount(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              avatarUrl: avatarUrl,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      // Already Have Account ? Login
                      RichText(
                        text: TextSpan(
                          text: localizations.alreadyHaveAccount,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: localizations.login,
                              style: const TextStyle(
                                color: AppColors.yellow,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: _loginRecognizer,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Language Switch
                      LanguageSwitch(
                        initialLanguage: currentLocale,
                        onLanguageChanged: (lang) {
                          context.read<LanguageCubit>().changeLanguage(lang);
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}