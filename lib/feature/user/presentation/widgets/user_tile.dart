import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/shared/presentation/widgets/app_avatar.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class UserTile extends StatelessWidget {
  final User user;
  final bool isDisabled;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelect;
  final VoidCallback? onLongPress;

  const UserTile({
    super.key,
    required this.user,
    this.isDisabled = false,
    this.isSelected = false,
    this.onTap,
    this.onSelect,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isSelected
        ? context.colorScheme.primary
        : context.colors.border;
    final Color? tileColor = isSelected
        ? context.colorScheme.primaryContainer.withOpacity(0.3)
        : null;

    return Card(
      elevation: 0,
      color: tileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      child: InkWell(
        onTap: isDisabled
            ? null
            : (onSelect != null ? () => onSelect!(!isSelected) : onTap),
        onLongPress: isDisabled ? null : onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (onSelect != null) ...[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: isDisabled ? null : onSelect,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                AppAvatar(
                  size: AvatarSize.large,
                  imageUrl: user.avatarUrl,
                  backgroundColor: context.colorScheme.primaryContainer,
                  placeholder: AppText(
                    user.fullName
                        .split(' ')
                        .map((e) => e.isNotEmpty ? e[0] : '')
                        .take(2)
                        .join()
                        .toUpperCase(),
                    style: AppTextStyle.titleMedium,
                    color: context.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        user.fullName,
                        style: AppTextStyle.titleMedium,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        user.email,
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (user.employeeId != null) ...[
                        const SizedBox(height: 4),
                        AppText(
                          'ID: ${user.employeeId}',
                          style: AppTextStyle.labelSmall,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(
                          context,
                          user.role,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        user.role.name.toUpperCase(),
                        style: AppTextStyle.labelSmall,
                        color: _getRoleColor(context, user.role),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: user.isActive
                            ? context.semantic.success
                            : context.colors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(BuildContext context, dynamic role) {
    switch (role.toString().split('.').last) {
      case 'admin':
        return context.semantic.error;
      case 'manager':
        return context.semantic.warning;
      case 'employee':
        return context.semantic.info;
      default:
        return context.colors.textPrimary;
    }
  }
}
