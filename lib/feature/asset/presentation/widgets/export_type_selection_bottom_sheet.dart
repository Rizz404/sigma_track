import 'package:flutter/material.dart';

import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_list_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/widgets/export_asset_data_matrix_bottom_sheet.dart';
import 'package:sigma_track/feature/asset/presentation/widgets/export_assets_bottom_sheet.dart';
import 'package:sigma_track/feature/asset/presentation/widgets/export_type_card.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class ExportTypeSelectionBottomSheet extends StatelessWidget {
  final ExportAssetListUsecaseParams listParams;
  final ExportAssetDataMatrixUsecaseParams dataMatrixParams;

  const ExportTypeSelectionBottomSheet({
    super.key,
    required this.listParams,
    required this.dataMatrixParams,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            AppText(
              context.l10n.assetExportAssets,
              style: AppTextStyle.titleLarge,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            AppText(
              context.l10n.assetSelectExportType,
              style: AppTextStyle.bodyMedium,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: 24),
            ExportTypeCard(
              icon: Icons.list_alt,
              title: context.l10n.assetExportList,
              subtitle: context.l10n.assetExportListSubtitle,
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: context.colors.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) =>
                      ExportAssetsBottomSheet(initialParams: listParams),
                );
              },
            ),
            const SizedBox(height: 12),
            ExportTypeCard(
              icon: Icons.qr_code_2,
              title: context.l10n.assetExportDataMatrix,
              subtitle: context.l10n.assetExportDataMatrixSubtitle,
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: context.colors.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder: (context) => ExportAssetDataMatrixBottomSheet(
                    initialParams: dataMatrixParams,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
