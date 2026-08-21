import 'dart:math' as math; 
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
enum BurstPhase { typing, traveling, expanding, popping, affirming } 
 
class BurstScreen extends StatefulWidget { 
  const BurstScreen({super.key}); 
 
  @override 
  State<BurstScreen> createState() => _BurstScreenState(); 
} 
 
class _BurstScreenState extends State<BurstScreen> with TickerProviderStateMixin { 
  final TextEditingController _thoughtCtrl = TextEditingController(); 
  BurstPhase _phase = BurstPhase.typing; 
  String _thought = ''; 
   
  late AnimationController _bubbleCtrl; 
  late AnimationController _popCtrl; 
 
  final List<String> _affirmations = [ 
    "That feeling no longer owns you. You released it. 🎈", 
    "You are not your thoughts — you are the one who notices them. ✨", 
    "Every exhale is a letting go. You did that. 🍃", 
    "Lighter now. ☁️", 
    "It is safe to let that go. 🕊️", 
  ]; 
  late String _currentAffirmation; 
 
  @override 
  void initState() { 
    super.initState(); 
    _currentAffirmation = _affirmations[0]; 
 
    _bubbleCtrl = AnimationController( 
      vsync: this, 
      duration: const Duration(milliseconds: 1200), 
    ); 
 
    _popCtrl = AnimationController( 
      vsync: this, 
      duration: const Duration(milliseconds: 500), 
    ); 
 
    _thoughtCtrl.addListener(() { 
      setState(() {}); 
    }); 
  } 
 
  @override 
  void dispose() { 
    _thoughtCtrl.dispose(); 
    _bubbleCtrl.dispose(); 
    _popCtrl.dispose(); 
    super.dispose(); 
  } 
 
  void _handleRelease() async { 
    if (_thoughtCtrl.text.trim().isEmpty) return; 
    setState(() { 
      _thought = _thoughtCtrl.text; 
      _phase = BurstPhase.traveling; 
    }); 
 
    // traveling -> expanding 
    await Future.delayed(const Duration(milliseconds: 600)); 
    if (!mounted) return; 
    setState(() { 
      _phase = BurstPhase.expanding; 
    }); 
    _bubbleCtrl.forward(); 
  } 
 
  void _handlePop() async { 
    setState(() { 
      _phase = BurstPhase.popping; 
    }); 
    _popCtrl.forward(from: 0.0); 
 
    await Future.delayed(const Duration(milliseconds: 500)); 
    if (!mounted) return; 
     
    final rng = math.Random(); 
    setState(() { 
      _currentAffirmation = _affirmations[rng.nextInt(_affirmations.length)]; 
      _phase = BurstPhase.affirming; 
      _thoughtCtrl.clear(); 
    }); 
  } 
 
