import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'panda_animation.dart';
import 'panda_quality.dart';
import 'panda_renderer.dart';
import 'panda_state.dart';

/// Temporary CustomPainter stand-in until the production native Panda GLB exists.
///
/// Showcase must label this clearly — it is not the final companion.
class PlaceholderPandaRenderer implements PandaRenderer {
  PandaState _state = PandaState.idle;
  PandaQuality _quality = PandaQuality.medium;
  bool _paused = false;

  @override
  bool get isTemporaryPlaceholder => true;

  @override
  String get assetPath => 'assets/panda/zenu_panda.glb';

  @override
  Future<void> initialize() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> loadAsset(String path) async {}

  @override
  void setState(PandaState state) => _state = state;

  @override
  void setQuality(PandaQuality quality) => _quality = quality;

  @override
  void pause() => _paused = true;

  @override
  void resume() => _paused = false;

  @override
  void releaseResources() => _paused = true;

  @override
  Widget build(BuildContext context, {required double size}) {
    return Semantics(
      label: 'Temporary development Panda placeholder, ${_state.label}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: _PlaceholderPandaVisual(
              state: _state,
              paused: _paused,
              quality: _quality,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.warningSoft,
              borderRadius: AppRadius.pillAll,
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
            ),
            child: Text(
              'TEMPORARY DEVELOPMENT PLACEHOLDER',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderPandaVisual extends StatefulWidget {
  const _PlaceholderPandaVisual({
    required this.state,
    required this.paused,
    required this.quality,
  });

  final PandaState state;
  final bool paused;
  final PandaQuality quality;

  @override
  State<_PlaceholderPandaVisual> createState() => _PlaceholderPandaVisualState();
}

class _PlaceholderPandaVisualState extends State<_PlaceholderPandaVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: PandaAnimation.loopDuration(widget.state),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant _PlaceholderPandaVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = PandaAnimation.loopDuration(widget.state);
    _syncMotion();
  }

  void _syncMotion() {
    final animate = PandaAnimation.shouldAnimate(context) && !widget.paused;
    if (animate) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    } else {
      _controller.stop();
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = switch (widget.quality) {
      PandaQuality.high => 1.0,
      PandaQuality.medium => 0.85,
      PandaQuality.low => 0.7,
    };

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final breathe = 1 + (t - 0.5) * 0.04 * detail;
        return Transform.scale(
          scale: breathe,
          child: CustomPaint(
            painter: _PandaSilhouettePainter(state: widget.state),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class _PandaSilhouettePainter extends CustomPainter {
  _PandaSilhouettePainter({required this.state});

  final PandaState state;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.shortestSide * 0.38;

    final bodyPaint = Paint()..color = const Color(0xFFF7F4F0);
    final accentPaint = Paint()..color = const Color(0xFF2A2A2A);
    final cheekPaint = Paint()
      ..color = AppColors.primarySoft.withValues(alpha: 0.9);

    // Soft glow disk
    canvas.drawCircle(
      Offset(cx, cy + r * 0.1),
      r * 1.35,
      Paint()..color = AppColors.secondarySoft.withValues(alpha: 0.55),
    );

    // Ears
    canvas.drawCircle(Offset(cx - r * 0.75, cy - r * 0.75), r * 0.32, accentPaint);
    canvas.drawCircle(Offset(cx + r * 0.75, cy - r * 0.75), r * 0.32, accentPaint);

    // Head / body
    canvas.drawCircle(Offset(cx, cy), r, bodyPaint);
    canvas.drawCircle(Offset(cx, cy + r * 0.85), r * 0.72, bodyPaint);

    // Eye patches
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - r * 0.35, cy - r * 0.05),
        width: r * 0.42,
        height: r * 0.5,
      ),
      accentPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + r * 0.35, cy - r * 0.05),
        width: r * 0.42,
        height: r * 0.5,
      ),
      accentPaint,
    );

    // Eyes
    final eyeY = cy - r * 0.05 + r * _eyeOffsetFactor();
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - r * 0.35, eyeY), r * 0.1, eyePaint);
    canvas.drawCircle(Offset(cx + r * 0.35, eyeY), r * 0.1, eyePaint);
    canvas.drawCircle(Offset(cx - r * 0.35, eyeY), r * 0.05, accentPaint);
    canvas.drawCircle(Offset(cx + r * 0.35, eyeY), r * 0.05, accentPaint);

    // Cheeks
    canvas.drawCircle(Offset(cx - r * 0.55, cy + r * 0.28), r * 0.12, cheekPaint);
    canvas.drawCircle(Offset(cx + r * 0.55, cy + r * 0.28), r * 0.12, cheekPaint);

    // Nose + mouth
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.22), width: r * 0.16, height: r * 0.1),
      accentPaint,
    );
    final mouth = Path()
      ..moveTo(cx - r * 0.12, cy + r * 0.38)
      ..quadraticBezierTo(cx, cy + r * (0.38 + _mouthCurve()), cx + r * 0.12, cy + r * 0.38);
    canvas.drawPath(
      mouth,
      Paint()
        ..color = accentPaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  double _eyeOffsetFactor() {
    switch (state) {
      case PandaState.sleeping:
        return 0.02;
      case PandaState.sad:
      case PandaState.concerned:
        return 0.04;
      default:
        return 0;
    }
  }

  double _mouthCurve() {
    switch (state) {
      case PandaState.happy:
      case PandaState.celebrating:
      case PandaState.greeting:
      case PandaState.success:
        return 0.12;
      case PandaState.sad:
      case PandaState.error:
        return -0.06;
      default:
        return 0.04;
    }
  }

  @override
  bool shouldRepaint(covariant _PandaSilhouettePainter oldDelegate) =>
      oldDelegate.state != state;
}
