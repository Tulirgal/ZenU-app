import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';

class GratitudeScreen extends StatefulWidget {
  const GratitudeScreen({super.key});

  @override
  State<GratitudeScreen> createState() => _GratitudeScreenState();
}

class _GratitudeScreenState extends State<GratitudeScreen> with TickerProviderStateMixin {
  late AnimationController _jarPhaseController;
  late AnimationController _pandaAnimationController;

  String _jarPhase = 'idle'; // idle, absorb, resonate
  String _pandaPhase = 'idle'; // idle, reach, offer
  
  bool _isPicking = false;
  String? _revealedMemory;

  int _entryCount = 3; // Mock entry count

  @override
  void initState() {
    super.initState();
    _jarPhaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _pandaAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().trackEngagement('journal_gratitude', 'opened');
      // In real implementation: GET /api/gratitude to load entries
    });
  }

  @override
  void dispose() {
    _jarPhaseController.dispose();
    _pandaAnimationController.dispose();
    super.dispose();
  }

  void _triggerJarPhase(String phase) {
    setState(() => _jarPhase = phase);
    _jarPhaseController.forward(from: 0).then((_) {
      if (phase != 'resonate') {
        setState(() => _jarPhase = 'idle');
      }
    });
  }

  void _pickMemory() async {
    setState(() {
      _isPicking = true;
      _revealedMemory = null;
      _pandaPhase = 'reach';
      _jarPhase = 'resonate';
    });
    _pandaAnimationController.forward(from: 0);
    _jarPhaseController.repeat(reverse: true);

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isPicking = false;
      _jarPhase = 'idle';
      _pandaPhase = 'offer';
      _revealedMemory = "I am grateful for a warm cup of coffee this morning.";
    });
    
    _jarPhaseController.stop();
    _jarPhaseController.value = 0;
    _pandaAnimationController.reverse();

    if (mounted) {
      context.read<AuthService>().trackEngagement('journal_gratitude', 'completed');
    }
  }

  void _addJournal() async {
    _triggerJarPhase('absorb');
    setState(() {
      _entryCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'gratitude',
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPandaCompanion(),
                        const SizedBox(width: 40),
                        _buildJar(),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ZenTokens.zenFg),
                onPressed: () => context.pop(),
              ),
              Text(
                'Gratitude',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ZenTokens.zenFg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your desk of tiny thankful moments',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: ZenTokens.zenFg,
                    letterSpacing: -0.02 * 28,
                    height: 1.16,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _addJournal,
                        style: FilledButton.styleFrom(
                          backgroundColor: ZenTokens.zenPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl)),
                        ),
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: Text('Add New Journal', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isPicking ? null : _pickMemory,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ZenTokens.zenFg,
                          backgroundColor: ZenTokens.zenSurface,
                          side: const BorderSide(color: ZenTokens.zenBorderSoft),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl)),
                        ),
                        icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                        label: Text('Pick Random Paper', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPandaCompanion() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      transform: Matrix4.translationValues(
        _pandaPhase == 'reach' ? 56.0 : (_pandaPhase == 'offer' ? -10.0 : 0.0),
        _pandaPhase == 'reach' ? -28.0 : (_pandaPhase == 'offer' ? -8.0 : 0.0),
        0.0,
      )..multiply(Matrix4.diagonal3Values(
        _pandaPhase == 'reach' ? 1.06 : (_pandaPhase == 'offer' ? 1.03 : 1.0),
        _pandaPhase == 'reach' ? 1.06 : (_pandaPhase == 'offer' ? 1.03 : 1.0),
        1.0,
      )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_revealedMemory != null)
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(20),
              width: 240,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF08A), // Light yellow paper
                borderRadius: BorderRadius.circular(ZenTokens.radiusZenLg),
                border: Border.all(color: const Color(0xFFEAB308).withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _revealedMemory!,
                    style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF713F12), height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _revealedMemory = null),
                    child: Text('Put it back', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFA16207))),
                  ),
                ],
              ),
            ),
          SizedBox(
            width: 140,
            height: 140,
            child: CustomPaint(
              painter: _PandaPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJar() {
    return AnimatedBuilder(
      animation: _jarPhaseController,
      builder: (context, child) {
        double scale = 1.0;
        double lidY = 0.0;
        double lidRotate = 0.0;
        
        if (_jarPhase == 'absorb') {
          scale = 1.0 + math.sin(_jarPhaseController.value * math.pi) * 0.07;
          lidY = -18.0 * math.sin(_jarPhaseController.value * math.pi);
          lidRotate = -12.0 * math.sin(_jarPhaseController.value * math.pi);
        } else if (_jarPhase == 'resonate') {
          scale = 1.0 + math.sin(_jarPhaseController.value * math.pi) * 0.03;
          lidY = -18.0;
          lidRotate = -12.0;
        }

        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: 180,
            height: 220,
            child: CustomPaint(
              painter: _JarPainter(
                entryCount: _entryCount,
                lidY: lidY,
                lidRotate: lidRotate,
                isBusy: _jarPhase != 'idle',
                animationValue: _jarPhaseController.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PandaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Ears
    paint.color = const Color(0xFF1F2937);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.3), size.width * 0.15, paint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.3), size.width * 0.15, paint);
    
    // Head/Body
    paint.color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.6), size.width * 0.4, paint);
    
    // Eyes outer
    paint.color = const Color(0xFF1F2937);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.35, size.height * 0.55), width: size.width * 0.2, height: size.height * 0.25),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(size.width * 0.65, size.height * 0.55), width: size.width * 0.2, height: size.height * 0.25),
      paint,
    );
    
    // Eyes inner
    paint.color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.37, size.height * 0.52), size.width * 0.04, paint);
    canvas.drawCircle(Offset(size.width * 0.63, size.height * 0.52), size.width * 0.04, paint);
    
    // Nose
    paint.color = const Color(0xFF1F2937);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.7), size.width * 0.05, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _JarPainter extends CustomPainter {
  final int entryCount;
  final double lidY;
  final double lidRotate;
  final bool isBusy;
  final double animationValue;

  _JarPainter({
    required this.entryCount,
    required this.lidY,
    required this.lidRotate,
    required this.isBusy,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Map the 220x280 SVG coordinates to the provided size
    final scaleX = size.width / 220.0;
    final scaleY = size.height / 280.0;
    
    canvas.save();
    canvas.scale(scaleX, scaleY);

    final paint = Paint()..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFFEAB308)
      ..strokeWidth = 4;

    // Glow
    final glowOpacity = isBusy ? 0.6 : 0.22;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFDBA74).withValues(alpha: 0.45 * glowOpacity),
          const Color(0xFFFFEDD5).withValues(alpha: 0.2 * glowOpacity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 0.7],
      ).createShader(const Rect.fromLTWH(0, 0, 220, 280));
    canvas.drawRect(const Rect.fromLTWH(0, 0, 220, 280), glowPaint);

    // Jar Neck
    paint.color = const Color(0xFFFDE047);
    canvas.drawRect(const Rect.fromLTWH(50, 70, 120, 15), paint);

    // Jar Body
    final path = Path()
      ..moveTo(50, 85)
      ..lineTo(170, 85)
      ..lineTo(170, 210)
      ..quadraticBezierTo(170, 240, 140, 240)
      ..lineTo(80, 240)
      ..quadraticBezierTo(50, 240, 50, 210)
      ..close();
    
    paint.color = const Color(0xFFFEF08A);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);

    // Glass Highlight
    paint.color = Colors.white.withValues(alpha: 0.6);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(60, 100, 8, 90), const Radius.circular(4)), paint);

    // Inside Jar (Paper Rolls)
    canvas.save();
    canvas.clipPath(path);
    final paperCount = math.min(12, entryCount);
    for (int i = 0; i < paperCount; i++) {
      final x = 70.0 + (i % 4) * 18 + (i % 2) * 4;
      final y = 230.0 - (i ~/ 4) * 22 - (i % 3) * 6;
      double rot = ((i * 17) % 40) - 20.0;
      double dy = 0;
      
      if (isBusy) {
        dy = math.sin(animationValue * math.pi * 4 + i) * -4.0;
        rot += math.sin(animationValue * math.pi * 4 + i) * 3.0;
      }
      
      canvas.save();
      canvas.translate(x + 11, y + 7 + dy);
      canvas.rotate(rot * math.pi / 180);
      canvas.translate(-(x + 11), -(y + 7 + dy));
      
      final hueColor = HSLColor.fromAHSL(1.0, 28.0 + (i % 5) * 8.0, 0.55, (88.0 - (i % 3) * 4.0) / 100.0).toColor();
      final strokeHue = HSLColor.fromAHSL(0.4, 28.0 + (i % 5) * 8.0, 0.35, 0.70).toColor();
      
      final paperPaint = Paint()..color = hueColor;
      final paperStroke = Paint()..color = strokeHue..style = PaintingStyle.stroke..strokeWidth = 0.8;
      
      final paperRect = RRect.fromRectAndRadius(Rect.fromLTWH(x, y + dy, 22, 14), const Radius.circular(2));
      canvas.drawRRect(paperRect, paperPaint);
      canvas.drawRRect(paperRect, paperStroke);
      canvas.restore();
    }
    canvas.restore();

    // Lid Container
    canvas.save();
    canvas.translate(110, 62);
    canvas.translate(0, lidY);
    canvas.rotate(lidRotate * math.pi / 180);
    canvas.translate(-110, -62);

    // Knob
    paint.color = const Color(0xFFA855F7);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(85, 20, 50, 20), const Radius.circular(8)), paint);
    
    // Main Lid
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(40, 35, 140, 35), const Radius.circular(8)), paint);
    
    // Lid Highlight
    paint.color = const Color(0xFFD8B4FE).withValues(alpha: 0.5);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(50, 42, 30, 6), const Radius.circular(3)), paint);
    
    // Heart
    final heartPath = Path()
      ..moveTo(110, 62)
      ..cubicTo(100, 54, 100, 48, 110, 47)
      ..cubicTo(120, 48, 120, 54, 110, 62)
      ..close();
    paint.color = const Color(0xFFEF4444);
    canvas.drawPath(heartPath, paint);

    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _JarPainter oldDelegate) {
    return oldDelegate.entryCount != entryCount ||
           oldDelegate.lidY != lidY ||
           oldDelegate.lidRotate != lidRotate ||
           oldDelegate.isBusy != isBusy ||
           oldDelegate.animationValue != animationValue;
  }
}