  void _reset() { 
    setState(() { 
      _phase = BurstPhase.typing; 
      _thought = ''; 
    }); 
    _bubbleCtrl.reset(); 
    _popCtrl.reset(); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    // Bubble size logic 
    double bubbleSize = 0; 
    if (_phase == BurstPhase.typing) { 
      bubbleSize = math.min(80.0 + _thoughtCtrl.text.length * 1.2, 220.0); 
    } else if (_phase == BurstPhase.traveling) { 
      bubbleSize = math.min(80.0 + _thought.length * 1.2, 220.0); 
    } else if (_phase == BurstPhase.expanding) { 
      // animate to 280 
      final base = math.min(80.0 + _thought.length * 1.2, 220.0); 
      bubbleSize = base + (280.0 - base) * _bubbleCtrl.value; 
    } else if (_phase == BurstPhase.popping) { 
      bubbleSize = 280.0 + (50 * _popCtrl.value); 
    } 
 
    final companionWhisper = { 
      BurstPhase.typing: 'I\'m here. Let it out.', 
      BurstPhase.traveling: 'Watching it rise...', 
      BurstPhase.expanding: 'Whenever you\'re ready.', 
      BurstPhase.popping: '', 
      BurstPhase.affirming: 'That was brave.', 
    }[_phase]!; 
 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'burst', 
        child: SafeArea( 
          child: Column( 
            children: [ 
              // Back Button 
              Align( 
                alignment: Alignment.centerLeft, 
                child: Padding( 
                  padding: const EdgeInsets.only(left: 16, top: 12), 
                  child: IconButton( 
                    onPressed: () => context.pop(), 
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white), 
                  ), 
                ), 
              ), 
 
              Expanded( 
                child: SingleChildScrollView( 
                  padding: const EdgeInsets.symmetric(horizontal: 24), 
                  child: Column( 
                    children: [ 
                      // Panda Companion 
                      AnimatedBuilder( 
                        animation: Listenable.merge([_bubbleCtrl, _popCtrl]), 
                        builder: (context, _) { 
                          return Column( 
                            children: [ 
                              Container( 
                                width: 72, 
                                height: 72, 
                                decoration: BoxDecoration( 
                                  shape: BoxShape.circle, 
                                  color: const Color(0xFFa78bfa).withValues(alpha: 0.35), 
                                ), 
                                child: const Center( 
                                  child: Text('🐼', style: TextStyle(fontSize: 40)), 
                                ), 
                              ), 
                              const SizedBox(height: 12), 
                              Text( 
                                companionWhisper, 
                                style: GoogleFonts.inter( 
                                  fontSize: 12, 
                                  fontStyle: FontStyle.italic, 
                                  color: const Color(0xFFe9d5ff).withValues(alpha: 0.9), 
                                ), 
                              ), 
                            ], 
                          ); 
                        }, 
                      ), 
                      const SizedBox(height: 40), 
 
                      // Bubble Container 
                      if (_phase != BurstPhase.affirming) 
                        SizedBox( 
                          height: 300, 
                          child: Center( 
                            child: Stack( 
                              alignment: Alignment.center, 
                              children: [ 
                                // Bubble Graphic 
                                AnimatedBuilder( 
                                  animation: Listenable.merge([_bubbleCtrl, _popCtrl, _thoughtCtrl]), 
                                  builder: (context, child) { 
                                    final popScale = _phase == BurstPhase.popping ? (1.0 + 0.4 * _popCtrl.value) : 1.0; 
                                    final popOpacity = _phase == BurstPhase.popping ? (1.0 - _popCtrl.value).clamp(0.0, 1.0) : 1.0; 
 
                                    return Opacity( 
                                      opacity: popOpacity, 
                                      child: Transform.scale( 
                                        scale: popScale, 
                                        child: CustomPaint( 
                                          size: Size(bubbleSize, bubbleSize), 
                                          painter: _BubblePainter(), 
                                        ), 
                                      ), 
                                    ); 
                                  }, 
                                ), 
                                 
                                // Text inside Bubble 
                                if (_phase == BurstPhase.traveling || _phase == BurstPhase.expanding) 
                                  AnimatedBuilder( 
                                    animation: _bubbleCtrl, 
                                    builder: (context, child) { 
                                      final isExp = _phase == BurstPhase.expanding; 
                                      return Opacity( 
                                        opacity: isExp ? 0.7 : 1.0, 
                                        child: Transform.scale( 
                                          scale: isExp ? 0.55 : 0.78, 
                                          child: Transform.translate( 
                                            offset: Offset(0, isExp ? 0 : 8), 
                                            child: Container( 
                                              width: bubbleSize * 0.78, 
                                              alignment: Alignment.center, 
                                              child: Text( 
                                                _thought.length > 90 ? '${_thought.substring(0, 90)}...' : _thought, 
                                                textAlign: TextAlign.center, 
                                                style: GoogleFonts.inter( 
                                                  fontSize: 14, 
                                                  fontWeight: FontWeight.w500, 
                                                  color: Colors.white, 
                                                  height: 1.3, 
                                                ), 
                                              ), 
                                            ), 
                                          ), 
                                        ), 
                                      ); 
                                    }, 
                                  ), 
 
                                // Pop Particles 
                                if (_phase == BurstPhase.popping) 
                                  AnimatedBuilder( 
                                    animation: _popCtrl, 
                                    builder: (context, child) { 
                                      return CustomPaint( 
                                        size: Size(bubbleSize, bubbleSize), 
                                        painter: _PopParticlePainter(progress: _popCtrl.value), 
                                      ); 
                                    }, 
                                  ), 
                              ], 
                            ), 
                          ), 
                        ), 
 
                      // Affirmation Card 
                      if (_phase == BurstPhase.affirming) 
                        TweenAnimationBuilder<double>( 
                          tween: Tween(begin: 0.0, end: 1.0), 
                          duration: const Duration(milliseconds: 600), 
                          curve: Curves.easeOutBack, 
                          builder: (context, val, child) { 
                            return Opacity( 
                              opacity: val.clamp(0.0, 1.0), 
                              child: Transform.translate( 
                                offset: Offset(0, 20 * (1 - val)), 
                                child: Container( 
                                  padding: const EdgeInsets.all(24), 
                                  margin: const EdgeInsets.only(top: 40), 
                                  decoration: BoxDecoration( 
                                    color: ZenTokens.surface, 
                                    border: Border.all(color: ZenTokens.border), 
                                    borderRadius: BorderRadius.circular(24), 
                                  ), 
                                  child: Column( 
                                    children: [ 
                                      Text( 
                                        _currentAffirmation, 
                                        textAlign: TextAlign.center, 
                                        style: GoogleFonts.lora( 
                                          fontSize: 20, 
                                          height: 1.4, 
                                          color: Colors.white, 
                                        ), 
                                      ), 
                                      const SizedBox(height: 32), 
                                      ElevatedButton( 
                                        onPressed: _reset, 
                                        style: ElevatedButton.styleFrom( 
                                          backgroundColor: ZenTokens.primary.withValues(alpha: 0.15), 
                                          foregroundColor: Colors.white, 
                                          elevation: 0, 
                                          shape: RoundedRectangleBorder( 
                                            borderRadius: BorderRadius.circular(24), 
                                            side: BorderSide(color: ZenTokens.primary.withValues(alpha: 0.3)), 
                                          ), 
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), 
                                        ), 
                                        child: Text('Release another thought', style: GoogleFonts.inter(fontSize: 14)), 
                                      ), 
                                    ], 
                                  ), 
                                ), 
                              ), 
                            ); 
                          }, 
                        ), 
 
                      // Actions 
                      if (_phase == BurstPhase.expanding) 
                        TweenAnimationBuilder<double>( 
                          tween: Tween(begin: 0.0, end: 1.0), 
                          duration: const Duration(milliseconds: 350), 
                          builder: (context, val, child) { 
                            return Opacity( 
                              opacity: val, 
                              child: Transform.translate( 
                                offset: Offset(0, 8 * (1 - val)), 
                                child: ElevatedButton( 
                                  onPressed: _handlePop, 
                                  style: ElevatedButton.styleFrom( 
                                    backgroundColor: ZenTokens.primary, 
                                    foregroundColor: Colors.white, 
                                    shape: RoundedRectangleBorder( 
                                      borderRadius: BorderRadius.circular(30), 
                                    ), 
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), 
                                  ), 
                                  child: Text('Pop it', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)), 
                                ), 
                              ), 
                            ); 
                          }, 
                        ), 
 
                      // Composer 
                      if (_phase == BurstPhase.typing) 
                        Container( 
                          margin: const EdgeInsets.only(top: 40), 
                          padding: const EdgeInsets.all(16), 
                          decoration: BoxDecoration( 
                            color: const Color(0xFF281C3D).withValues(alpha: 0.78), // hsl(268_42%_14%/0.78) 
                            borderRadius: BorderRadius.circular(22), 
                            border: Border.all(color: const Color(0xFFd8b4fe).withValues(alpha: 0.25)), // violet-300 
                            boxShadow: [ 
                              BoxShadow( 
                                color: const Color(0xFF280a50).withValues(alpha: 0.75), 
                                blurRadius: 48, 
                                offset: const Offset(0, 18), 
                                spreadRadius: -22, 
                              ) 
                            ], 
                          ), 
                          child: Column( 
                            children: [ 
                              TextField( 
                                controller: _thoughtCtrl, 
                                maxLines: 4, 
                                maxLength: 300, 
                                style: GoogleFonts.inter( 
                                  fontSize: 16, 
                                  color: Colors.white, 
                                  height: 1.5, 
                                ), 
                                decoration: InputDecoration( 
                                  hintText: "What's weighing on you? Pour it out...", 
                                  hintStyle: GoogleFonts.inter( 
                                    color: const Color(0xFFe0e7ff).withValues(alpha: 0.75), // violet-100 
                                  ), 
                                  border: InputBorder.none, 
                                  counterText: '', // hidden default counter 
                                ), 
                              ), 
                              Row( 
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                children: [ 
                                  AnimatedBuilder( 
                                    animation: _thoughtCtrl, 
                                    builder: (context, _) => Text( 
                                      '${_thoughtCtrl.text.length}/300', 
                                      style: GoogleFonts.inter( 
                                        fontSize: 12, 
                                        fontWeight: FontWeight.w500, 
                                        color: const Color(0xFFe0e7ff).withValues(alpha: 0.85), 
                                      ), 
                                    ), 
                                  ), 
                                  AnimatedBuilder( 
                                    animation: _thoughtCtrl, 
                                    builder: (context, _) { 
                                      final canRelease = _thoughtCtrl.text.trim().isNotEmpty; 
                                      return ElevatedButton( 
                                        onPressed: canRelease ? _handleRelease : null, 
                                        style: ElevatedButton.styleFrom( 
                                          backgroundColor: ZenTokens.primary, 
                                          disabledBackgroundColor: ZenTokens.primary.withValues(alpha: 0.5), 
                                          foregroundColor: Colors.white, 
                                          shape: RoundedRectangleBorder( 
                                            borderRadius: BorderRadius.circular(24), 
                                          ), 
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), 
                                          elevation: canRelease ? 4 : 0, 
                                          shadowColor: Colors.blueAccent.withValues(alpha: 0.65), 
                                        ), 
                                        child: Text( 
                                          'Release it', 
                                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600), 
                                        ), 
                                      ); 
                                    }, 
                                  ), 
                                ], 
                              ), 
                            ], 
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
 
class _BubblePainter extends CustomPainter { 
  @override 
  void paint(Canvas canvas, Size size) { 
    final rect = Offset.zero & size; 
    final center = rect.center; 
    final radius = size.width / 2; 
 
    final paint = Paint() 
      ..shader = RadialGradient( 
        center: const Alignment(-0.3, -0.4), 
        colors: [ 
          Colors.white.withValues(alpha: 0.92), 
          HSLColor.fromAHSL(0.42, 262, 0.48, 0.72).toColor(), 
          HSLColor.fromAHSL(0.28, 262, 0.55, 0.48).toColor(), 
        ], 
        stops: const [0.0, 0.42, 1.0], 
      ).createShader(rect); 
 
    canvas.drawCircle(center, radius, paint); 
 
    // Shine highlight 
    final shinePaint = Paint() 
      ..color = Colors.white.withValues(alpha: 0.5) 
      ..style = PaintingStyle.fill; 
     
    canvas.save(); 
    canvas.translate(size.width * 0.35, size.height * 0.3); 
    canvas.rotate(-30 * math.pi / 180); 
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: radius * 0.4, height: radius * 0.2), shinePaint); 
    canvas.restore(); 
 
    // Border 
    final strokePaint = Paint() 
      ..color = ZenTokens.secondary.withValues(alpha: 0.45) 
      ..style = PaintingStyle.stroke 
      ..strokeWidth = 2.0; 
    canvas.drawCircle(center, radius, strokePaint); 
  } 
 
  @override 
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; 
} 
 
class _PopParticlePainter extends CustomPainter { 
  final double progress; // 0.0 to 1.0 
  _PopParticlePainter({required this.progress}); 
 
  @override 
  void paint(Canvas canvas, Size size) { 
    if (progress <= 0 || progress >= 1) return; 
     
    final center = size.center(Offset.zero); 
    final bubbleR = size.width / 2; 
 
    final paint = Paint()..style = PaintingStyle.fill; 
     
    for (int i = 0; i < 20; i++) { 
      final angle = (i / 20) * math.pi * 2; 
      final startR = bubbleR; 
      final endR = startR + 36 + ((i * 17) % 50); 
      final r = 3.0 + (i % 5); 
      final dur = 0.28 + (i % 5) * 0.04; 
       
      // Local progress for this particle 
      final p = (progress / dur).clamp(0.0, 1.0); 
      if (p == 0) continue; 
       
      final currentR = startR + (endR - startR) * Curves.easeOut.transform(p); 
      final currentYOffset = (24 + ((i * 13) % 40)) * Curves.easeOut.transform(p); 
       
      final cx = center.dx + math.cos(angle) * currentR; 
      final cy = center.dy + math.sin(angle) * currentR + currentYOffset; 
       
      paint.color = const Color(0xFFd8b4fe).withValues(alpha: 1.0 - p); // violet-300 fading 
      canvas.drawCircle(Offset(cx, cy), r * (1 - p), paint); 
    } 
  } 
 
  @override 
  bool shouldRepaint(covariant _PopParticlePainter oldDelegate) { 
    return oldDelegate.progress != progress; 
  } 
}
