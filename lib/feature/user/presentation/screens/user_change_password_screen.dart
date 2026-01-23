import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/user/domain/usecases/change_current_user_password_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/current_user_state.dart';
import 'package:sigma_track/feature/user/presentation/validators/user_change_password_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class UserChangePasswordScreen extends ConsumerStatefulWidget {
  const UserChangePasswordScreen({super.key});

  @override
  ConsumerState<UserChangePasswordScreen> createState() =>
      _UserChangePasswordScreenState();
}

class _UserChangePasswordScreenState
    extends ConsumerState<UserChangePasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning(context.l10n.userPleaseFixErrors);
      return;
    }

    final formData = _formKey.currentState!.value;

    final currentPassword = formData['currentPassword'] as String;
    final newPassword = formData['newPassword'] as String;

    final params = ChangeCurrentUserPasswordUsecaseParams(
      oldPassword: currentPassword,
      newPassword: newPassword,
    );

    ref.read(currentUserNotifierProvider.notifier).changePassword(params);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserState = ref.watch(currentUserNotifierProvider);

    // * Listen to mutation state changes
    ref.listen<CurrentUserState>(currentUserNotifierProvider, (previous, next) {
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(
          next.message ?? context.l10n.userPasswordChangedSuccessfully,
        );
        // * Clear form after success
        _formKey.currentState?.reset();
        // ! Navigate back to profile
        if (context.mounted) {
          final isAdmin = next.user?.role == UserRole.admin;
          final isStaff = next.user?.role == UserRole.staff;
          final profileRoute = isAdmin
              ? RouteConstant.adminUserDetailProfile
              : isStaff
              ? RouteConstant.staffUserDetailProfile
              : RouteConstant.userDetailProfile;
          context.go(profileRoute);
        }
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Change password error', next.failure);
          AppToast.error(
            next.failure?.message ?? context.l10n.userOperationFailed,
          );
        }
      }
    });

    // * Handle empty user state
    final user = currentUserState.user;

    if (user == null) {
      return AppLoaderOverlay(
        child: Scaffold(
          appBar: CustomAppBar(title: context.l10n.userChangePassword),
          endDrawer: const AppEndDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: Center(child: AppText(context.l10n.userNoUserData)),
        ),
      );
    }

    // * Main content with form
    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.userChangePassword),
        endDrawer: const AppEndDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: Column(
          children: [
            Expanded(
              child: ScreenWrapper(
                child: FormBuilder(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildPasswordSection(),
                        const SizedBox(height: 24),
                        AppValidationErrors(errors: validationErrors),
                        if (validationErrors != null &&
                            validationErrors!.isNotEmpty)
                          const SizedBox(height: 16),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildStickyActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Card(
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              context.l10n.userChangePasswordTitle,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            AppText(
              context.l10n.userChangePasswordDescription,
              style: AppTextStyle.bodyMedium,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: 24),
            AppTextField(
              name: 'currentPassword',
              label: context.l10n.userCurrentPassword,
              placeHolder: context.l10n.userEnterCurrentPassword,
              type: AppTextFieldType.password,
              validator: (value) =>
                  UserChangePasswordValidator.validateCurrentPassword(
                    context,
                    value,
                  ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'newPassword',
              label: context.l10n.userNewPassword,
              placeHolder: context.l10n.userEnterNewPassword,
              type: AppTextFieldType.password,
              validator: (value) =>
                  UserChangePasswordValidator.validateNewPassword(
                    context,
                    value,
                  ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'confirmPassword',
              label: context.l10n.userConfirmNewPassword,
              placeHolder: context.l10n.userEnterConfirmNewPassword,
              type: AppTextFieldType.password,
              validator: (value) =>
                  UserChangePasswordValidator.validateConfirmPassword(
                    context,
                    value,
                    _formKey.currentState?.fields['newPassword']?.value,
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: context.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          context.l10n.userPasswordRequirements,
                          style: AppTextStyle.bodySmall,
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.primary,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          context.l10n.userPasswordRequirementsList,
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyActionButtons() {
    final currentUserState = ref.watch(currentUserNotifierProvider);
    final isAdmin = currentUserState.user?.role == UserRole.admin;
    final isStaff = currentUserState.user?.role == UserRole.staff;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: context.colors.divider,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: context.l10n.userCancel,
                variant: AppButtonVariant.outlined,
                onPressed: () {
                  final profileRoute = isAdmin
                      ? RouteConstant.adminUserDetailProfile
                      : isStaff
                      ? RouteConstant.staffUserDetailProfile
                      : RouteConstant.userDetailProfile;
                  context.go(profileRoute);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: context.l10n.userChangePasswordButton,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
