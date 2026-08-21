import 'dart:math'; 
import 'package:flutter/material.dart'; 
import '../../core/theme/module_themes.dart'; 
 
/// Flutter equivalent of the web app's `ModulePage` + `LiveBackground` components. 
/// Wraps every module screen with its themed gradient and live particle animation. 
class ModuleBackground extends StatefulWidget { 
  final String moduleKey; 
  final Widget child; 
 
  const ModuleBackground({ 
    super.key, 
    required this.moduleKey, 
    required this.child, 
  }); 
 
  @override 
  State<ModuleBackground> createState() => _ModuleBackgroundState(); 
} 
 
class _ModuleBackgroundState extends State<ModuleBackground> 
    with TickerProviderStateMixin { 
  late ModuleTheme _theme; 
  late AnimationController _controller; 
  late List<_Particle> _particles; 
 
  @override 
  void initState() { 
    super.initState(); 
    _theme = ModuleThemes.getTheme(widget.moduleKey); 
    _initParticles(); 
    _controller = AnimationController( 
      vsync: this, 
      duration: const Duration(seconds: 1), 
    )..repeat(); 
  } 
 
  void _initParticles() { 
    final rng = Random(); 
    _particles = List.generate(_theme.particleCount, (i) => _Particle( 
      x: rng.nextDouble(), 
      y: rng.nextDouble(), 
      size: 1.0 + rng.nextDouble() * 2.5, 
      speed: 0.05 + rng.nextDouble() * 0.15, 
      phase: rng.nextDouble() * pi * 2, 
      wobble: (rng.nextDouble() - 0.5) * 0.3, 
    )); 
  } 
 
  @override 
  void dispose() { 
    _controller.dispose(); 
    super.dispose(); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      decoration: BoxDecoration(gradient: _theme.gradient), 
      child: Stack( 
        children: [ 
          // Live particle layer — mirrors web app's LiveBackground canvas 
          if (_theme.liveEffect != LiveEffect.none) 
            Positioned.fill( 
              child: AnimatedBuilder( 
                animation: _controller, 
                builder: (context, child) => CustomPaint( 
                  painter: _ParticlePainter( 
                    particles: _particles, 
                    effect: _theme.liveEffect, 
                    color: _theme.particleColor, 
                    time: _controller.value * 2 * pi, 
                  ), 
                ), 
              ), 
            ), 
          // Module content on top 
          widget.child, 
        ], 
      ), 
    ); 
  } 
} 
 
class _Particle { 
  double x, y, size, speed, phase, wobble; 
  _Particle({ 
    required this.x, required this.y, 
    required this.size, required this.speed, 
    required this.phase, required this.wobble, 
  }); 
} 
 
class _ParticlePainter extends CustomPainter { 
  final List<_Particle> particles; 
  final LiveEffect effect; 
  final Color color; 
  final double time; 
 
  _ParticlePainter({ 
    required this.particles, 
    required this.effect, 
    required this.color, 
    required this.time, 
  }); 
 
  @override 
  void paint(Canvas canvas, Size size) { 
    switch (effect) { 
      case LiveEffect.stars: 
        _drawStars(canvas, size); 
      case LiveEffect.bubbles: 
        _drawBubbles(canvas, size); 
      case LiveEffect.ripples: 
        _drawRipples(canvas, size); 
      case LiveEffect.leaves: 
        _drawLeaves(canvas, size); 
      case LiveEffect.fireflies: 
        _drawFireflies(canvas, size); 
      case LiveEffect.petals: 
        _drawPetals(canvas, size); 
      case LiveEffect.aurora: 
        _drawAurora(canvas, size); 
      case LiveEffect.none: 
        break; 
    } 
  } 
 
  void _drawStars(Canvas canvas, Size s) { 
    for (final p in particles) { 
      final alpha = (0.3 + 0.7 * sin(time + p.phase)).clamp(0.0, 1.0); 
      final paint = Paint() 
        ..color = color.withValues(alpha: alpha * 0.7) 
        ..style = PaintingStyle.fill; 
      canvas.drawCircle(Offset(p.x * s.width, p.y * s.height), p.size, paint); 
    } 
  } 
 
