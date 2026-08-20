import 'package:flutter/material.dart';

import 'app_curves.dart';
import 'app_durations.dart';

/// Small animation helpers that respect reduced motion.
abstract final class AnimationUtils {
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration duration(BuildContext context, Duration preferred) =>
      reduceMotion(context) ? Duration.zero : preferred;

  static Widget fadeIn({
    required BuildContext context,
    required Widget child,
    Duration? duration,
    Curve curve = AppCurves.easeOut,
  }) {
    if (reduceMotion(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration ?? AppDurations.base,
      curve: curve,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: child,
    );
  }

  static Widget scalePress({
    required bool pressed,
    required Widget child,
    double scale = 0.97,
  }) {
    return AnimatedScale(
      scale: pressed ? scale : 1,
      duration: AppDurations.fast,
      curve: AppCurves.spring,
      child: child,
    );
  }
}
