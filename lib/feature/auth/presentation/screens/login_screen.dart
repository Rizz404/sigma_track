import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';
import 'package:sigma_track/feature/auth/presentation/validators/login_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;

  @override
  void dispose() {
    _formKey.currentState?.fields.forEach((key, field) {
      field.dispose();
    });
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      context.loaderOverlay.show();

      final formValues = _formKey.currentState!.value;

      final params = LoginUsecaseParams(
        email: (formValues['email'] as String).trim(),
        password: formValues['password'] as String,
      );

      await ref.read(authNotifierProvider.notifier).login(params);

      if (mounted) {
        context.loaderOverlay.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Listen to auth state changes untuk auto redirect
    ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (previous, next) {
      next.whenData((state) {
        if (state.status == AuthStatus.authenticated) {
          AppToast.success(state.success?.message ?? 'Login successful');
          // * Router akan otomatis redirect via _handleRedirect di app_router.dart
        } else if (state.status == AuthStatus.unauthenticated &&
            state.failure != null) {
          if (state.failure is ValidationFailure) {
            setState(
              () => validationErrors =
                  (state.failure as ValidationFailure).errors,
            );
          } else {
            this.logPresentation(state.failure!.message);
            AppToast.error(state.failure!.message);
          }
        }
      });

      next.whenOrNull(
        error: (error, stack) {
          AppToast.error(error.toString());
        },
      );
    });

    return LoaderOverlay(
      child: Scaffold(
        body: ScreenWrapper(
          child: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // * Header section
                  AppText(
                    'Welcome Back',
                    style: AppTextStyle.headlineMedium,
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    'Sign in to continue',
                    style: AppTextStyle.bodyLarge,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 32),

                  // * Email field
                  AppTextField(
                    name: 'email',
                    label: 'Email',
                    placeHolder: 'Enter your email',
                    type: AppTextFieldType.email,
                    validator: LoginValidator.validateEmail,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // * Password field
                  AppTextField(
                    name: 'password',
                    label: 'Password',
                    placeHolder: 'Enter your password',
                    type: AppTextFieldType.password,
                    validator: LoginValidator.validatePassword,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // * Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => context.go(RouteConstant.forgotPassword),
                      child: AppText(
                        'Forgot Password?',
                        style: AppTextStyle.bodySmall,
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // * Validation errors
                  AppValidationErrors(errors: validationErrors),
                  if (validationErrors != null && validationErrors!.isNotEmpty)
                    const SizedBox(height: 16),

                  // * Login button
                  AppButton(
                    text: 'Login',
                    onPressed: _handleLogin,
                    size: AppButtonSize.large,
                  ),
                  const SizedBox(height: 16),

                  // * Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        'Don\'t have an account? ',
                        style: AppTextStyle.bodyMedium,
                        color: context.colors.textSecondary,
                      ),
                      GestureDetector(
                        onTap: () => context.push(RouteConstant.register),
                        child: AppText(
                          'Register',
                          style: AppTextStyle.bodyMedium,
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
