
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class GratitudeScreen extends StatefulWidget { 
  const GratitudeScreen({super.key}); 
 
  @override 
  State<GratitudeScreen> createState() => _GratitudeScreenState(); 
} 
 
class _GratitudeScreenState extends State<GratitudeScreen> with TickerProviderStateMixin { 
  late AnimationController _animCtrl; 
  String _phaseLabel = ''; 
  String? _revealedMemory; 
 
  // Tweens for animation sequence 
  late Animation<double> _pandaXTween; 
  late Animation<double> _pandaYTween; 
  late Animation<double> _lidYTween; 
  late Animation<double> _lidRotTween; 
  late Animation<double> _noteYTween; 
  late Animation<double> _noteOpacityTween; 
 
  @override 
  void initState() { 
    super.initState(); 
    _animCtrl = AnimationController( 
      vsync: this, 
      duration: const Duration(milliseconds: 6000), 
    ); 
 
    // Animation sequence: 
    // 0.0 - 0.15: walk to jar 
    // 0.15 - 0.25: open lid 
    // 0.25 - 0.35: reach in 
    // 0.35 - 0.50: present note 
    // (hold) 
    // 0.70 - 0.80: put back 
    // 0.80 - 0.90: close 
    // 0.90 - 1.00: walk back 
 
    _pandaXTween = TweenSequence<double>([ 
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 120.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 15), // walk to jar 
      TweenSequenceItem(tween: ConstantTween(120.0), weight: 75), // stay 
      TweenSequenceItem(tween: Tween(begin: 120.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 10), // walk back 
    ]).animate(_animCtrl); 
 
    _pandaYTween = TweenSequence<double>([ 
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 25), // walk & open lid 
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 20.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 10), // reach in 
      TweenSequenceItem(tween: Tween(begin: 20.0, end: -40.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 15), // present 
      TweenSequenceItem(tween: ConstantTween(-40.0), weight: 20), // hold 
      TweenSequenceItem(tween: Tween(begin: -40.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 10), // put back 
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20), // finish 
    ]).animate(_animCtrl); 
 
