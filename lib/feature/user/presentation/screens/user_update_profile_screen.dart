import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_current_user_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_detail_state.dart';
import 'package:sigma_track/feature/user/presentation/validators/user_update_profile_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_file_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class UserUpdateProfileScreen extends ConsumerStatefulWidget {
  const UserUpdateProfileScreen({super.key});

  @override
  ConsumerState<UserUpdateProfileScreen> createState() =>
      _UserUpdateProfileScreenState();
}

class _UserUpdateProfileScreenState
    extends ConsumerState<UserUpdateProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning('Please fix all errors');
      return;
    }

    final formData = _formKey.currentState!.value;

    final name = formData['name'] as String;
    final email = formData['email'] as String;
    final fullName = formData['fullName'] as String;
    final employeeId = formData['employeeId'] as String?;
    final preferredLang = formData['preferredLang'] as String?;
    final avatarFiles = formData['avatar'] as List<PlatformFile>?;

    File? avatarFile;
    if (avatarFiles != null && avatarFiles.isNotEmpty) {
      final filePath = avatarFiles.first.path;
      if (filePath != null) {
        avatarFile = File(filePath);
      }
    }

    final params = UpdateCurrentUserUsecaseParams(
      name: name,
      email: email,
      fullName: fullName,
      employeeId: employeeId != null && employeeId.isNotEmpty
          ? employeeId
          : null,
      preferredLang: preferredLang,
      avatarFile: avatarFile,
    );

    ref.read(currentUserNotifierProvider.notifier).updateProfile(params);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserState = ref.watch(currentUserNotifierProvider);

    ref.listen<UserDetailState>(currentUserNotifierProvider, (previous, next) {
      if (next.isLoading) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isLoading && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Profile updated successfully');
        // * Refresh current user data
        ref.read(currentUserNotifierProvider.notifier).refresh();
        context.pop();
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Profile update error', next.failure);
          AppToast.error(next.failure?.message ?? 'Operation failed');
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Update Profile'),
        endDrawer: const AppEndDrawer(),
        body: currentUserState.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (user, _) => Column(
            children: [
              Expanded(
                child: ScreenWrapper(
                  child: FormBuilder(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildProfileInfoSection(user),
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
          error: (failure) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(failure.message, color: context.semantic.error),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Retry',
                  onPressed: () =>
                      ref.read(currentUserNotifierProvider.notifier).refresh(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoSection(user) {
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
            const AppText(
              'Profile Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            const AppFilePicker(
              name: 'avatar',
              label: 'Profile Picture',
              hintText: 'Choose image',
              fileType: FileType.image,
              allowMultiple: false,
              maxFiles: 1,
              maxSizeInMB: 5,
              validator: UserUpdateProfileValidator.validateAvatar,
              allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'webp'],
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'name',
              label: 'Username',
              placeHolder: 'Enter username',
              initialValue: user.name,
              validator: UserUpdateProfileValidator.validateName,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'email',
              label: 'Email',
              placeHolder: 'Enter email',
              initialValue: user.email,
              validator: UserUpdateProfileValidator.validateEmail,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'fullName',
              label: 'Full Name',
              placeHolder: 'Enter full name',
              initialValue: user.fullName,
              validator: UserUpdateProfileValidator.validateFullName,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'employeeId',
              label: 'Employee ID (Optional)',
              placeHolder: 'Enter employee ID',
              initialValue: user.employeeId,
              validator: UserUpdateProfileValidator.validateEmployeeId,
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'preferredLang',
              label: 'Preferred Language (Optional)',
              hintText: 'Select language',
              items: Language.values
                  .map(
                    (lang) => AppDropdownItem(
                      value: lang.backendCode,
                      label: lang.label,
                      icon: Icon(lang.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: user.preferredLang,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                text: 'Cancel',
                variant: AppButtonVariant.outlined,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(text: 'Update', onPressed: _handleSubmit),
            ),
          ],
        ),
      ),
    );
  }
}
