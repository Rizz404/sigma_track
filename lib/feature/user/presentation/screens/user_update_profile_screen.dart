import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
// ignore: unused_import
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_current_user_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/current_user_state.dart';
import 'package:sigma_track/feature/user/presentation/validators/user_update_profile_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_image.dart';
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
  final _filePickerKey = GlobalKey<AppFilePickerState>();
  List<ValidationError>? validationErrors;
  File? _avatarFile;

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning(context.l10n.userPleaseFixErrors);
      return;
    }

    final formData = _formKey.currentState!.value;
    final currentUser = ref.read(currentUserNotifierProvider).user;

    if (currentUser == null) {
      AppToast.error(context.l10n.userNoUserData);
      return;
    }

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
    _avatarFile = avatarFile;

    // * Use fromChanges to only send changed fields
    final params = UpdateCurrentUserUsecaseParams.fromChanges(
      original: currentUser,
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

    // * Listen to mutation state changes
    ref.listen<CurrentUserState>(currentUserNotifierProvider, (previous, next) {
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(
          next.message ?? context.l10n.userProfileUpdatedSuccessfully,
        );
        // * Clean up selected file and reset picker
        if (_avatarFile != null) {
          _avatarFile!.deleteSync();
          _avatarFile = null;
        }
        _filePickerKey.currentState?.reset();
        // ! Use context.go() instead of context.pop() - route outside shell
        // ! Check role to navigate to correct profile route
        if (context.mounted) {
          final isAdmin = next.user?.role == UserRole.admin;
          final profileRoute = isAdmin
              ? RouteConstant.adminUserDetailProfile
              : RouteConstant.userDetailProfile;
          context.go(profileRoute);
        }
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Profile update error', next.failure);
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
          appBar: CustomAppBar(title: context.l10n.userUpdateProfile),
          endDrawer: const AppEndDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: Center(child: AppText(context.l10n.userNoUserData)),
        ),
      );
    }

    // * Main content with form
    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.userUpdateProfile),
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
            AppText(
              context.l10n.userProfileInformation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            Center(
              child: AppImage(
                size: ImageSize.xxxLarge,
                imageUrl: user.avatarUrl,
                shape: ImageShape.circle,
                backgroundColor: context.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                placeholder: Icon(
                  Icons.person,
                  size: 50,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppFilePicker(
              key: _filePickerKey,
              name: 'avatar',
              label: context.l10n.userProfilePicture,
              hintText: context.l10n.userChooseImage,
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
              label: context.l10n.userUsername,
              placeHolder: context.l10n.userEnterUsername,
              initialValue: user.name,
              validator: (value) =>
                  UserUpdateProfileValidator.validateName(value),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'email',
              label: context.l10n.userEmail,
              placeHolder: context.l10n.userEnterEmail,
              initialValue: user.email,
              validator: (value) =>
                  UserUpdateProfileValidator.validateEmail(value),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'fullName',
              label: context.l10n.userFullName,
              placeHolder: context.l10n.userEnterFullName,
              initialValue: user.fullName,
              validator: (value) =>
                  UserUpdateProfileValidator.validateFullName(value),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'employeeId',
              label: context.l10n.userEmployeeIdOptional,
              placeHolder: context.l10n.userEnterEmployeeIdOptional,
              initialValue: user.employeeId,
              validator: UserUpdateProfileValidator.validateEmployeeId,
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'preferredLang',
              label: context.l10n.userPreferredLanguage,
              hintText: context.l10n.userSelectLanguage,
              items: Language.values
                  .map(
                    (lang) => AppDropdownItem(
                      value: lang.backendCode,
                      label: lang.label,
                      icon: Icon(lang.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: user.preferredLang.backendCode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyActionButtons() {
    final currentUserState = ref.watch(currentUserNotifierProvider);
    final isAdmin = currentUserState.user?.role == UserRole.admin;

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
                // ! Use context.go() instead of context.pop() - route outside shell
                // ! Check role to navigate to correct profile route
                onPressed: () {
                  final profileRoute = isAdmin
                      ? RouteConstant.adminUserDetailProfile
                      : RouteConstant.userDetailProfile;
                  context.go(profileRoute);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: context.l10n.userUpdate,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
