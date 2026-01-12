import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/usecases/export_user_list_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_cursor_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/feature/user/presentation/widgets/export_users_bottom_sheet.dart';
import 'package:sigma_track/feature/user/presentation/widgets/user_tile.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_list_bottom_sheet.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListUsersScreen extends ConsumerStatefulWidget {
  const ListUsersScreen({super.key});

  @override
  ConsumerState<ListUsersScreen> createState() => _ListUsersScreenState();
}

class _ListUsersScreenState extends ConsumerState<ListUsersScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  final Set<String> _selectedUserIds = {};
  bool _isSelectMode = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(usersProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _selectedUserIds.clear();
    _isSelectMode = false;
    await ref.read(usersProvider.notifier).refresh();
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AppListOptionsBottomSheet(
        onCreate: () {
          Navigator.pop(context);
          context.push(RouteConstant.adminUserUpsert);
          this.logPresentation('Create user pressed');
        },
        onSelectMany: () {
          Navigator.pop(context);
          setState(() {
            _isSelectMode = true;
            _selectedUserIds.clear();
          });
          AppToast.info(context.l10n.userSelectUsersToDelete);
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        exportWidgetBuilder: _buildExportBottomSheet,
        createTitle: context.l10n.userCreateUser,
        createSubtitle: context.l10n.userAddNewUser,
        selectManyTitle: context.l10n.userSelectMany,
        selectManySubtitle: context.l10n.userSelectMultipleToDelete,
        filterSortTitle: context.l10n.userFilterAndSort,
        filterSortSubtitle: context.l10n.userCustomizeDisplay,
        exportTitle: context.l10n.assetExportTitle,
        exportSubtitle: context.l10n.assetExportSubtitle,
      ),
    );
  }

  Widget _buildExportBottomSheet() {
    final currentFilter = ref.read(usersProvider).usersFilter;

    final params = ExportUserListUsecaseParams(
      format: ExportFormat.pdf,
      searchQuery: currentFilter.search,
      role: currentFilter.role != null
          ? UserRole.values.firstWhere((e) => e.value == currentFilter.role)
          : null,
      isActive: currentFilter.isActive,
      sortBy: currentFilter.sortBy,
      sortOrder: currentFilter.sortOrder,
    );

    return ExportUsersBottomSheet(initialParams: params);
  }

  Widget _buildFilterSortBottomSheet() {
    final currentFilter = ref.read(usersProvider).usersFilter;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: FormBuilder(
          key: _filterFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppText(
                context.l10n.userFilters,
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'role',
                label: context.l10n.userRole,
                initialValue: currentFilter.role,
                items: UserRole.values
                    .map(
                      (role) => AppDropdownItem<String>(
                        value: role.value,
                        label: role.label,
                        icon: Icon(role.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              AppTextField(
                name: 'employeeId',
                label: context.l10n.userEmployeeId,
                placeHolder: context.l10n.userEnterEmployeeId,
                initialValue: currentFilter.employeeId,
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                name: 'isActive',
                label: context.l10n.userActiveStatus,
                initialValue: currentFilter.isActive?.toString(),
                items: [
                  AppDropdownItem(
                    value: 'true',
                    label: context.l10n.userActive,
                    icon: const Icon(Icons.check_circle, size: 18),
                  ),
                  AppDropdownItem(
                    value: 'false',
                    label: context.l10n.userInactive,
                    icon: const Icon(Icons.cancel, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AppText(
                context.l10n.userSort,
                style: AppTextStyle.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                name: 'sortBy',
                label: context.l10n.userSortBy,
                initialValue: currentFilter.sortBy?.value,
                items: UserSortBy.values
                    .map(
                      (sortBy) => AppDropdownItem<String>(
                        value: sortBy.value,
                        label: sortBy.label,
                        icon: Icon(sortBy.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                name: 'sortOrder',
                label: context.l10n.userSortOrder,
                initialValue: currentFilter.sortOrder?.value,
                items: [
                  AppDropdownItem(
                    value: 'asc',
                    label: context.l10n.userAscending,
                    icon: const Icon(Icons.arrow_upward, size: 18),
                  ),
                  AppDropdownItem(
                    value: 'desc',
                    label: context.l10n.userDescending,
                    icon: const Icon(Icons.arrow_downward, size: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.l10n.userReset,
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter = GetUsersCursorUsecaseParams(
                          search: currentFilter.search,
                          // * Reset semua filter kecuali search
                        );
                        Navigator.pop(context);
                        ref
                            .read(usersProvider.notifier)
                            .updateFilter(newFilter);
                        AppToast.success(context.l10n.userFilterReset);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: context.l10n.userApply,
                      onPressed: () {
                        if (_filterFormKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData = _filterFormKey.currentState!.value;
                          final sortByStr = formData['sortBy'] as String?;
                          final sortOrderStr = formData['sortOrder'] as String?;
                          final roleStr = formData['role'] as String?;
                          final employeeId = formData['employeeId'] as String?;
                          final isActiveStr = formData['isActive'] as String?;

                          final newFilter = GetUsersCursorUsecaseParams(
                            search: currentFilter.search,
                            role: roleStr,
                            isActive: isActiveStr != null
                                ? isActiveStr == 'true'
                                : null,
                            employeeId: employeeId,
                            sortBy: sortByStr != null
                                ? UserSortBy.values.firstWhere(
                                    (e) => e.value == sortByStr,
                                  )
                                : null,
                            sortOrder: sortOrderStr != null
                                ? SortOrder.values.firstWhere(
                                    (e) => e.value == sortOrderStr,
                                  )
                                : null,
                          );

                          Navigator.pop(context);
                          ref
                              .read(usersProvider.notifier)
                              .updateFilter(newFilter);
                          AppToast.success(context.l10n.userFilterApplied);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSelectUser(String userId) {
    setState(() {
      if (_selectedUserIds.contains(userId)) {
        _selectedUserIds.remove(userId);
      } else {
        _selectedUserIds.add(userId);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      final state = ref.read(usersProvider);
      final allIds = state.users.map((u) => u.id).toSet();

      if (_selectedUserIds.containsAll(allIds)) {
        _selectedUserIds.clear();
      } else {
        _selectedUserIds.addAll(allIds);
      }
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedUserIds.clear();
    });
  }

  Future<void> _deleteSelectedUsers() async {
    if (_selectedUserIds.isEmpty) {
      AppToast.warning(context.l10n.userNoUsersSelected);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.userDeleteUsers,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.userDeleteConfirmation(_selectedUserIds.length),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.userCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.userDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref
          .read(usersProvider.notifier)
          .deleteManyUsers(_selectedUserIds.toList());
      _cancelSelectMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(usersProvider);

    ref.listen(usersProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError('Users mutation error', next.mutationFailure);
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.userManagement),
      endDrawer: const AppEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: ScreenWrapper(
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: context.colorScheme.primary,
                child: state.isLoading
                    ? _buildLoadingState(context)
                    : state.users.isEmpty
                    ? _buildEmptyState(context)
                    : _buildUsersList(state.users, state.isLoadingMore),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _isSelectMode
          ? null
          : FloatingActionButton(
              onPressed: state.isMutating ? null : _showOptionsBottomSheet,
              backgroundColor: state.isMutating
                  ? context.colors.surfaceVariant
                  : context.colorScheme.primary,
              child: state.isMutating
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.textSecondary,
                      ),
                    )
                  : const Icon(Icons.menu),
            ),
      bottomNavigationBar: _isSelectMode ? _buildSelectionBar(context) : null,
    );
  }

  Widget _buildSelectionBar(BuildContext context) {
    final state = ref.watch(usersProvider);
    final allIds = state.users.map((u) => u.id).toSet();
    final isAllSelected =
        allIds.isNotEmpty && _selectedUserIds.containsAll(allIds);

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: _cancelSelectMode,
            ),
            IconButton(
              icon: Icon(
                isAllSelected ? Icons.deselect : Icons.select_all,
                color: Colors.white,
              ),
              onPressed: _toggleSelectAll,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppText(
                context.l10n.userSelectedCount(_selectedUserIds.length),
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: context.l10n.userDelete,
              color: AppButtonColor.error,
              isFullWidth: false,
              onPressed: _deleteSelectedUsers,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.userSearchUsers,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(usersProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyUsers = List.generate(10, (_) => User.dummy());
    return Skeletonizer(enabled: true, child: _buildUsersList(dummyUsers));
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment, size: 80, color: context.colors.textDisabled),
          const SizedBox(height: 16),
          AppText(
            context.l10n.userNoUsersFound,
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            context.l10n.userCreateFirstUser,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List<User> users, [bool isLoadingMore = false]) {
    final isMutating = ref.watch(
      usersProvider.select((state) => state.isMutating),
    );

    final displayUsers = isLoadingMore
        ? users + List.generate(2, (_) => User.dummy())
        : users;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: displayUsers.length,
      itemBuilder: (context, index) {
        final user = displayUsers[index];
        final isSkeleton = isLoadingMore && index >= users.length;
        final isSelected = _selectedUserIds.contains(user.id);

        return Skeletonizer(
          enabled: isSkeleton,
          child: UserTile(
            user: user,
            isDisabled: isMutating,
            isSelected: isSelected,
            onSelect: _isSelectMode ? (_) => _toggleSelectUser(user.id) : null,
            onLongPress: isSkeleton
                ? null
                : () {
                    if (!_isSelectMode) {
                      setState(() {
                        _isSelectMode = true;
                        _selectedUserIds.clear();
                        _selectedUserIds.add(user.id);
                      });
                      AppToast.info(context.l10n.userLongPressToSelect);
                    }
                  },
            onTap: isSkeleton || _isSelectMode
                ? null
                : () {
                    this.logPresentation('User tapped: ${user.id}');
                    context.push(RouteConstant.userDetail, extra: user);
                  },
          ),
        );
      },
    );
  }
}