    _lidYTween = TweenSequence<double>([ 
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 15), // wait for panda 
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -60.0).chain(CurveTween(curve: Curves.easeOut)), weight: 10), // open 
      TweenSequenceItem(tween: ConstantTween(-60.0), weight: 55), // hold open 
      TweenSequenceItem(tween: Tween(begin: -60.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10), // close 
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10), // wait 
    ]).animate(_animCtrl); 
 
    _lidRotTween = TweenSequence<double>([ 
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 15), 
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeOut)), weight: 10), 
      TweenSequenceItem(tween: ConstantTween(0.5), weight: 55), 
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10), 
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 10), 
    ]).animate(_animCtrl); 
 
    _noteYTween = TweenSequence<double>([ 
      TweenSequenceItem(tween: ConstantTween(100.0), weight: 35), // inside jar 
      TweenSequenceItem(tween: Tween(begin: 100.0, end: -80.0).chain(CurveTween(curve: Curves.easeOutBack)), weight: 15), // present 
      TweenSequenceItem(tween: ConstantTween(-80.0), weight: 20), // hold 
      TweenSequenceItem(tween: Tween(begin: -80.0, end: 100.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10), // put back 
      TweenSequenceItem(tween: ConstantTween(100.0), weight: 20), 
    ]).animate(_animCtrl); 
 
    _noteOpacityTween = TweenSequence<double>([ 
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 35), 
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 5), // quick fade in 
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 30), 
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 5), // quick fade out 
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 25), 
    ]).animate(_animCtrl); 
 
    _animCtrl.addListener(() { 
      final t = _animCtrl.value; 
      String newPhase = 'Idle'; 
      if (t > 0.0 && t <= 0.15) {
        newPhase = 'Walking to jar...'; 
      } else if (t > 0.15 && t <= 0.25) {
        newPhase = 'Opening lid...'; 
      } else if (t > 0.25 && t <= 0.35) {
        newPhase = 'Reaching in...'; 
      } else if (t > 0.35 && t <= 0.70) {
        newPhase = 'Presenting memory'; 
      } else if (t > 0.70 && t <= 0.80) {
        newPhase = 'Putting it back...'; 
      } else if (t > 0.80 && t <= 0.90) {
        newPhase = 'Closing jar...'; 
      } else if (t > 0.90 && t < 1.0) {
        newPhase = 'Walking back...'; 
      }
       
      if (_phaseLabel != newPhase) { 
        setState(() { 
          _phaseLabel = newPhase; 
        }); 
      } 
    }); 
 
    _animCtrl.addStatusListener((status) { 
      if (status == AnimationStatus.completed) { 
        setState(() { 
          _revealedMemory = null; 
          _phaseLabel = ''; 
        }); 
      } 
    }); 
  } 
 
  @override 
  void dispose() { 
    _animCtrl.dispose(); 
    super.dispose(); 
  } 
 
  void _pickMemory() { 
    if (_animCtrl.isAnimating) return; 
    setState(() { 
      _revealedMemory = "A peaceful morning coffee before everyone woke up."; 
    }); 
    _animCtrl.forward(from: 0.0); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'gratitude', 
        child: SafeArea( 
          child: Column( 
            children: [ 
              // Back link 
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
 
              // Header 
              Padding( 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), 
                child: Column( 
                  children: [ 
                    Text( 
                      'HELLO YOU', 
                      style: GoogleFonts.inter( 
                        fontSize: 11, 
                        fontWeight: FontWeight.w500, 
                        letterSpacing: 1.4, 
                        color: Colors.amber[300], 
                      ), 
                    ), 
                    const SizedBox(height: 8), 
                    Text( 
                      'Moments worth keeping.', 
                      textAlign: TextAlign.center, 
                      style: GoogleFonts.lora( 
                        fontSize: 36, 
                        fontWeight: FontWeight.w500, 
                        letterSpacing: -0.5, 
                        color: Colors.white, 
                        height: 1.15, 
                      ), 
                    ), 
                    const SizedBox(height: 8), 
                    Text( 
                      'Save a note. Ask Panda to choose one when you need it.', 
                      textAlign: TextAlign.center, 
                      style: GoogleFonts.inter( 
                        fontSize: 15, 
                        color: Colors.amber[100]?.withValues(alpha: 0.8), 
                        height: 1.5, 
                      ), 
                    ), 
                    const SizedBox(height: 24), 
                    Row( 
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [ 
                        ElevatedButton( 
                          onPressed: () {}, 
                          style: ElevatedButton.styleFrom( 
                            backgroundColor: Colors.amber[400], 
                            foregroundColor: const Color(0xFF451A03), // amber-950 
                            shape: RoundedRectangleBorder( 
                              borderRadius: BorderRadius.circular(ZenTokens.radiusLg), 
                            ), 
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), 
                            elevation: 0, 
                          ), 
                          child: Text( 
                            'Add a gratitude moment', 
                            style: GoogleFonts.inter( 
                              fontSize: 14, 
                              fontWeight: FontWeight.w600, 
                            ), 
                          ), 
                        ), 
                        const SizedBox(width: 12), 
                        TextButton( 
                          onPressed: _animCtrl.isAnimating ? null : _pickMemory, 
                          style: TextButton.styleFrom( 
                            foregroundColor: Colors.white, 
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), 
                            shape: RoundedRectangleBorder( 
                              borderRadius: BorderRadius.circular(ZenTokens.radiusLg), 
                            ), 
                          ), 
                          child: Text( 
                            _animCtrl.isAnimating ? 'Panda is choosing...' : 'Ask Panda to pick', 
                            style: GoogleFonts.inter( 
                              fontSize: 14, 
                              fontWeight: FontWeight.w500, 
                            ), 
                          ), 
                        ), 
                      ], 
                    ), 
                  ], 
                ), 
              ), 
 
              Expanded( 
                child: Center( 
                  child: AnimatedBuilder( 
                    animation: _animCtrl, 
                    builder: (context, child) { 
                      return SizedBox( 
                        width: 340, 
                        height: 380, 
                        child: Stack( 
                          clipBehavior: Clip.none, 
                          alignment: Alignment.center, 
                          children: [ 
                            // Phase Label 
                            Positioned( 
                              bottom: 20, 
                              child: Text( 
                                _phaseLabel, 
                                style: GoogleFonts.inter( 
                                  fontSize: 14, 
                                  fontStyle: FontStyle.italic, 
                                  color: Colors.white.withValues(alpha: 0.8), 
                                ), 
                              ), 
                            ), 
                             
                            // Panda 
                            Positioned( 
                              left: 40 + _pandaXTween.value, 
                              top: 220 + _pandaYTween.value, 
                              child: CustomPaint( 
                                size: const Size(64, 64), 
                                painter: _SimplePandaPainter(), 
                              ), 
                            ), 
 
                            // Paper Note (animates up from jar) 
                            Positioned( 
                              left: 200, 
                              top: 140 + _noteYTween.value, 
                              child: Opacity( 
                                opacity: _noteOpacityTween.value, 
                                child: Container( 
                                  width: 160, 
                                  padding: const EdgeInsets.all(12), 
                                  decoration: BoxDecoration( 
                                    color: const Color(0xFFFEF3C7), // amber-50 
                                    borderRadius: BorderRadius.circular(12), 
                                    border: Border.all(color: const Color(0xFFFDE047)), // amber-300 
                                    boxShadow: [ 
                                      BoxShadow( 
                                        color: Colors.black.withValues(alpha: 0.1), 
                                        blurRadius: 8, 
                                        offset: const Offset(0, 4), 
                                      ) 
                                    ], 
                                  ), 
                                  child: Text( 
                                    _revealedMemory ?? '', 
                                    style: GoogleFonts.inter( 
                                      fontSize: 13, 
                                      color: const Color(0xFF78350F), // amber-900 
                                      height: 1.4, 
                                    ), 
                                  ), 
                                ), 
                              ), 
                            ), 
 
                            // Jar Body 
                            Positioned( 
                              left: 200, 
                              top: 150, 
                              child: CustomPaint( 
                                size: const Size(120, 160), 
                                painter: _JarBodyPainter(), 
                              ), 
                            ), 
 
                            // Badge 
                            Positioned( 
                              left: 280, 
                              top: 240, 
                              child: Container( 
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                                decoration: BoxDecoration( 
                                  color: Colors.white, 
                                  borderRadius: BorderRadius.circular(12), 
                                  boxShadow: [ 
                                    BoxShadow( 
                                      color: Colors.black.withValues(alpha: 0.1), 
                                      blurRadius: 4, 
                                    ) 
                                  ], 
                                ), 
                                child: Text( 
                                  '12', 
                                  style: GoogleFonts.inter( 
                                    fontSize: 12, 
                                    fontWeight: FontWeight.bold, 
                                    color: const Color(0xFFEAB308), // amber-500 
                                  ), 
                                ), 
                              ), 
                            ), 
 
                            // Jar Lid 
                            Positioned( 
                              left: 190, 
                              top: 115 + _lidYTween.value, 
                              child: Transform.rotate( 
                                angle: _lidRotTween.value, 
                                alignment: Alignment.bottomRight, 
                                child: CustomPaint( 
                                  size: const Size(140, 50), 
                                  painter: _JarLidPainter(), 
                                ), 
                              ), 
                            ), 
                          ], 
                        ), 
                      ); 
                    }, 
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
 
class _SimplePandaPainter extends CustomPainter { 
  @override 
  void paint(Canvas canvas, Size size) { 
    final paint = Paint()..style = PaintingStyle.fill; 
     
    // Ears 
    paint.color = const Color(0xFF1F2937); 
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.2), 10, paint); 
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.2), 10, paint); 
 
    // Head 
    paint.color = Colors.white; 
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint); 
     
    // Eye patches 
    paint.color = const Color(0xFF1F2937); 
    canvas.save(); 
    canvas.translate(size.width * 0.3, size.height * 0.45); 
    canvas.rotate(-0.2); 
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 14, height: 20), paint); 
    canvas.restore(); 
 
    canvas.save(); 
    canvas.translate(size.width * 0.7, size.height * 0.45); 
    canvas.rotate(0.2); 
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 14, height: 20), paint); 
    canvas.restore(); 
 
    // Eye whites 
    paint.color = Colors.white; 
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.45), 3, paint); 
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.45), 3, paint); 
 
    // Nose 
    paint.color = const Color(0xFF1F2937); 
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width / 2, size.height * 0.65), width: 8, height: 5), paint); 
  } 
 
  @override 
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; 
} 
 
