import 'package:flutter/material.dart';

import '../haptics/haptic_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Canonical ZenU back control — mobile port of web `ZenBackLink`.
///
/// Visual: ← ZenU | Section
class UnifiedBackButton extends StatelessWidget {
  const UnifiedBackButton({
    super.key,
    this.section,
    this.onPressed,
    this.floating = false,
  });

  /// Module label after the divider (e.g. "Meditation").
  final String? section;

  /// Defaults to [Navigator.maybePop].
  final VoidCallback? onPressed;

  /// When true, positions as a floating safe-area pill.
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final sectionLabel = section ?? 'Back';
    final aria = sectionLabel == 'Back'
        ? 'Back to ZenU home'
        : 'Back to ZenU from $sectionLabel';

    final pill = Semantics(
      button: true,
      label: aria,
      child: Material(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: AppRadius.pillAll,
        child: InkWell(
          borderRadius: AppRadius.pillAll,
          onTap: () {
            hapticService.selection();
            if (onPressed != null) {
              onPressed!();
            } else {
              Navigator.of(context).maybePop();
            }
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: AppRadius.pillAll,
              boxShadow: AppShadows.floating,
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'ZenU',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  width: 1,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: AppColors.border,
                ),
                Text(
                  sectionLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!floating) return pill;

    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: pill,
        ),
      ),
    );
  }
}
