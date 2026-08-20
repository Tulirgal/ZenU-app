import 'package:flutter/material.dart';

import '../animation/app_curves.dart';
import '../animation/app_durations.dart';
import '../animation/animation_utils.dart';
import 'panda_state.dart';

/// Soft Flutter motion helpers for placeholder / ambient Panda motion.
abstract final class PandaAnimation {
  static bool shouldAnimate(BuildContext context) =>
      !AnimationUtils.reduceMotion(context);

  static Duration loopDuration(PandaState state) {
    switch (state) {
      case PandaState.sleeping:
        return const Duration(milliseconds: 3200);
      case PandaState.loading:
        return const Duration(milliseconds: 1200);
      case PandaState.celebrating:
        return const Duration(milliseconds: 900);
      default:
        return AppDurations.breathe;
    }
  }

  static Curve curveFor(PandaState state) {
    switch (state) {
      case PandaState.celebrating:
      case PandaState.happy:
        return AppCurves.spring;
      default:
        return AppCurves.breathe;
    }
  }
}
