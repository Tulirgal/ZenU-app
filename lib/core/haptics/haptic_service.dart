import 'package:flutter/services.dart';

/// Semantic haptic feedback — call intentionally from components.
class HapticService {
  const HapticService();

  Future<void> light() => HapticFeedback.lightImpact();

  Future<void> medium() => HapticFeedback.mediumImpact();

  Future<void> heavy() => HapticFeedback.heavyImpact();

  Future<void> selection() => HapticFeedback.selectionClick();

  Future<void> success() => HapticFeedback.mediumImpact();

  Future<void> warning() => HapticFeedback.mediumImpact();

  Future<void> error() => HapticFeedback.heavyImpact();
}

/// App-wide default instance.
const hapticService = HapticService();