  void _drawBubbles(Canvas canvas, Size s) { 
    for (final p in particles) { 
      // Bubbles float upward 
      final yPos = ((p.y - time * p.speed * 0.3) % 1.0 + 1.0) % 1.0; 
      final xPos = p.x + sin(time * 0.5 + p.phase) * 0.03; 
      final cx = xPos * s.width; 
      final cy = yPos * s.height; 
      final r  = p.size * 8; 
 
      final paint = Paint() 
        ..color = color.withValues(alpha: 0.12) 
        ..style = PaintingStyle.fill; 
      canvas.drawCircle(Offset(cx, cy), r, paint); 
 
      final border = Paint() 
        ..color = color.withValues(alpha: 0.3) 
        ..style = PaintingStyle.stroke 
        ..strokeWidth = 0.8; 
      canvas.drawCircle(Offset(cx, cy), r, border); 
 
      // Shine 
      final shine = Paint()..color = Colors.white.withValues(alpha: 0.25); 
      canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.3), r * 0.2, shine); 
    } 
  } 
 
  void _drawRipples(Canvas canvas, Size s) { 
    for (int i = 0; i < particles.length; i++) { 
      final p = particles[i]; 
      final age = (time * 0.3 + i * 0.4) % 5.0; 
      final radius = age * s.width * 0.06; 
      final alpha  = (0.25 - age * 0.05).clamp(0.0, 0.25); 
      final paint  = Paint() 
        ..color = color.withValues(alpha: alpha) 
        ..style = PaintingStyle.stroke 
        ..strokeWidth = 1.2; 
      canvas.drawCircle(Offset(p.x * s.width, p.y * s.height), radius, paint); 
    } 
  } 
 
  void _drawLeaves(Canvas canvas, Size s) { 
    for (final p in particles) { 
      final yPos = ((p.y + time * p.speed * 0.2) % 1.0); 
      final xPos = p.x + sin(time * 0.8 + p.phase) * 0.04; 
      canvas.save(); 
      canvas.translate(xPos * s.width, yPos * s.height); 
      canvas.rotate(time * 0.5 + p.phase); 
      final paint = Paint() 
        ..color = color.withValues(alpha: 0.5) 
        ..style = PaintingStyle.fill; 
      canvas.drawOval( 
        Rect.fromCenter(center: Offset.zero, width: p.size * 3, height: p.size * 6), 
        paint, 
      ); 
      canvas.restore(); 
    } 
  } 
 
  void _drawFireflies(Canvas canvas, Size s) { 
    for (final p in particles) { 
      final alpha = (0.4 + 0.6 * sin(time * 2 + p.phase).abs()).clamp(0.0, 1.0); 
      final cx = (p.x + sin(time * 0.7 + p.phase) * 0.04) * s.width; 
      final cy = (p.y + cos(time * 0.5 + p.phase) * 0.03) * s.height; 
      // Glow 
      final glow = Paint() 
        ..color = color.withValues(alpha: alpha * 0.15) 
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8); 
      canvas.drawCircle(Offset(cx, cy), p.size * 4, glow); 
      // Core 
      final core = Paint()..color = color.withValues(alpha: alpha); 
      canvas.drawCircle(Offset(cx, cy), p.size, core); 
    } 
  } 
 
  void _drawPetals(Canvas canvas, Size s) { 
    for (final p in particles) { 
      final yPos = ((p.y + time * p.speed * 0.15) % 1.0); 
      final xPos = p.x + sin(time * 0.6 + p.phase) * 0.03; 
      canvas.save(); 
      canvas.translate(xPos * s.width, yPos * s.height); 
      canvas.rotate(time * 0.3 + p.phase); 
      final paint = Paint() 
        ..color = color.withValues(alpha: 0.5) 
        ..style = PaintingStyle.fill; 
      canvas.drawOval( 
        Rect.fromCenter(center: Offset.zero, width: p.size * 4, height: p.size * 7), 
        paint, 
      ); 
      canvas.restore(); 
    } 
  } 
 
  void _drawAurora(Canvas canvas, Size s) { 
    // Soft horizontal aurora bands 
    final hues = [260.0, 290.0, 200.0, 320.0]; 
    for (int i = 0; i < hues.length; i++) { 
      final y = s.height * (0.15 + i * 0.15) + sin(time * 0.4 + i) * 30; 
      final paint = Paint() 
        ..shader = LinearGradient( 
          begin: Alignment.centerLeft, 
          end: Alignment.centerRight, 
          colors: [ 
            Colors.transparent, 
            HSLColor.fromAHSL(0.06, hues[i], 0.8, 0.6).toColor(), 
            HSLColor.fromAHSL(0.1, hues[i] + 20, 0.8, 0.7).toColor(), 
            Colors.transparent, 
          ], 
        ).createShader(Rect.fromLTWH(0, y - 40, s.width, 80)); 
      canvas.drawRect(Rect.fromLTWH(0, y - 40, s.width, 80), paint); 
    } 
    // Stars on top of aurora 
    _drawStars(canvas, s); 
  } 
 
  @override 
  bool shouldRepaint(_ParticlePainter old) => old.time != time; 
}
