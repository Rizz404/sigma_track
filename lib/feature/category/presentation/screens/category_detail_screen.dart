import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryDetailScreen extends ConsumerStatefulWidget {
  final Category? category;
  final String? id;
  final String? categoryCode;

  const CategoryDetailScreen({
    super.key,
    this.category,
    this.id,
    this.categoryCode,
  });

  @override
  ConsumerState<CategoryDetailScreen> createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _handleEdit(Category category) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminCategoryUpsert, extra: category);
    } else {
      AppToast.warning('Only admin can edit categories');
    }
  }

  void _handleDelete(Category category) async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning('Only admin can delete categories');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Delete Category',
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          'Are you sure you want to delete "${category.categoryName}"?',
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const AppText('Cancel'),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'Delete',
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(categoriesProvider.notifier)
          .deleteCategory(DeleteCategoryUsecaseParams(id: category.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Determine category source: extra > fetch by id > fetch by code
    Category? category = widget.category;
    bool isLoading = false;
    String? errorMessage;

    // * If no category from extra, fetch by id or code
    if (category == null && widget.id != null) {
      final state = ref.watch(getCategoryByIdProvider(widget.id!));
      category = state.category;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;
    } else if (category == null && widget.categoryCode != null) {
      final state = ref.watch(getCategoryByCodeProvider(widget.categoryCode!));
      category = state.category;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;
    }

    // * Listen only for delete operation
    ref.listen<CategoriesState>(categoriesProvider, (previous, next) {
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(next.mutationMessage ?? 'Category deleted');
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(next.mutationFailure?.message ?? 'Delete failed');
        }
      }
    });

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(title: category?.categoryName ?? 'Category Detail'),
      endDrawer: const AppEndDrawer(),
      body: _buildBody(
        category: category,
        isLoading: isLoading,
        isAdmin: isAdmin,
        errorMessage: errorMessage,
      ),
    );
  }

  Widget _buildBody({
    required Category? category,
    required bool isLoading,
    required bool isAdmin,
    String? errorMessage,
  }) {
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(errorMessage, style: AppTextStyle.bodyMedium),
            const SizedBox(height: 16),
            AppButton(text: 'Go Back', onPressed: () => context.pop()),
          ],
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading || category == null,
      child: Column(
        children: [
          Expanded(
            child: ScreenWrapper(
              child: isLoading || category == null
                  ? _buildLoadingContent()
                  : _buildContent(category),
            ),
          ),
          if (!isLoading && category != null && isAdmin)
            AppDetailActionButtons(
              onEdit: () => _handleEdit(category),
              onDelete: () => _handleDelete(category),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummyCategory = Category.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Category Information', [
            _buildInfoRow('Category Code', dummyCategory.categoryCode),
            _buildInfoRow('Category Name', dummyCategory.categoryName),
            _buildInfoRow('Description', dummyCategory.description),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent(Category category) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Category Information', [
            _buildInfoRow('Category Code', category.categoryCode),
            _buildInfoRow('Category Name', category.categoryName),
            _buildTextBlock('Description', category.description),
            if (category.parent != null)
              _buildInfoRow('Parent Category', category.parent!.categoryName),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Metadata', [
            _buildInfoRow('Created At', _formatDateTime(category.createdAt)),
            _buildInfoRow('Updated At', _formatDateTime(category.updatedAt)),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
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
              title,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              label,
              style: AppTextStyle.bodyMedium,
              color: context.colors.textSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: AppText(
              value,
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBlock(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.colors.border),
            ),
            child: AppText(
              value,
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
