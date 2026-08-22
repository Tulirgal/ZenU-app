import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../core/theme/module_themes.dart';

class ModuleBackground extends StatefulWidget {
  final String moduleKey;
  final Widget child;
  const ModuleBackground({super.key, required this.moduleKey, required this.child});

  @override
  State<ModuleBackground> createState() => _ModuleBackgroundState();
}

class _ModuleBackgroundState extends State<ModuleBackground>
    with SingleTickerProviderStateMixin {
  late final ModuleTheme _theme;
  late final Ticker _ticker;
  late final List<_P> _particles;
  List<_AuroraLine>? _auroraLines;
  bool _initialized = false;
  double _t = 0;

  @override
  void initState() {
    super.initState();
    _theme = ModuleThemes.getTheme(widget.moduleKey);
    _ticker = createTicker((elapsed) {
      setState(() {
        _t = elapsed.inMilliseconds / 1000.0 * 0.72; // equivalent to t += 0.012 at 60fps
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      _particles = _buildParticles(size);
      if (_theme.liveEffect == LiveEffect.aurora) {
        _auroraLines = _buildAuroraLines(size);
      }
      _initialized = true;
      if (_theme.liveEffect != LiveEffect.none) {
        _ticker.start();
      }
    }
  }

  List<_P> _buildParticles(Size s) {
    final rng = Random();
    return List.generate(_theme.particleCount, (_) => _P(
      x:      rng.nextDouble() * s.width,
      y:      rng.nextDouble() * s.height,
      size:   _theme.particleSizeMin + rng.nextDouble() * (_theme.particleSizeMax - _theme.particleSizeMin),
      vx:     (rng.nextDouble() - 0.5) * _theme.particleSpeed,
      vy:     -rng.nextDouble() * _theme.particleSpeed - 0.05,
      opacity: 0.3 + rng.nextDouble() * 0.6,
      phase:  rng.nextDouble() * pi * 2,
      wobble: (rng.nextDouble() - 0.5) * 0.01,
    ));
  }

  List<_AuroraLine> _buildAuroraLines(Size s) {
    final rng = Random();
    return List.generate(4, (i) => _AuroraLine(
      y: s.height * (0.2 + i * 0.15),
      amp: 40 + rng.nextDouble() * 60,
      freq: 0.002 + rng.nextDouble() * 0.002,
      phase: rng.nextDouble() * pi * 2,
      speed: 0.003 + rng.nextDouble() * 0.004,
      hue: 260.0 + i * 30.0,
    ));
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(gradient: _theme.gradient),
    child: Stack(children: [
      if (_theme.liveEffect != LiveEffect.none)
        Positioned.fill(
          child: CustomPaint(
            painter: _LivePainter(
              particles: _particles,
              auroraLines: _auroraLines,
              effect: _theme.liveEffect,
              color: _theme.particleColor,
              theme: _theme,
              t: _t,
            ),
          ),
        ),
      widget.child,
    ]),
  );
}

class _P {
  double x, y, size, vx, vy, opacity, phase, wobble;
  _P({required this.x, required this.y, required this.size, required this.vx, required this.vy, required this.opacity, required this.phase, required this.wobble});
}

class _AuroraLine {
  double y, amp, freq, phase, speed, hue;
  _AuroraLine({required this.y, required this.amp, required this.freq, required this.phase, required this.speed, required this.hue});
}

class _LivePainter extends CustomPainter {
  final List<_P> particles;
  final List<_AuroraLine>? auroraLines;
  final LiveEffect effect;
  final Color color;
  final ModuleTheme theme;
  final double t;

  _LivePainter({
    required this.particles,
    this.auroraLines,
    required this.effect,
    required this.color,
    required this.theme,
    required this.t,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (effect) {
      case LiveEffect.stars:     _drawStars(canvas, size); break;
      case LiveEffect.bubbles:   _drawBubbles(canvas, size); break;
      case LiveEffect.ripples:   _drawRipples(canvas, size); break;
      case LiveEffect.leaves:    _drawLeaves(canvas, size); break;
      case LiveEffect.fireflies: _drawFireflies(canvas, size); break;
      case LiveEffect.petals:    _drawPetals(canvas, size); break;
      case LiveEffect.aurora:    _drawAurora(canvas, size); break;
      case LiveEffect.none:      break;
    }
  }

  void _drawStars(Canvas c, Size s) {
    for (var p in particles) {
      p.phase += 0.008;
      final alpha = (p.opacity * (0.5 + 0.5 * sin(p.phase))).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;
      c.drawCircle(Offset(p.x, p.y), p.size, paint);
      
      p.x += p.vx;
      p.y += p.vy;
      
      if (p.x < 0) p.x = s.width;
      if (p.x > s.width) p.x = 0;
      if (p.y < 0) p.y = s.height;
      if (p.y > s.height) p.y = 0;
    }
  }

  void _drawBubbles(Canvas c, Size s) {
    final rng = Random();
    for (var p in particles) {
      p.y += p.vy;
      p.x += sin(p.phase) * 0.5;
      p.phase += p.wobble != 0 ? p.wobble : 0.01;
      
      if (p.y < -p.size * 2) {
        p.y = s.height + p.size;
        p.x = rng.nextDouble() * s.width;
      }
      
      final rect = Rect.fromCircle(center: Offset(p.x, p.y), radius: p.size);
      final gradient = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        radius: 1.0,
        colors: [
          Colors.white.withValues(alpha: 0.4),
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.05),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);

      final paint = Paint()
        ..shader = gradient
        ..style = PaintingStyle.fill;
      c.drawCircle(Offset(p.x, p.y), p.size, paint);

      final strokePaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      c.drawCircle(Offset(p.x, p.y), p.size, strokePaint);
    }
  }

  void _drawRipples(Canvas c, Size s) {
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final age = (t * theme.particleSpeed * 30 + i * 2.5) % 6;
      final radius = age * max(s.width, s.height) * 0.08;
      final alpha = max(0.0, 0.25 - age * 0.04);
      
      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      c.drawCircle(Offset(p.x, p.y), radius, paint);
    }
  }

  void _drawLeaves(Canvas c, Size s) {
    final rng = Random();
    for (var p in particles) {
      p.y += theme.particleSpeed * 0.8;
      p.x += sin(p.phase) * 1.2;
      p.phase += 0.02;
      
      if (p.y > s.height + 20) {
        p.y = -20;
        p.x = rng.nextDouble() * s.width;
      }
      
      c.save();
      c.translate(p.x, p.y);
      c.rotate(p.phase);
      final paint = Paint()
        ..color = color.withValues(alpha: (p.opacity * 0.7).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      c.drawOval(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 2), paint);
      c.restore();
    }
  }

  void _drawFireflies(Canvas c, Size s) {
    for (var p in particles) {
      p.phase += 0.04;
      p.x += sin(p.phase * 0.7) * 0.8;
      p.y += cos(p.phase * 0.5) * 0.6;
      
      if (p.x < 0) p.x = s.width;
      if (p.x > s.width) p.x = 0;
      if (p.y < 0) p.y = s.height;
      if (p.y > s.height) p.y = 0;
      
      final alpha = (0.4 + 0.6 * sin(p.phase).abs()).clamp(0.0, 1.0);
      final radius = p.size * 3;
      final rect = Rect.fromCircle(center: Offset(p.x, p.y), radius: radius);
      
      final gradient = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(rect);

      final paint = Paint()
        ..shader = gradient
        ..style = PaintingStyle.fill;
      c.drawCircle(Offset(p.x, p.y), radius, paint);
    }
  }

  void _drawPetals(Canvas c, Size s) {
    final rng = Random();
    for (var p in particles) {
      p.y += theme.particleSpeed * 0.6;
      p.x += sin(p.phase) * 0.8;
      p.phase += 0.015;
      
      if (p.y > s.height + 20) {
        p.y = -20;
        p.x = rng.nextDouble() * s.width;
      }
      
      c.save();
      c.translate(p.x, p.y);
      c.rotate(p.phase * 0.5);
      final paint = Paint()
        ..color = color.withValues(alpha: (p.opacity * 0.6).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;
      c.drawOval(Rect.fromCenter(center: Offset.zero, width: p.size * 1.2, height: p.size * 2.4), paint);
      c.restore();
    }
  }

  void _drawAurora(Canvas c, Size s) {
    if (auroraLines == null) return;
    for (var line in auroraLines!) {
      line.phase += line.speed;
      
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          HSLColor.fromAHSL(0.03, line.hue % 360, 0.8, 0.6).toColor(),
          HSLColor.fromAHSL(0.08, line.hue % 360, 0.8, 0.6).toColor(),
          HSLColor.fromAHSL(0.05, (line.hue + 40) % 360, 0.8, 0.7).toColor(),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, s.width, s.height));

      final path = Path();
      path.moveTo(0, line.y);
      for (double x = 0; x <= s.width; x += 4) {
        final y = line.y + sin(x * line.freq + line.phase) * line.amp;
        path.lineTo(x, y);
      }
      path.lineTo(s.width, s.height);
      path.lineTo(0, s.height);
      path.close();

      final paint = Paint()
        ..shader = gradient
        ..style = PaintingStyle.fill;
      c.drawPath(path, paint);
    }
    _drawStars(c, s);
  }

  @override
  bool shouldRepaint(_LivePainter o) => o.t != t;
}
