import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/auth/domain/usecases/reset_password_usecase.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';
import 'package:sigma_track/feature/auth/presentation/validators/reset_password_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String resetToken;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;

  @override
  void dispose() {
    _formKey.currentState?.fields.forEach((key, field) {
      field.dispose();
    });
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      context.loaderOverlay.show();

      final formValues = _formKey.currentState!.value;

      final params = ResetPasswordUsecaseParams(
        email: widget.email,
        code: widget.resetToken,
        newPassword: (formValues['newPassword'] as String).trim(),
      );

      await ref.read(authNotifierProvider.notifier).resetPassword(params);

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
            state.failure == null &&
            state.success != null) {
          AppToast.success(
            state.success?.message?.isNotEmpty == true
                ? state.success!.message!
                : context.l10n.authPasswordResetSuccessfully,
          );
          // * Navigate to login screen
          context.go(RouteConstant.login);
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

    return AppLoaderOverlay(
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
                    context.l10n.authResetPasswordTitle,
                    style: AppTextStyle.headlineMedium,
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    context.l10n.authEnterNewPassword,
                    style: AppTextStyle.bodyLarge,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 32),

                  // * New password field
                  AppTextField(
                    name: 'newPassword',
                    label: context.l10n.authNewPassword,
                    placeHolder: context.l10n.authEnterNewPasswordPlaceholder,
                    type: AppTextFieldType.password,
                    validator: (value) =>
                        ResetPasswordValidator.validateNewPassword(
                          context,
                          value,
                        ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // * Confirm new password field
                  AppTextField(
                    name: 'confirmNewPassword',
                    label: context.l10n.authConfirmNewPassword,
                    placeHolder: context.l10n.authReEnterNewPassword,
                    type: AppTextFieldType.password,
                    validator: (value) =>
                        ResetPasswordValidator.validateConfirmPassword(
                          context,
                          value,
                          _formKey,
                        ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // * Validation errors
                  AppValidationErrors(errors: validationErrors),
                  if (validationErrors != null && validationErrors!.isNotEmpty)
                    const SizedBox(height: 16),

                  // * Reset password button
                  AppButton(
                    text: context.l10n.authResetPasswordButton,
                    onPressed: _handleResetPassword,
                    size: AppButtonSize.large,
                  ),
                  const SizedBox(height: 16),

                  // * Back to login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        context.l10n.authRememberPassword,
                        style: AppTextStyle.bodyMedium,
                        color: context.colors.textSecondary,
                      ),
                      GestureDetector(
                        onTap: () => context.go(RouteConstant.login),
                        child: AppText(
                          context.l10n.authLogin,
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
