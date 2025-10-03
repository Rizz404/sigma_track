import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_providers.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';
import 'package:sigma_track/feature/auth/presentation/validators/forgot_password_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;

  @override
  void dispose() {
    _formKey.currentState?.fields.forEach((key, field) {
      field.dispose();
    });
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      context.loaderOverlay.show();

      final formValues = _formKey.currentState!.value;

      final params = ForgotPasswordUsecaseParams(
        email: (formValues['email'] as String).trim(),
      );

      await ref.read(authNotifierProvider.notifier).forgotPassword(params);

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
        if (state.status == AuthStatus.unauthenticated &&
            state.failure == null) {
          AppToast.success(state.success?.message ?? 'Email sent successfully');
        } else if (state.failure != null) {
          if (state.failure is ValidationFailure) {
            setState(
              () => validationErrors =
                  (state.failure as ValidationFailure).errors,
            );
          } else {
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
                    'Forgot Password',
                    style: AppTextStyle.headlineMedium,
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    'Enter your email to reset your password',
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
                    validator: ForgotPasswordValidator.validateEmail,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // * Validation errors
                  if (validationErrors != null && validationErrors!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: validationErrors!
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: AppText(
                                e.message,
                                color: context.semantic.error,
                                style: AppTextStyle.bodySmall,
                              ),
                            ),
                          )
                          .toList(),
                    ),

                  // * Send reset link button
                  AppButton(
                    text: 'Send Reset Link',
                    onPressed: _handleForgotPassword,
                    size: AppButtonSize.large,
                  ),
                  const SizedBox(height: 16),

                  // * Back to login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        'Remember your password? ',
                        style: AppTextStyle.bodyMedium,
                        color: context.colors.textSecondary,
                      ),
                      GestureDetector(
                        onTap: () => context.push(RouteConstant.login),
                        child: AppText(
                          'Login',
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
