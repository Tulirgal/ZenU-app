import 'dart:math' as math; 
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
import 'inner_compass_data.dart'; 
 
enum CompassState { primary, secondary, tertiary, complete } 
 
final Map<String, Color> primaryColors = { 
  "happy": HSLColor.fromAHSL(1.0, 42, 0.92, 0.55).toColor(), 
  "sad": HSLColor.fromAHSL(1.0, 210, 0.70, 0.58).toColor(), 
  "angry": HSLColor.fromAHSL(1.0, 8, 0.78, 0.56).toColor(), 
  "fearful": HSLColor.fromAHSL(1.0, 275, 0.45, 0.55).toColor(), 
  "disgusted": HSLColor.fromAHSL(1.0, 142, 0.40, 0.42).toColor(), 
  "surprised": HSLColor.fromAHSL(1.0, 24, 0.90, 0.58).toColor(), 
  "bad": HSLColor.fromAHSL(1.0, 172, 0.48, 0.42).toColor(), 
}; 
 
final Map<String, String> primaryLabels = { 
  "happy": "Joy", 
  "sad": "Sadness", 
  "angry": "Anger", 
  "fearful": "Fear", 
  "disgusted": "Disgust", 
  "surprised": "Surprise", 
  "bad": "Low", 
}; 
 
final List<String> primaryOrder = [ 
  "happy", 
  "sad", 
  "angry", 
  "fearful", 
  "disgusted", 
  "surprised", 
  "bad" 
]; 
 
class InnerCompassScreen extends StatefulWidget { 
  const InnerCompassScreen({super.key}); 
 
  @override 
  State<InnerCompassScreen> createState() => _InnerCompassScreenState(); 
} 
 
class _InnerCompassScreenState extends State<InnerCompassScreen> { 
  CompassState _viewState = CompassState.primary; 
  String? _selectedPrimary; 
  String? _selectedSecondary; 
  String? _selectedTertiary; 
 
  void _handlePrimary(String primary) { 
    setState(() { 
      _selectedPrimary = primary; 
      _selectedSecondary = null; 
      _selectedTertiary = null; 
      _viewState = CompassState.secondary; 
    }); 
  } 
 
  void _handleSecondary(String secondary) { 
    setState(() { 
      _selectedSecondary = secondary; 
      _selectedTertiary = null; 
      _viewState = CompassState.tertiary; 
    }); 
  } 
 
  void _handleTertiary(String tertiary) { 
    setState(() { 
      _selectedTertiary = tertiary; 
      _viewState = CompassState.complete; 
    }); 
  } 
 
  void _handleBack() { 
    setState(() { 
      if (_viewState == CompassState.complete) { 
        _viewState = CompassState.tertiary; 
      } else if (_viewState == CompassState.tertiary) { 
        _selectedTertiary = null; 
        _viewState = CompassState.secondary; 
      } else if (_viewState == CompassState.secondary) { 
        _selectedSecondary = null; 
        _selectedPrimary = null; 
        _viewState = CompassState.primary; 
      } 
    }); 
  } 
 
