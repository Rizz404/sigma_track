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
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as notification_entity;
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/notification_providers.dart';
import 'package:sigma_track/feature/notification/presentation/widgets/notification_tile.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_list_bottom_sheet.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListNotificationsScreen extends ConsumerStatefulWidget {
  const ListNotificationsScreen({super.key});

  @override
  ConsumerState<ListNotificationsScreen> createState() =>
      _ListNotificationsScreenState();
}

class _ListNotificationsScreenState
    extends ConsumerState<ListNotificationsScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  final Set<String> _selectedNotificationIds = {};
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
      ref.read(notificationsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _selectedNotificationIds.clear();
    _isSelectMode = false;
    await ref.read(notificationsProvider.notifier).refresh();
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
        onSelectMany: () {
          Navigator.pop(context);
          setState(() {
            _isSelectMode = true;
            _selectedNotificationIds.clear();
          });
          AppToast.info(context.l10n.notificationSelectNotificationsToDelete);
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        createTitle: context.l10n.notificationCreateNotification,
        createSubtitle: context.l10n.notificationCreateNotificationSubtitle,
        selectManyTitle: context.l10n.notificationSelectMany,
        selectManySubtitle: context.l10n.notificationSelectManySubtitle,
        filterSortTitle: context.l10n.notificationFilterAndSort,
        filterSortSubtitle: context.l10n.notificationFilterAndSortSubtitle,
      ),
    );
  }

  Future<List<Asset>> _searchAssets(String query) async {
    final notifier = ref.read(assetsSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(assetsSearchProvider);
    return state.assets;
  }

  Future<List<User>> _searchUsers(String query) async {
    final notifier = ref.read(usersSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(usersSearchProvider);
    return state.users;
  }

  Widget _buildFilterSortBottomSheet() {
    final currentFilter = ref.read(notificationsProvider).notificationsFilter;

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
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchField<User>(
                    name: 'userId',
                    label: context.l10n.notificationFilterByUser,
                    hintText: context.l10n.notificationSearchUser,
                    enableAutocomplete: true,
                    onSearch: _searchUsers,
                    itemDisplayMapper: (user) => user.fullName,
                    itemValueMapper: (user) => user.id,
                    itemSubtitleMapper: (user) => user.email,
                    itemIcon: Icons.person,
                    initialItemsToShow: 5,
                    itemsPerLoadMore: 5,
                    enableLoadMore: true,
                    suggestionsMaxHeight: 300,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchField<Asset>(
                    name: 'relatedAssetId',
                    label: context.l10n.notificationFilterByRelatedAsset,
                    hintText: context.l10n.notificationSearchAsset,
                    enableAutocomplete: true,
                    onSearch: _searchAssets,
                    itemDisplayMapper: (asset) => asset.assetName,
                    itemValueMapper: (asset) => asset.id,
                    itemSubtitleMapper: (asset) => asset.assetTag,
                    itemIcon: Icons.inventory,
                    initialItemsToShow: 5,
                    itemsPerLoadMore: 5,
                    enableLoadMore: true,
                    suggestionsMaxHeight: 300,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AppText(
                context.l10n.notificationFiltersAndSorting,
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'sortBy',
                label: context.l10n.notificationSortBy,
                initialValue: currentFilter.sortBy?.value,
                items: NotificationSortBy.values
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
                label: context.l10n.notificationSortOrder,
                initialValue: currentFilter.sortOrder?.value,
                items: SortOrder.values
                    .map(
                      (order) => AppDropdownItem<String>(
                        value: order.value,
                        label: order.label,
                        icon: Icon(order.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                name: 'type',
                label: context.l10n.notificationType,
                initialValue: currentFilter.type?.value,
                items: NotificationType.values
                    .map(
                      (type) => AppDropdownItem<String>(
                        value: type.value,
                        label: type.label,
                        icon: Icon(type.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              FormBuilderCheckbox(
                name: 'isRead',
                title: AppText(context.l10n.notificationIsRead),
                initialValue: currentFilter.isRead ?? false,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.l10n.notificationReset,
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter = GetNotificationsCursorUsecaseParams(
                          search: currentFilter.search,
                          // * Reset semua filter kecuali search
                        );
                        Navigator.pop(context);
                        ref
                            .read(notificationsProvider.notifier)
                            .updateFilter(newFilter);
                        AppToast.success(context.l10n.notificationFilterReset);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: context.l10n.notificationApply,
                      onPressed: () {
                        if (_filterFormKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData = _filterFormKey.currentState!.value;
                          final userId = formData['userId'] as String?;
                          final relatedAssetId =
                              formData['relatedAssetId'] as String?;
                          final typeStr = formData['type'] as String?;
                          final isRead = formData['isRead'] as bool?;
                          final sortByStr = formData['sortBy'] as String?;
                          final sortOrderStr = formData['sortOrder'] as String?;

                          final newFilter = GetNotificationsCursorUsecaseParams(
                            search: currentFilter.search,
                            userId: userId,
                            relatedAssetId: relatedAssetId,
                            type: typeStr != null
                                ? NotificationType.values.firstWhere(
                                    (e) => e.value == typeStr,
                                  )
                                : null,
                            isRead: isRead,
                            sortBy: sortByStr != null
                                ? NotificationSortBy.values.firstWhere(
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
                              .read(notificationsProvider.notifier)
                              .updateFilter(newFilter);
                          AppToast.success(
                            context.l10n.notificationFilterApplied,
                          );
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

  void _toggleSelectNotification(String notificationId) {
    setState(() {
      if (_selectedNotificationIds.contains(notificationId)) {
        _selectedNotificationIds.remove(notificationId);
      } else {
        _selectedNotificationIds.add(notificationId);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      final state = ref.read(notificationsProvider);
      final allIds = state.notifications.map((n) => n.id).toSet();

      if (_selectedNotificationIds.containsAll(allIds)) {
        _selectedNotificationIds.clear();
      } else {
        _selectedNotificationIds.addAll(allIds);
      }
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedNotificationIds.clear();
    });
  }

  Future<void> _markSelectedAsRead() async {
    if (_selectedNotificationIds.isEmpty) {
      AppToast.warning(context.l10n.notificationNoNotificationsSelected);
      return;
    }

    await ref
        .read(notificationsProvider.notifier)
        .markManyAsRead(_selectedNotificationIds.toList());

    AppToast.success(
      context.l10n.notificationMarkedAsRead(_selectedNotificationIds.length),
    );
    _cancelSelectMode();
  }

  Future<void> _markSelectedAsUnread() async {
    if (_selectedNotificationIds.isEmpty) {
      AppToast.warning(context.l10n.notificationNoNotificationsSelected);
      return;
    }

    await ref
        .read(notificationsProvider.notifier)
        .markManyAsUnread(_selectedNotificationIds.toList());

    AppToast.success(
      context.l10n.notificationMarkedAsUnread(_selectedNotificationIds.length),
    );
    _cancelSelectMode();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);

    ref.listen(notificationsProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError('Notifications mutation error', next.mutationFailure);
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.notificationManagement),
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
                    : state.notifications.isEmpty
                    ? _buildEmptyState(context)
                    : _buildNotificationsList(
                        state.notifications,
                        state.isLoadingMore,
                      ),
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
    final state = ref.watch(notificationsProvider);
    final allIds = state.notifications.map((n) => n.id).toSet();
    final isAllSelected =
        allIds.isNotEmpty && _selectedNotificationIds.containsAll(allIds);

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
                context.l10n.notificationSelectedCount(
                  _selectedNotificationIds.length,
                ),
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: context.l10n.notificationMarkAsUnread,
              color: AppButtonColor.secondary,
              isFullWidth: false,
              onPressed: _markSelectedAsUnread,
            ),
            const SizedBox(width: 8),
            AppButton(
              text: context.l10n.notificationMarkAsRead,
              color: AppButtonColor.secondary,
              isFullWidth: false,
              onPressed: _markSelectedAsRead,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.notificationSearchNotifications,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(notificationsProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyNotifications = List.generate(
      6,
      (_) => notification_entity.Notification.dummy(),
    );
    return Skeletonizer(
      enabled: true,
      child: _buildNotificationsList(dummyNotifications),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications,
            size: 80,
            color: context.colors.textDisabled,
          ),
          const SizedBox(height: 16),
          AppText(
            context.l10n.notificationNoNotificationsFound,
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            context.l10n.notificationCreateFirstNotification,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
    List<notification_entity.Notification> notifications, [
    bool isLoadingMore = false,
  ]) {
    final isMutating = ref.watch(
      notificationsProvider.select((state) => state.isMutating),
    );

    final displayNotifications = isLoadingMore
        ? notifications +
              List.generate(2, (_) => notification_entity.Notification.dummy())
        : notifications;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: displayNotifications.length,
      itemBuilder: (context, index) {
        final notification = displayNotifications[index];
        final isSkeleton = isLoadingMore && index >= notifications.length;
        final isSelected = _selectedNotificationIds.contains(notification.id);

        return Skeletonizer(
          enabled: isSkeleton,
          child: NotificationTile(
            notification: notification,
            isDisabled: isMutating,
            isSelected: isSelected,
            onSelect: _isSelectMode
                ? (_) => _toggleSelectNotification(notification.id)
                : null,
            onLongPress: isSkeleton
                ? null
                : _isSelectMode
                ? null
                : () {
                    setState(() {
                      _isSelectMode = true;
                      _selectedNotificationIds.clear();
                      _selectedNotificationIds.add(notification.id);
                    });
                    AppToast.info(context.l10n.notificationLongPressToSelect);
                  },
            onTap: isSkeleton || _isSelectMode
                ? null
                : () {
                    this.logPresentation(
                      'notification_entity.Notification tapped: ${notification.id}',
                    );
                    context.push(
                      RouteConstant.notificationDetail,
                      extra: notification,
                    );
                  },
          ),
        );
      },
    );
  }
}