class _JarBodyPainter extends CustomPainter { 
  @override 
  void paint(Canvas canvas, Size size) { 
    final fillPaint = Paint() 
      ..color = const Color(0xFFFEF08A) 
      ..style = PaintingStyle.fill; 
       
    final strokePaint = Paint() 
      ..color = const Color(0xFFEAB308) 
      ..style = PaintingStyle.stroke 
      ..strokeWidth = 4; 
 
    // Neck 
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 15), fillPaint); 
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 15), strokePaint); 
 
    // Body 
    final path = Path() 
      ..moveTo(0, 15) 
      ..lineTo(size.width, 15) 
      ..lineTo(size.width, size.height - 30) 
      ..quadraticBezierTo(size.width, size.height, size.width - 30, size.height) 
      ..lineTo(30, size.height) 
      ..quadraticBezierTo(0, size.height, 0, size.height - 30) 
      ..close(); 
       
    canvas.drawPath(path, fillPaint); 
    canvas.drawPath(path, strokePaint); 
     
    // Highlight 
    final highlightPaint = Paint() 
      ..color = Colors.white.withValues(alpha: 0.6) 
      ..style = PaintingStyle.fill; 
    canvas.drawRRect( 
      RRect.fromRectAndRadius(Rect.fromLTWH(10, 30, 8, size.height - 70), const Radius.circular(4)),  
      highlightPaint 
    ); 
  } 
 
  @override 
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; 
} 
 
