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
import 'package:movies/modules/auth/presentation/widgets/language_switch.dart';
import 'package:movies/l10n/app_localizations.dart';

import 'package:movies/core/locale/language_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final TapGestureRecognizer _createAccountRecognizer;

  @override
  void initState() {
    super.initState();
    _createAccountRecognizer = TapGestureRecognizer()..onTap = _onCreateAccount;
  }

  @override
  void dispose() {
    _createAccountRecognizer.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onForgotPassword(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.forgetPassword);
  }

  void _onCreateAccount() {
    Navigator.pushNamed(context, AppRoutes.register);
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
          title: Text(
            localizations.login,
            style: const TextStyle(
              color: AppColors.yellow,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                AppToast.show(title: localizations.loginSuccess, context: context);
                // Navigate to next screen / home
                Navigator.pushNamed(
                  context,
                  AppRoutes.home,
                  arguments: state.user,
                );
              } else if (state is GoogleSignInSuccessState) {
                AppToast.show(
                  title: localizations.googleSignInSuccess,
                  context: context,
                );
                Navigator.pushNamed(
                  context,
                  AppRoutes.home,
                  arguments: state.user,
                );

                // Navigate to next screen / home
              } else if (state is LoginErrorState) {
                AppToast.show(
                  title: authErrorMessage(context, state.code),
                  context: context,
                  type: AppToastType.error,
                );
              } else if (state is GoogleSignInErrorState) {
                AppToast.show(
                  title: authErrorMessage(context, state.code),
                  context: context,
                  type: AppToastType.error,
                );
              }
            },
            builder: (context, state) {
              final isLoginLoading = state is LoginLoadingState;
              final isGoogleLoading = state is GoogleSignInLoadingState;
              final cubit = context.read<AuthCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      // Movie Logo
                      Image.asset(
                        'assets/logo/movies_logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 36),

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

                      const SizedBox(height: 20),

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

                      const SizedBox(height: 12),

                      // Forget Password Link
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () => _onForgotPassword(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            localizations.forgetPassword,
                            style: const TextStyle(
                              color: AppColors.yellow,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Login Button
                      CustomButton(
                        text: localizations.loginButton,
                        isLoading: isLoginLoading,
                        onPressed: isGoogleLoading ? null : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            cubit.login(
                              email: _emailController.text,
                              password: _passwordController.text,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),

                      // Don't Have Account ? Create One
                      RichText(
                        text: TextSpan(
                          text: localizations.dontHaveAccount,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: localizations.createOne,
                              style: const TextStyle(
                                color: AppColors.yellow,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: _createAccountRecognizer,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // OR Divider
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: AppColors.yellow,
                              thickness: 1,
                              endIndent: 16,
                            ),
                          ),
                          Text(
                            localizations.or,
                            style: const TextStyle(
                              color: AppColors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: AppColors.yellow,
                              thickness: 1,
                              indent: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Login With Google Button
                      CustomButton(
                        text: localizations.loginWithGoogle,
                        isLoading: isGoogleLoading,
                        onPressed: isLoginLoading ? null : () {
                          cubit.signInWithGoogle();
                        },
                        icon: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: AppColors.black,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'G',
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Language Switch (US / Egypt)
                      LanguageSwitch(
                        initialLanguage: currentLocale,
                        onLanguageChanged: (lang) {
                          // Handle language change via LanguageCubit
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