import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';
import 'package:sigma_track/feature/auth/presentation/validators/register_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;

  @override
  void dispose() {
    _formKey.currentState?.fields.forEach((key, field) {
      field.dispose();
    });
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      context.loaderOverlay.show();

      final formValues = _formKey.currentState!.value;

      final params = RegisterUsecaseParams(
        name: (formValues['name'] as String).trim(),
        email: (formValues['email'] as String).trim(),
        password: formValues['password'] as String,
      );

      await ref.read(authNotifierProvider.notifier).register(params);

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
          AppToast.success(state.success?.message ?? 'Registration successful');
          // * Redirect berdasarkan role user
          context.go(RouteConstant.login);
        } else if (state.status == AuthStatus.unauthenticated &&
            state.failure != null) {
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
                    'Create Account',
                    style: AppTextStyle.headlineMedium,
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    'Sign up to get started',
                    style: AppTextStyle.bodyLarge,
                    color: context.colors.textSecondary,
                  ),
                  const SizedBox(height: 32),

                  // * Name field
                  AppTextField(
                    name: 'name',
                    label: 'Name',
                    placeHolder: 'Enter your name',
                    type: AppTextFieldType.text,
                    validator: RegisterValidator.validateName,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // * Email field
                  AppTextField(
                    name: 'email',
                    label: 'Email',
                    placeHolder: 'Enter your email',
                    type: AppTextFieldType.email,
                    validator: RegisterValidator.validateEmail,
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
                    validator: RegisterValidator.validatePassword,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // * Confirm password field
                  AppTextField(
                    name: 'confirmPassword',
                    label: 'Confirm Password',
                    placeHolder: 'Re-enter your password',
                    type: AppTextFieldType.password,
                    validator: (value) =>
                        RegisterValidator.validateConfirmPassword(
                          value,
                          _formKey.currentState?.fields['password']?.value,
                        ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // * Password requirements info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: context.colors.border,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          'Password must contain:',
                          style: AppTextStyle.labelMedium,
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        _buildRequirement('Just make the password man!'),
                        // _buildRequirement('At least 8 characters'),
                        // _buildRequirement('One uppercase letter'),
                        // _buildRequirement('One lowercase letter'),
                        // _buildRequirement('One number'),
                      ],
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

                  // * Register button
                  AppButton(
                    text: 'Register',
                    onPressed: _handleRegister,
                    size: AppButtonSize.large,
                  ),
                  const SizedBox(height: 16),

                  // * Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        'Already have an account? ',
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

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: context.colors.textSecondary,
          ),
          const SizedBox(width: 8),
          AppText(
            text,
            style: AppTextStyle.bodySmall,
            color: context.colors.textSecondary,
          ),
        ],
      ),
    );
  }
}