class _JarLidPainter extends CustomPainter { 
  @override 
  void paint(Canvas canvas, Size size) { 
    final fillPaint = Paint() 
      ..color = const Color(0xFFA855F7) // purple-500 
      ..style = PaintingStyle.fill; 
 
    // Knob 
    canvas.drawRRect( 
      RRect.fromRectAndRadius(Rect.fromLTWH(45, 0, 50, 20), const Radius.circular(8)),  
      fillPaint 
    ); 
 
    // Main Lid 
    canvas.drawRRect( 
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 15, size.width, 35), const Radius.circular(8)),  
      fillPaint 
    ); 
     
    // Highlight 
    final highlightPaint = Paint() 
      ..color = const Color(0xFFD8B4FE).withValues(alpha: 0.5) 
      ..style = PaintingStyle.fill; 
    canvas.drawRRect( 
      RRect.fromRectAndRadius(Rect.fromLTWH(10, 22, 30, 6), const Radius.circular(3)),  
      highlightPaint 
    ); 
 
    // Heart 
    final heartPaint = Paint() 
      ..color = const Color(0xFFEF4444) 
      ..style = PaintingStyle.fill; 
    final heartPath = Path() 
      ..moveTo(70, 42) 
      ..cubicTo(70, 42, 60, 34, 60, 28) 
      ..cubicTo(60, 23, 66, 23, 70, 27) 
      ..cubicTo(74, 23, 80, 23, 80, 28) 
      ..cubicTo(80, 34, 70, 42, 70, 42) 
      ..close(); 
       
    canvas.drawPath(heartPath, heartPaint); 
  } 
 
  @override 
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; 
}
