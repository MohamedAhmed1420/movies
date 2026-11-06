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
import 'package:movies/l10n/app_localizations.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
            onPressed: _onBack,
          ),
          title: Text(
            localizations.forgetPasswordTitle,
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
              if (state is ResetPasswordSuccessState) {
                AppToast.show(
                  title: localizations.passwordResetEmailSent,
                  context: context,
                );
                // Return to login after short delay
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) _onBack();
                });
              } else if (state is ResetPasswordErrorState) {
                AppToast.show(
                  title: authErrorMessage(context, state.code),
                  context: context,
                  type: AppToastType.error,
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is ResetPasswordLoadingState;
              final cubit = context.read<AuthCubit>();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // Forgot Password Illustration
                      Image.asset(
                        'assets/images/Forgot_password.png',
                        height: 320,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.lock_reset,
                              color: AppColors.yellow,
                              size: 100,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

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

                      const SizedBox(height: 28),

                      // Verify Email Button
                      CustomButton(
                        text: localizations.verifyEmail, // تأكد من إضافتها لملف الـ ARB
                        isLoading: isLoading,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            cubit.sendPasswordResetEmail(
                              email: _emailController.text,
                            );
                          }
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