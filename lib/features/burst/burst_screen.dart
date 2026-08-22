import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';

enum BurstPhase { typing, traveling, expanding, popping, affirming }

const List<String> _affirmations = [
  'That feeling no longer owns you. You released it.',
  'You are not your thoughts. You are the one who notices them.',
  'Every exhale is a letting go. You did that.',
  'Lighter now. That burden was never yours to keep forever.',
  'You faced it, you felt it, you freed it. That is courage.',
  'Releasing is not weakness — it is wisdom. Well done.',
  'The thought is gone. You remain. Strong, whole, enough.',
  'You just made space for something better.',
];

class _PopParticle {
  final double angle;
  final double speed;
  final double size;
  final Color color;

  _PopParticle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
  });
}

class BurstScreen extends StatefulWidget {
  const BurstScreen({super.key});

  @override
  State<BurstScreen> createState() => _BurstScreenState();
}

class _BurstScreenState extends State<BurstScreen> with TickerProviderStateMixin {
  final TextEditingController _thoughtController = TextEditingController();
  BurstPhase _phase = BurstPhase.typing;
  String _affirmation = '';
  DateTime? _startTime;

  late AnimationController _bubbleController;
  late Animation<double> _bubbleSizeAnim;
  late Animation<double> _bubbleYAnim;

  late AnimationController _popController;
  final List<_PopParticle> _particles = [];

  double _baseSize = 96;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    _bubbleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 850));
    _popController = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));

    _bubbleController.addListener(() => setState(() {}));
    _popController.addListener(() => setState(() {}));

    _thoughtController.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().trackEngagement('burst_it_out', 'opened');
    });
  }

  @override
  void dispose() {
    _thoughtController.dispose();
    _bubbleController.dispose();
    _popController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_phase != BurstPhase.typing) return;
    final chars = _thoughtController.text.length;
    // bubbleSize = clamp(80 + text.length * 1.2, min: 80, max: 220)
    setState(() {
      _baseSize = (80 + chars * 1.2).clamp(80.0, 220.0);
    });
  }

  Future<void> _handleRelease() async {
    if (_thoughtController.text.trim().isEmpty || _phase != BurstPhase.typing) return;

    _affirmation = _affirmations[_random.nextInt(_affirmations.length)];
    setState(() => _phase = BurstPhase.traveling);

    // traveling (850ms)
    _bubbleSizeAnim = Tween<double>(begin: _baseSize, end: _baseSize).animate(_bubbleController);
    _bubbleYAnim = Tween<double>(begin: 0, end: -100).animate(CurvedAnimation(parent: _bubbleController, curve: Curves.easeOut));
    await _bubbleController.forward(from: 0);

    // expanding (1100ms)
    setState(() => _phase = BurstPhase.expanding);
    _bubbleController.duration = const Duration(milliseconds: 1100);
    _bubbleSizeAnim = Tween<double>(begin: _baseSize, end: 280).animate(CurvedAnimation(parent: _bubbleController, curve: Curves.easeInOutBack));
    await _bubbleController.forward(from: 0);
  }

  Future<void> _handlePop() async {
    if (_phase != BurstPhase.expanding) return;
    
    _generateParticles();
    setState(() => _phase = BurstPhase.popping);
    
    await _popController.forward(from: 0);

    setState(() => _phase = BurstPhase.affirming);
    final elapsed = DateTime.now().difference(_startTime!).inSeconds;
    if (mounted) {
      context.read<AuthService>().trackEngagement('burst_it_out', 'completed', durationSec: elapsed);
    }
  }

  void _generateParticles() {
    _particles.clear();
    final colors = [
      const Color(0xFFC4B5FD), // violet-200
      const Color(0xFFE9D5FF), // purple-200
      const Color(0xFFDDD6FE), // violet-300
      Colors.white,
    ];
    for (int i = 0; i < 40; i++) {
      _particles.add(_PopParticle(
        angle: _random.nextDouble() * 2 * math.pi,
        speed: 50 + _random.nextDouble() * 150,
        size: 3 + _random.nextDouble() * 5,
        color: colors[_random.nextInt(colors.length)],
      ));
    }
  }

  void _handleReset() {
    setState(() {
      _phase = BurstPhase.typing;
      _thoughtController.clear();
      _baseSize = 80;
      _affirmation = '';
      _startTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1035),
      body: ModuleBackground(
        moduleKey: 'burst',
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      'LET IT GO',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                        color: const Color(0xFFDDD6FE).withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Burst it out',
                      style: GoogleFonts.lora(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Write what is heavy. Watch it rise. Pop the bubble and leave it behind.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFFEDE9FE).withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_phase == BurstPhase.typing || _phase == BurstPhase.traveling || _phase == BurstPhase.expanding)
                      Transform.translate(
                        offset: Offset(0, _phase == BurstPhase.typing ? 0 : _bubbleYAnim.value),
                        child: Container(
                          width: _phase == BurstPhase.typing ? _baseSize : _bubbleSizeAnim.value,
                          height: _phase == BurstPhase.typing ? _baseSize : _bubbleSizeAnim.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFC4B5FD).withValues(alpha: 0.3),
                                const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFFC4B5FD).withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                                blurRadius: 40,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: _phase == BurstPhase.typing || _phase == BurstPhase.traveling
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    _thoughtController.text,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    if (_phase == BurstPhase.popping)
                      CustomPaint(
                        size: const Size(300, 300),
                        painter: _PopPainter(
                          particles: _particles,
                          progress: _popController.value,
                          centerOffset: const Offset(0, -100),
                        ),
                      ),
                    if (_phase == BurstPhase.affirming)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _affirmation,
                              style: GoogleFonts.lora(
                                fontSize: 24,
                                color: Colors.white,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            OutlinedButton(
                              onPressed: _handleReset,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text('Release another thought', style: GoogleFonts.inter()),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (_phase == BurstPhase.traveling)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    'Sending your thought into the bubble...',
                    style: GoogleFonts.inter(fontSize: 14, fontStyle: FontStyle.italic, color: const Color(0xFFDDD6FE).withValues(alpha: 0.85)),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_phase == BurstPhase.expanding)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, left: 40, right: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'The bubble is full. Pop it when you\'re ready.',
                        style: GoogleFonts.inter(fontSize: 14, fontStyle: FontStyle.italic, color: const Color(0xFFDDD6FE).withValues(alpha: 0.85)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _handlePop,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E1035),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          minimumSize: const Size(140, 50),
                        ),
                        child: Text('Pop it', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              if (_phase == BurstPhase.typing)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(ZenTokens.radiusZen2xl),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _thoughtController,
                          maxLines: 4,
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'What is bothering you?',
                            hintStyle: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.4)),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _thoughtController.text.trim().isNotEmpty ? _handleRelease : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl)),
                            ),
                            child: Text('Release', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopPainter extends CustomPainter {
  final List<_PopParticle> particles;
  final double progress; // 0 to 1
  final Offset centerOffset;

  _PopPainter({required this.particles, required this.progress, required this.centerOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2) + centerOffset;
    
    // Scale out, then fade out
    final scale = 1.0 + (progress * 2.0);
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    
    for (final p in particles) {
      final dx = math.cos(p.angle) * p.speed * scale;
      final dy = math.sin(p.angle) * p.speed * scale;
      final pos = center + Offset(dx, dy);
      
      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
        
      canvas.drawCircle(pos, p.size * (1 - progress * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PopPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
