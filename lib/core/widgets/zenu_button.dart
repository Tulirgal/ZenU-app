import 'package:flutter/material.dart';

import '../animation/app_curves.dart';
import '../animation/app_durations.dart';
import '../haptics/haptic_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class ZenUButton extends StatefulWidget {
  const ZenUButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = true,
    this.haptic = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;
  final bool haptic;

  @override
  State<ZenUButton> createState() => _ZenUButtonState();
}

class _ZenUButtonState extends State<ZenUButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final child = AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: AppDurations.fast,
      curve: AppCurves.spring,
      child: Material(
        color: enabled ? AppColors.primary : AppColors.primarySoft,
        borderRadius: AppRadius.largeAll,
        child: InkWell(
          onTap: enabled
              ? () {
                  if (widget.haptic) hapticService.light();
                  widget.onPressed?.call();
                }
              : null,
          onHighlightChanged: (v) => setState(() => _pressed = v),
          borderRadius: AppRadius.largeAll,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Center(
                child: Text(
                  widget.label,
                  style: AppTextStyles.button.copyWith(
                    color: enabled ? AppColors.textInverse : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return widget.expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class ZenUSecondaryButton extends StatelessWidget {
  const ZenUSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = OutlinedButton(
      onPressed: onPressed == null
          ? null
          : () {
              hapticService.selection();
              onPressed!();
            },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.border),
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeAll),
      ),
      child: Text(
        label,
        style: AppTextStyles.button.copyWith(color: AppColors.primary),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class ZenUTextButton extends StatelessWidget {
  const ZenUTextButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed == null
          ? null
          : () {
              hapticService.selection();
              onPressed!();
            },
      child: Text(
        label,
        style: AppTextStyles.button.copyWith(color: AppColors.primary),
      ),
    );
  }
}
