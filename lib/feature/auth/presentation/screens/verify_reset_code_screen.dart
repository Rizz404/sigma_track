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
import 'package:sigma_track/feature/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';
import 'package:sigma_track/feature/auth/presentation/validators/verify_reset_code_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class VerifyResetCodeScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyResetCodeScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyResetCodeScreen> createState() =>
      _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends ConsumerState<VerifyResetCodeScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  String? _verifiedCode;

  @override
  void dispose() {
    _formKey.currentState?.fields.forEach((key, field) {
      field.dispose();
    });
    super.dispose();
  }

  Future<void> _handleVerifyCode() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      context.loaderOverlay.show();

      final formValues = _formKey.currentState!.value;
      final code = (formValues['resetCode'] as String).trim();

      final params = VerifyResetCodeUsecaseParams(
        email: widget.email,
        code: code,
      );

      _verifiedCode = code;

      await ref.read(authNotifierProvider.notifier).verifyResetCode(params);

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
                : context.l10n.authCodeVerifiedSuccessfully,
          );
          // * Navigate to reset password screen with resetToken
          context.pushReplacement(
            RouteConstant.resetPassword,
            extra: {'email': widget.email, 'resetToken': _verifiedCode ?? ''},
          );
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
                    context.l10n.authVerifyResetCode,
                    style: AppTextStyle.headlineMedium,
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    context.l10n.authEnterResetCode,
                    style: AppTextStyle.bodyLarge,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 32),

                  // * Reset code field
                  AppTextField(
                    name: 'resetCode',
                    label: context.l10n.authResetCode,
                    placeHolder: context.l10n.authEnterResetCodePlaceholder,
                    type: AppTextFieldType.text,
                    validator: (value) =>
                        VerifyResetCodeValidator.validateResetCode(
                          context,
                          value,
                        ),
                    prefixIcon: Icon(
                      Icons.lock_reset,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // * Validation errors
                  AppValidationErrors(errors: validationErrors),
                  if (validationErrors != null && validationErrors!.isNotEmpty)
                    const SizedBox(height: 16),

                  // * Verify code button
                  AppButton(
                    text: context.l10n.authVerifyCode,
                    onPressed: _handleVerifyCode,
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
                        onTap: () => context.push(RouteConstant.login),
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
