import 'package:flutter/material.dart';

import '../core/animation/app_transitions.dart';
import '../core/theme/design_system_showcase.dart';

/// Lightweight route names for the design-system phase.
/// Product feature routes will be added later.
abstract final class AppRoutes {
  static const String showcase = '/';
  static const String transitionDemo = '/dev/transition';
}

/// Central navigator helpers — keep screens from hardcoding route construction.
abstract final class AppNavigator {
  static void openShowcase(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      AppTransitions.fadeSlide(page: const DesignSystemShowcase()),
      (_) => false,
    );
  }
}
