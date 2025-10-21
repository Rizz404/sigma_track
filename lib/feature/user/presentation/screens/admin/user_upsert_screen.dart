import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/usecases/create_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_user_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/users_state.dart';
import 'package:sigma_track/feature/user/presentation/validators/user_upsert_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_checkbox.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class UserUpsertScreen extends ConsumerStatefulWidget {
  final User? user;
  final String? userId;

  const UserUpsertScreen({super.key, this.user, this.userId});

  @override
  ConsumerState<UserUpsertScreen> createState() => _UserUpsertScreenState();
}

class _UserUpsertScreenState extends ConsumerState<UserUpsertScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit => widget.user != null || widget.userId != null;

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning('Please fill all required fields');
      return;
    }

    final formData = _formKey.currentState!.value;

    final name = formData['name'] as String;
    final email = formData['email'] as String;
    final fullName = formData['fullName'] as String;
    final role = formData['role'] as String;
    final employeeId = formData['employeeId'] as String?;
    final preferredLang = formData['preferredLang'] as String?;
    final isActive = formData['isActive'] as bool?;

    if (_isEdit) {
      final params = UpdateUserUsecaseParams.fromChanges(
        id: widget.user!.id,
        original: widget.user!,
        name: name,
        email: email,
        fullName: fullName,
        role: role,
        employeeId: employeeId != null && employeeId.isNotEmpty
            ? employeeId
            : null,
        preferredLang: preferredLang,
        isActive: isActive,
      );
      ref.read(usersProvider.notifier).updateUser(params);
    } else {
      final password = formData['password'] as String;
      final params = CreateUserUsecaseParams(
        name: name,
        email: email,
        password: password,
        fullName: fullName,
        role: role,
        employeeId: employeeId,
        preferredLang: preferredLang,
      );
      ref.read(usersProvider.notifier).createUser(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UsersState>(usersProvider, (previous, next) {
      // * Handle loading state
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage ?? 'User saved successfully');
        context.pop();
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        if (next.mutationFailure is ValidationFailure) {
          setState(
            () => validationErrors =
                (next.mutationFailure as ValidationFailure).errors,
          );
        } else {
          this.logError('User mutation error', next.mutationFailure);
          AppToast.error(next.mutationFailure?.message ?? 'Operation failed');
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(title: _isEdit ? 'Edit User' : 'Create User'),
        endDrawer: const AppEndDrawer(),
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
                        _buildUserInfoSection(),
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

  Widget _buildUserInfoSection() {
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
              'User Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'name',
              label: 'Username',
              placeHolder: 'Enter username',
              initialValue: widget.user?.name,
              validator: (value) =>
                  UserUpsertValidator.validateName(value, isUpdate: _isEdit),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'email',
              label: 'Email',
              placeHolder: 'Enter email',
              initialValue: widget.user?.email,
              validator: (value) =>
                  UserUpsertValidator.validateEmail(value, isUpdate: _isEdit),
            ),
            const SizedBox(height: 16),
            if (!_isEdit) ...[
              AppTextField(
                name: 'password',
                label: 'Password',
                placeHolder: 'Enter password',
                type: AppTextFieldType.password,
                validator: (value) => UserUpsertValidator.validatePassword(
                  value,
                  isUpdate: _isEdit,
                ),
              ),
              const SizedBox(height: 16),
            ],
            AppTextField(
              name: 'fullName',
              label: 'Full Name',
              placeHolder: 'Enter full name',
              initialValue: widget.user?.fullName,
              validator: (value) => UserUpsertValidator.validateFullName(
                value,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'role',
              label: 'Role',
              hintText: 'Select role',
              items: UserRole.values
                  .map(
                    (role) => AppDropdownItem(
                      value: role.value,
                      label: role.label,
                      icon: Icon(role.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: widget.user?.role.value,
              validator: (value) =>
                  UserUpsertValidator.validateRole(value, isUpdate: _isEdit),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'employeeId',
              label: 'Employee ID (Optional)',
              placeHolder: 'Enter employee ID',
              initialValue: widget.user?.employeeId,
              validator: UserUpsertValidator.validateEmployeeId,
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
              initialValue: widget.user?.preferredLang ?? 'en-US',
            ),
            if (_isEdit) ...[
              const SizedBox(height: 16),
              AppCheckbox(
                name: 'isActive',
                title: const AppText('Active'),
                initialValue: widget.user?.isActive ?? true,
              ),
            ],
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
              child: AppButton(
                text: _isEdit ? 'Update' : 'Create',
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
