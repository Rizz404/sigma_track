import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
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
  Category? _category;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _category = widget.category;
    if (_category == null &&
        (widget.id != null || widget.categoryCode != null)) {
      // TODO: Fetch category by id or categoryCode
      _fetchCategory();
    }
  }

  Future<void> _fetchCategory() async {
    setState(() => _isLoading = true);
    // TODO: Implement fetch category logic
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _handleEdit() {
    if (_category == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminCategoryUpsert, extra: _category);
    } else {
      AppToast.warning('Only admin can edit categories');
    }
  }

  void _handleDelete() async {
    if (_category == null) return;

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
          'Are you sure you want to delete "${_category!.categoryName}"?',
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
          .deleteCategory(DeleteCategoryUsecaseParams(id: _category!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CategoriesState>(categoriesProvider, (previous, next) {
      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Operation successful');
        if (previous?.isMutating == true) {
          context.pop();
        }
      } else if (next.failure != null) {
        this.logError('Category mutation error', next.failure);
        AppToast.error(next.failure?.message ?? 'Operation failed');
      }
    });

    final isLoading = _isLoading || _category == null;

    return Scaffold(
      appBar: CustomAppBar(
        title: isLoading ? 'Category Detail' : _category!.categoryName,
        actions: [
          if (!isLoading)
            IconButton(icon: const Icon(Icons.edit), onPressed: _handleEdit),
          if (!isLoading)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _handleDelete,
            ),
        ],
      ),
      body: Skeletonizer(
        enabled: isLoading,
        child: ScreenWrapper(
          child: isLoading ? _buildLoadingContent() : _buildContent(),
        ),
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

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Category Information', [
            _buildInfoRow('Category Code', _category!.categoryCode),
            _buildInfoRow('Category Name', _category!.categoryName),
            _buildInfoRow('Description', _category!.description),
            if (_category!.parentId != null)
              _buildInfoRow('Parent ID', _category!.parentId!),
          ]),
          const SizedBox(height: 16),
          if (_category!.children.isNotEmpty) ...[
            _buildInfoCard(
              'Child Categories (${_category!.children.length})',
              _category!.children
                  .map((child) => _buildChildCategoryItem(child))
                  .toList(),
            ),
          ],
          const SizedBox(height: 16),
          _buildInfoCard('Metadata', [
            _buildInfoRow('Created At', _formatDateTime(_category!.createdAt)),
            _buildInfoRow('Updated At', _formatDateTime(_category!.updatedAt)),
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

  Widget _buildChildCategoryItem(Category child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colors.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.subdirectory_arrow_right,
              color: context.colors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    child.categoryName,
                    style: AppTextStyle.bodyMedium,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    child.categoryCode,
                    style: AppTextStyle.bodySmall,
                    color: context.colors.textTertiary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
