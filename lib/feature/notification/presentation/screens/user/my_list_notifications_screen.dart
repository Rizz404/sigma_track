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
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/shared/presentation/widgets/app_error_state.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as app_notif;
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/notification_providers.dart';
import 'package:sigma_track/feature/notification/presentation/widgets/notification_tile.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyListNotificationsScreen extends ConsumerStatefulWidget {
  const MyListNotificationsScreen({super.key});

  @override
  ConsumerState<MyListNotificationsScreen> createState() =>
      _MyListNotificationsScreenState();
}

class _MyListNotificationsScreenState
    extends ConsumerState<MyListNotificationsScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
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
      ref.read(myNotificationsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(myNotificationsProvider.notifier).refresh();
  }

  void _applyFilter() {
    if (_filterFormKey.currentState?.saveAndValidate() ?? false) {
      final formData = _filterFormKey.currentState!.value;

      final newFilter = GetNotificationsCursorUsecaseParams(
        type: formData['type'] != null
            ? NotificationType.values.firstWhere(
                (e) => e.value == formData['type'],
              )
            : null,
        isRead: formData['isRead'] != null ? formData['isRead'] : null,
        sortBy: formData['sortBy'] != null
            ? NotificationSortBy.values.firstWhere(
                (e) => e.value == formData['sortBy'],
              )
            : null,
        sortOrder: formData['sortOrder'] != null
            ? SortOrder.values.firstWhere(
                (e) => e.value == formData['sortOrder'],
              )
            : null,
      );

      ref.read(myNotificationsProvider.notifier).updateFilter(newFilter);
    }
  }

  void _showFilterBottomSheet() {
    final currentFilter = ref.read(myNotificationsProvider).notificationsFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      context.l10n.notificationFiltersAndSorting,
                      style: AppTextStyle.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: FormBuilder(
                  key: _filterFormKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      AppDropdown<String>(
                        name: 'type',
                        label: context.l10n.notificationType,
                        initialValue: currentFilter.type?.value,
                        items: NotificationType.values
                            .map(
                              (type) => AppDropdownItem(
                                value: type.value,
                                label: type.label,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<String>(
                        name: 'isRead',
                        label: context.l10n.notificationReadStatus,
                        initialValue: currentFilter.isRead?.toString(),
                        items: [
                          AppDropdownItem(
                            value: 'true',
                            label: context.l10n.notificationRead,
                          ),
                          AppDropdownItem(
                            value: 'false',
                            label: context.l10n.notificationUnread,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<String>(
                        name: 'sortBy',
                        label: context.l10n.notificationSortBy,
                        initialValue: currentFilter.sortBy?.value,
                        items: NotificationSortBy.values
                            .map(
                              (sortBy) => AppDropdownItem(
                                value: sortBy.value,
                                label: sortBy.value,
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
                              (sortOrder) => AppDropdownItem(
                                value: sortOrder.value,
                                label: sortOrder.label,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: context.l10n.notificationApplyFilters,
                        onPressed: () {
                          _applyFilter();
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myNotificationsProvider);

    ref.listen(myNotificationsProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError('MyNotifications mutation error', next.mutationFailure);
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.notificationMyNotifications),
      endDrawer: const AppEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: ScreenWrapper(
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildFilterButton(),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: context.colorScheme.primary,
                child: state.isLoading
                    ? _buildLoadingState(context)
                    : state.failure != null
                    ? _buildErrorState(context, state.failure!)
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
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.notificationSearchMyNotifications,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(myNotificationsProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildFilterButton() {
    final currentFilter = ref
        .watch(myNotificationsProvider)
        .notificationsFilter;
    final hasActiveFilters =
        currentFilter.type != null ||
        currentFilter.isRead != null ||
        currentFilter.sortBy != null ||
        currentFilter.sortOrder != null;

    return InkWell(
      onTap: _showFilterBottomSheet,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasActiveFilters
                ? context.colorScheme.primary
                : context.colors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: hasActiveFilters
                  ? context.colorScheme.primary
                  : context.colors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppText(
                hasActiveFilters
                    ? context.l10n.notificationFiltersApplied
                    : context.l10n.notificationFilterAndSort,
                style: AppTextStyle.bodyMedium,
                color: hasActiveFilters
                    ? context.colorScheme.primary
                    : context.colors.textSecondary,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: hasActiveFilters
                  ? context.colorScheme.primary
                  : context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyNotifications = List.generate(
      10,
      (_) => app_notif.Notification.dummy(),
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
            context.l10n.notificationNoNotificationsYet,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(
    List<app_notif.Notification> notifications, [
    bool isLoadingMore = false,
  ]) {
    final isMutating = ref.watch(
      myNotificationsProvider.select((state) => state.isMutating),
    );

    final displayNotifications = isLoadingMore
        ? notifications +
              List.generate(2, (_) => app_notif.Notification.dummy())
        : notifications;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: displayNotifications.length,
      itemBuilder: (context, index) {
        final notification = displayNotifications[index];
        final isSkeleton = isLoadingMore && index >= notifications.length;

        return Skeletonizer(
          enabled: isSkeleton,
          child: NotificationTile(
            notification: notification,
            isDisabled: isMutating,
            onTap: isSkeleton
                ? null
                : () {
                    this.logPresentation(
                      'Notification tapped: ${notification.id}',
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

  Widget _buildErrorState(BuildContext context, Failure failure) {
    return AppErrorState(
      title: context.l10n.notificationFailedToLoadData,
      description: failure.message,
      onRetry: _onRefresh,
    );
  }
}