  void _handleReset() { 
    setState(() { 
      _viewState = CompassState.primary; 
      _selectedPrimary = null; 
      _selectedSecondary = null; 
      _selectedTertiary = null; 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final accentColor = _selectedPrimary != null 
        ? primaryColors[_selectedPrimary!]! 
        : ZenTokens.fg; 
 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'inner_compass', // Assume there's a theme for it 
        child: SafeArea( 
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [ 
              // Back Button 
              Align( 
                alignment: Alignment.centerLeft, 
                child: Padding( 
                  padding: const EdgeInsets.only(left: 16, top: 12), 
                  child: IconButton( 
                    onPressed: () { 
                      if (_viewState == CompassState.primary) { 
                        context.pop(); 
                      } else { 
                        _handleBack(); 
                      } 
                    }, 
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white), 
                  ), 
                ), 
              ), 
 
              // Header section 
              if (_viewState != CompassState.complete) 
                Padding( 
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), 
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [ 
                      Text( 
                        'Inner Compass', 
                        style: GoogleFonts.inter( 
                          fontSize: 14, 
                          fontWeight: FontWeight.w500, 
                          color: accentColor, 
                        ), 
                      ), 
                      const SizedBox(height: 6), 
                      Text( 
                        _viewState == CompassState.primary 
                            ? 'What are you feeling?' 
                            : _viewState == CompassState.secondary 
                                ? 'Let\'s get closer.' 
                                : 'Almost there.', 
                        style: GoogleFonts.lora( 
                          fontSize: 36, 
                          fontWeight: FontWeight.w600, 
                          color: Colors.white, 
                          letterSpacing: -0.5, 
                        ), 
                      ), 
                      const SizedBox(height: 12), 
                      Text( 
                        _viewState == CompassState.primary 
                            ? 'Choose the emotional family that feels most true. You can refine it in the next step.' 
                            : 'Select the word that best describes your experience right now.', 
                        style: GoogleFonts.inter( 
                          fontSize: 15, 
                          color: Colors.white.withValues(alpha: 0.7), 
                          height: 1.5, 
                        ), 
                      ), 
                    ], 
                  ), 
                ), 
 
              Expanded( 
                child: AnimatedSwitcher( 
                  duration: const Duration(milliseconds: 320), 
                  switchInCurve: Curves.easeOut, 
                  switchOutCurve: Curves.easeIn, 
                  transitionBuilder: (child, animation) { 
                    return FadeTransition( 
                      opacity: animation, 
                      child: SlideTransition( 
                        position: Tween<Offset>( 
                          begin: const Offset(0.0, 0.05), 
                          end: Offset.zero, 
                        ).animate(animation), 
                        child: child, 
                      ), 
                    ); 
                  }, 
                  child: _buildCurrentView(), 
                ), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildCurrentView() { 
    switch (_viewState) { 
      case CompassState.primary: 
        return _buildPrimaryView(); 
      case CompassState.secondary: 
        return _buildOptionsList( 
          key: const ValueKey('secondary'), 
          options: emotions[_selectedPrimary!]!.keys.toList(), 
          selected: _selectedSecondary, 
          onSelect: _handleSecondary, 
        ); 
      case CompassState.tertiary: 
        return _buildOptionsList( 
          key: const ValueKey('tertiary'), 
          options: emotions[_selectedPrimary!]![_selectedSecondary!]!, 
          selected: _selectedTertiary, 
          onSelect: _handleTertiary, 
        ); 
      case CompassState.complete: 
        return _buildCompleteView(); 
    } 
  } 
 
  Widget _buildPrimaryView() { 
    return Center( 
      key: const ValueKey('primary'), 
      child: GestureDetector( 
        child: SizedBox( 
          width: 320, 
          height: 320, 
          child: _CompassWheelWidget( 
            onSelect: _handlePrimary, 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildOptionsList({ 
    required Key key, 
    required List<String> options, 
    required String? selected, 
    required ValueChanged<String> onSelect, 
  }) { 
    final accent = primaryColors[_selectedPrimary!]!; 
    final softAccent = accent.withValues(alpha: 0.15); 
 
    return ListView( 
      key: key, 
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
      children: [ 
        Padding( 
          padding: const EdgeInsets.only(bottom: 16), 
          child: Text( 
            _viewState == CompassState.secondary 
                ? primaryLabels[_selectedPrimary!]! 
                : '${primaryLabels[_selectedPrimary!]!} → ${_selectedSecondary!}', 
            style: GoogleFonts.inter( 
              fontSize: 14, 
              fontWeight: FontWeight.w600, 
              color: accent, 
            ), 
          ), 
        ), 
        Wrap( 
          spacing: 12, 
          runSpacing: 12, 
          children: options.map((opt) { 
            final isSelected = opt == selected; 
            return InkWell( 
              onTap: () => onSelect(opt), 
              borderRadius: BorderRadius.circular(20), 
              child: Container( 
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
                decoration: BoxDecoration( 
                  color: isSelected ? softAccent : ZenTokens.surface, 
                  borderRadius: BorderRadius.circular(20), 
                  border: Border.all( 
                    color: isSelected ? accent.withValues(alpha: 0.55) : ZenTokens.border, 
                    width: isSelected ? 2 : 1, 
                  ), 
                  boxShadow: isSelected 
                      ? [ 
                          BoxShadow( 
                            color: accent.withValues(alpha: 0.2), 
                            blurRadius: 12, 
                            offset: const Offset(0, 4), 
                          ) 
                        ] 
                      : null, 
                ), 
                child: Text( 
                  opt, 
                  style: GoogleFonts.inter( 
                    fontSize: 15, 
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, 
                    color: isSelected ? accent : ZenTokens.fg, 
                  ), 
                ), 
              ), 
            ); 
          }).toList(), 
        ), 
      ], 
    ); 
  } 
 
  Widget _buildCompleteView() { 
    final data = tertiaryData[_selectedTertiary!]; 
    if (data == null) return const SizedBox(); 
    final accent = primaryColors[_selectedPrimary!]!; 
 
    return SingleChildScrollView( 
      key: const ValueKey('complete'), 
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: [ 
          // Path badge 
          Align( 
            alignment: Alignment.centerLeft, 
            child: Container( 
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 
              decoration: BoxDecoration( 
                color: accent.withValues(alpha: 0.15), 
                borderRadius: BorderRadius.circular(16), 
              ), 
              child: Text( 
                '${primaryLabels[_selectedPrimary!]!} / ${_selectedSecondary!}', 
                style: GoogleFonts.inter( 
                  fontSize: 12, 
                  fontWeight: FontWeight.w600, 
                  color: accent, 
                ), 
              ), 
            ), 
          ), 
          const SizedBox(height: 16), 
           
          // Tertiary Name 
          Text( 
            _selectedTertiary!, 
            style: GoogleFonts.lora( 
              fontSize: 40, 
              fontWeight: FontWeight.w500, 
              color: Colors.white, 
              letterSpacing: -0.5, 
            ), 
          ), 
          const SizedBox(height: 24), 
 
          // Affirmation Card 
          Container( 
            padding: const EdgeInsets.all(24), 
            decoration: BoxDecoration( 
              color: ZenTokens.surface, 
              borderRadius: BorderRadius.circular(24), 
              border: Border.all(color: ZenTokens.border), 
            ), 
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [ 
                Text( 
                  data.affirmation, 
                  style: GoogleFonts.inter( 
                    fontSize: 16, 
                    height: 1.6, 
                    color: ZenTokens.fg, 
                  ), 
                ), 
                const SizedBox(height: 20), 
                Container( 
                  padding: const EdgeInsets.all(16), 
                  decoration: BoxDecoration( 
                    color: accent.withValues(alpha: 0.1), 
                    borderRadius: BorderRadius.circular(16), 
                  ), 
                  child: Row( 
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [ 
                      Icon(Icons.lightbulb_outline, color: accent, size: 20), 
                      const SizedBox(width: 12), 
                      Expanded( 
                        child: Text( 
                          data.tip, 
                          style: GoogleFonts.inter( 
                            fontSize: 14, 
                            fontStyle: FontStyle.italic, 
                            color: Colors.white.withValues(alpha: 0.9), 
                            height: 1.5, 
                          ), 
                        ), 
                      ), 
                    ], 
                  ), 
                ), 
              ], 
            ), 
          ), 
          const SizedBox(height: 32), 
 
          // Modules 
          Text( 
            'Suggested for this moment', 
            style: GoogleFonts.inter( 
              fontSize: 14, 
              fontWeight: FontWeight.w600, 
              color: Colors.white.withValues(alpha: 0.6), 
            ), 
          ), 
          const SizedBox(height: 16), 
          ...data.modules.map((mod) { 
            return Padding( 
              padding: const EdgeInsets.only(bottom: 12), 
              child: InkWell( 
                onTap: () { 
                  context.push(mod.route); 
                }, 
                borderRadius: BorderRadius.circular(20), 
                child: Container( 
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), 
                  decoration: BoxDecoration( 
                    color: ZenTokens.surface, 
                    borderRadius: BorderRadius.circular(20), 
                    border: Border.all(color: ZenTokens.border), 
                  ), 
                  child: Row( 
                    children: [ 
                      Text(mod.emoji, style: const TextStyle(fontSize: 24)), 
                      const SizedBox(width: 16), 
                      Expanded( 
                        child: Text( 
                          mod.name, 
                          style: GoogleFonts.inter( 
                            fontSize: 16, 
                            fontWeight: FontWeight.w600, 
                            color: ZenTokens.fg, 
                          ), 
                        ), 
                      ), 
                      Icon( 
                        Icons.arrow_forward_rounded, 
                        color: accent, 
                        size: 20, 
                      ), 
                    ], 
                  ), 
                ), 
              ), 
            ); 
          }), 
 
          const SizedBox(height: 32), 
          Center( 
            child: TextButton( 
              onPressed: _handleReset, 
              child: Text( 
                'Check in again', 
                style: GoogleFonts.inter( 
                  fontSize: 15, 
                  fontWeight: FontWeight.w500, 
                  color: Colors.white, 
                ), 
              ), 
            ), 
          ), 
          const SizedBox(height: 40), 
        ], 
      ), 
    ); 
  } 
} 
 
// SVG Sector math ported to Flutter CustomPainter 
class _CompassWheelWidget extends StatefulWidget { 
  final ValueChanged<String> onSelect; 
  const _CompassWheelWidget({required this.onSelect}); 
 
  @override 
  State<_CompassWheelWidget> createState() => _CompassWheelWidgetState(); 
} 
 
class _CompassWheelWidgetState extends State<_CompassWheelWidget> { 
  String? _hovered; 
 
  @override 
  Widget build(BuildContext context) { 
    return GestureDetector( 
      onTapUp: (details) { 
        // 320 is the size of the box, center is 160 
        final cx = 160.0; 
        final cy = 160.0; 
        final dx = details.localPosition.dx - cx; 
        final dy = details.localPosition.dy - cy; 
         
        // Add 90 degrees because 0 degrees is up in our drawing 
        double angle = math.atan2(dy, dx) * 180 / math.pi + 90; 
        if (angle < 0) angle += 360; 
         
        final radius = math.sqrt(dx * dx + dy * dy); 
        if (radius >= 72 && radius <= 148) { 
          // innerR = 72, outerR = 148 
          final slice = 360 / primaryOrder.length; 
          final index = (angle / slice).floor() % primaryOrder.length; 
          widget.onSelect(primaryOrder[index]); 
        } 
      }, 
      onPanUpdate: (details) { 
        // update hover state if dragging over (simulating hover on mobile) 
      }, 
      child: CustomPaint( 
        painter: _EmotionWheelPainter( 
          hovered: _hovered, 
        ), 
      ), 
    ); 
  } 
} 
 
class _EmotionWheelPainter extends CustomPainter { 
  final String? hovered; 
  _EmotionWheelPainter({this.hovered}); 
 
  @override 
  void paint(Canvas canvas, Size size) { 
    final cx = size.width / 2; 
    final cy = size.height / 2; 
    final innerR = 72.0; 
    final outerR = 148.0; 
    final slice = 360 / primaryOrder.length; 
 
    for (int i = 0; i < primaryOrder.length; i++) { 
      final emotion = primaryOrder[i]; 
      final startAngle = i * slice; 
      final sweepAngle = slice; 
       
      // Translate to radians and shift -90 degrees so 0 is at top 
      final startRad = (startAngle - 90) * math.pi / 180; 
      final sweepRad = sweepAngle * math.pi / 180; 
 
      final color = primaryColors[emotion]!; 
      final isHovered = hovered == emotion; 
 
      final path = Path(); 
      path.arcTo( 
        Rect.fromCircle(center: Offset(cx, cy), radius: outerR),  
        startRad,  
        sweepRad,  
        true 
      ); 
      path.arcTo( 
        Rect.fromCircle(center: Offset(cx, cy), radius: innerR),  
        startRad + sweepRad,  
        -sweepRad,  
        false 
      ); 
      path.close(); 
 
      // Shadow if hovered 
      if (isHovered) { 
        canvas.drawShadow(path, color, 8, true); 
      } 
 
      final fillPaint = Paint() 
        ..color = color.withValues(alpha: isHovered ? 0.92 : 0.68) 
        ..style = PaintingStyle.fill; 
      canvas.drawPath(path, fillPaint); 
 
      final strokePaint = Paint() 
        ..color = isHovered ? color.withValues(alpha: 0.85) : ZenTokens.surface 
        ..style = PaintingStyle.stroke 
        ..strokeWidth = isHovered ? 2.75 : 2.25; 
      canvas.drawPath(path, strokePaint); 
       
      // Optional: Draw text label in the middle of the slice 
      // (This approximates NextJS behavior if labels were visible) 
      // But NextJS relied on tooltips/whispers, I'll draw the labels neatly. 
      final midRad = startRad + sweepRad / 2; 
      final labelR = (innerR + outerR) / 2; 
      final lx = cx + math.cos(midRad) * labelR; 
      final ly = cy + math.sin(midRad) * labelR; 
 
      final textSpan = TextSpan( 
        text: primaryLabels[emotion], 
        style: GoogleFonts.inter( 
          fontSize: 12,  
          fontWeight: FontWeight.w600,  
          color: Colors.white, 
        ), 
      ); 
      final textPainter = TextPainter( 
        text: textSpan, 
        textDirection: TextDirection.ltr, 
        textAlign: TextAlign.center, 
      ); 
      textPainter.layout(); 
      // Save canvas to rotate text 
      canvas.save(); 
      canvas.translate(lx, ly); 
      // Rotate text to align with the slice angle (add 90 deg so it reads upright mostly) 
      double textAngle = midRad + math.pi / 2; 
      if (textAngle > math.pi / 2 && textAngle < 3 * math.pi / 2) { 
        textAngle += math.pi; // Flip text if upside down 
      } 
      canvas.rotate(textAngle); 
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2)); 
      canvas.restore(); 
    } 
  } 
 
  @override 
  bool shouldRepaint(covariant _EmotionWheelPainter oldDelegate) { 
    return oldDelegate.hovered != hovered; 
  } 
}
