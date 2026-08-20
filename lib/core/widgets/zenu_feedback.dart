import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'zenu_button.dart';

class ZenUChip extends StatelessWidget {
  const ZenUChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.primarySoft,
      borderRadius: AppRadius.pillAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: selected ? AppColors.textInverse : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class ZenULoading extends StatelessWidget {
  const ZenULoading({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primary,
            backgroundColor: AppColors.primarySoft,
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(label!, style: AppTextStyles.bodySmall),
        ],
      ],
    );
  }
}

class ZenUEmptyState extends StatelessWidget {
  const ZenUEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.spa_outlined, size: 40, color: AppColors.secondary),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTextStyles.title, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            ZenUButton(label: actionLabel!, onPressed: onAction, expand: false),
          ],
        ],
      ),
    );
  }
}

Future<void> showZenUModal({
  required BuildContext context,
  required String title,
  required String body,
  String confirmLabel = 'OK',
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.extraLargeAll),
      title: Text(title, style: AppTextStyles.title),
      content: Text(body, style: AppTextStyles.body),
      actions: [
        ZenUTextButton(
          label: confirmLabel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

Future<void> showZenUBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.extraLarge)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: child,
      ),
    ),
  );
}
