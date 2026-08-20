import 'package:flutter/material.dart';

import 'app_curves.dart';
import 'app_durations.dart';

/// Shared page / route transitions.
abstract final class AppTransitions {
  static PageRouteBuilder<T> fadeSlide<T>({
    required Widget page,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: AppDurations.page,
      reverseTransitionDuration: AppDurations.base,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final reduce = MediaQuery.disableAnimationsOf(context);
        if (reduce) return child;

        final curved = CurvedAnimation(parent: animation, curve: AppCurves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
