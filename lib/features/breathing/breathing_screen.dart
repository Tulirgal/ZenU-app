import 'dart:async'; 

import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class BreathingPattern { 
  final String id; 
  final String name; 
  final String description; 
  final List<int> steps; 
  final int defaultMinutes; 
  final String difficulty; 
 
  const BreathingPattern({ 
    required this.id, 
    required this.name, 
    required this.description, 
    required this.steps, 
    required this.defaultMinutes, 
    required this.difficulty, 
  }); 
} 
 
const _patterns = [ 
  BreathingPattern( 
    id: 'box', 
    name: 'Box Breathing', 
    description: 'A calm, guided rhythm to steady your breath and increase focus.', 
    steps: [4, 4, 4, 4], 
    defaultMinutes: 3, 
    difficulty: 'All levels', 
  ), 
  BreathingPattern( 
    id: '4-7-8', 
    name: '4-7-8', 
    description: 'Promotes deep relaxation and helps you fall asleep faster.', 
    steps: [4, 7, 8, 0], 
    defaultMinutes: 5, 
    difficulty: 'Intermediate', 
  ), 
  BreathingPattern( 
    id: 'deep', 
    name: 'Deep Calm', 
    description: 'A simple technique to center yourself quickly.', 
    steps: [5, 0, 5, 0], 
    defaultMinutes: 3, 
    difficulty: 'Beginner', 
  ), 
  BreathingPattern( 
    id: 'sighing', 
    name: 'Cyclic Sighing', 
    description: 'Scientifically proven to rapidly reduce anxiety and stress.', 
    steps: [2, 0, 6, 0], 
    defaultMinutes: 5, 
    difficulty: 'Beginner', 
  ), 
]; 
 
class BreathingScreen extends StatefulWidget { 
  const BreathingScreen({super.key}); 
 
  @override 
  State<BreathingScreen> createState() => _BreathingScreenState(); 
} 
 
class _BreathingScreenState extends State<BreathingScreen> { 
  BreathingPattern? _selectedPattern; 
 
  void _openPlayer(BreathingPattern pattern) { 
    setState(() { 
      _selectedPattern = pattern; 
    }); 
  } 
 
  void _closePlayer() { 
    setState(() { 
      _selectedPattern = null; 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Stack( 
        children: [ 
          ModuleBackground( 
            moduleKey: 'breathing', 
            child: SafeArea( 
              child: ListView( 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), 
                children: [ 
                  const SizedBox(height: 16), 
                  Text( 
                    'Breathe', 
                    style: GoogleFonts.lora( 
                      fontSize: 32, 
                      fontWeight: FontWeight.w600, 
                      letterSpacing: -0.5, 
                      color: ZenTokens.fg, 
                    ), 
                  ), 
                  const SizedBox(height: 8), 
                  Text( 
                    'Take a moment to center yourself.', 
                    style: GoogleFonts.inter( 
                      fontSize: 14, 
                      color: ZenTokens.fgMuted, 
                    ), 
                  ), 
                  const SizedBox(height: 32), 
                  _buildQuickSession(), 
                  const SizedBox(height: 40), 
                  Text( 
                    'Choose a practice', 
                    style: GoogleFonts.lora( 
                      fontSize: 24, 
                      fontWeight: FontWeight.w600, 
                      letterSpacing: -0.5, 
                      color: ZenTokens.fg, 
                    ), 
                  ), 
                  const SizedBox(height: 16), 
                  GridView.builder( 
                    shrinkWrap: true, 
                    physics: const NeverScrollableScrollPhysics(), 
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent( 
                      maxCrossAxisExtent: 340, 
                      mainAxisExtent: 240, 
                      crossAxisSpacing: 16, 
                      mainAxisSpacing: 16, 
                    ), 
                    itemCount: _patterns.length, 
                    itemBuilder: (context, index) { 
                      return _buildTechniqueCard(_patterns[index]); 
                    }, 
                  ), 
                  const SizedBox(height: 48), 
                ], 
              ), 
            ), 
          ), 
          if (_selectedPattern != null) 
            Positioned.fill( 
              child: BreathingPlayerOverlay( 
                pattern: _selectedPattern!, 
                onClose: _closePlayer, 
              ), 
            ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildQuickSession() { 
    final pattern = _patterns[0]; // Box as quick 
    return Container( 
      decoration: BoxDecoration( 
        color: Colors.white.withValues(alpha: 0.8), 
        borderRadius: BorderRadius.circular(ZenTokens.radius2xl), 
        border: Border.all(color: ZenTokens.borderSoft), 
        boxShadow: [ 
          BoxShadow( 
            color: const Color(0xFF281E3C).withValues(alpha: 0.28), 
            blurRadius: 40, 
            offset: const Offset(0, 12), 
            spreadRadius: -28, 
          ) 
        ], 
      ), 
      padding: const EdgeInsets.all(24), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [ 
          Text( 
            'QUICK SESSION FOR YOU', 
            style: GoogleFonts.inter( 
              fontSize: 11, 
              fontWeight: FontWeight.w500, 
              letterSpacing: 1.6, 
              color: ZenTokens.secondary, 
            ), 
          ), 
          const SizedBox(height: 4), 
          Text( 
            pattern.name, 
            style: GoogleFonts.lora( 
              fontSize: 24, 
              fontWeight: FontWeight.w600, 
              letterSpacing: -0.5, 
              color: ZenTokens.fg, 
            ), 
          ), 
          const SizedBox(height: 4), 
          Text( 
            '${pattern.steps.join(' • ')}  |  ${pattern.defaultMinutes} min', 
            style: GoogleFonts.inter( 
              fontSize: 14, 
              color: ZenTokens.fgMuted, 
            ), 
          ), 
          const SizedBox(height: 16), 
          SizedBox( 
            height: 44, 
            width: double.infinity, 
            child: ElevatedButton( 
              onPressed: () => _openPlayer(pattern), 
              style: ElevatedButton.styleFrom( 
                backgroundColor: ZenTokens.primary, 
                foregroundColor: Colors.white, 
                elevation: 0, 
                shape: RoundedRectangleBorder( 
                  borderRadius: BorderRadius.circular(ZenTokens.radiusLg), 
                ), 
              ), 
              child: Text( 
                'Start', 
                style: GoogleFonts.inter( 
                  fontSize: 14, 
                  fontWeight: FontWeight.w500, 
                ), 
              ), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildTechniqueCard(BreathingPattern pattern) { 
    return GestureDetector( 
      onTap: () => _openPlayer(pattern), 
      child: Container( 
        decoration: BoxDecoration( 
          color: Colors.white.withValues(alpha: 0.85), 
          borderRadius: BorderRadius.circular(ZenTokens.radius2xl), 
          border: Border.all(color: ZenTokens.borderSoft), 
          boxShadow: [ 
            BoxShadow( 
              color: const Color(0xFF281E3C).withValues(alpha: 0.35), 
              blurRadius: 28, 
              offset: const Offset(0, 8), 
              spreadRadius: -24, 
            ) 
          ], 
        ), 
        padding: const EdgeInsets.all(20), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [ 
            Container( 
              width: 40, 
              height: 40, 
              decoration: BoxDecoration( 
                color: ZenTokens.secondary.withValues(alpha: 0.1), 
                shape: BoxShape.circle, 
              ), 
              child: Icon(Icons.air_rounded, color: ZenTokens.secondary, size: 20), 
            ), 
            const SizedBox(height: 16), 
            Text( 
              pattern.name, 
              style: GoogleFonts.lora( 
                fontSize: 20, 
                fontWeight: FontWeight.w600, 
                letterSpacing: -0.5, 
                color: ZenTokens.fg, 
              ), 
            ), 
            const SizedBox(height: 6), 
            Text( 
              pattern.description, 
              maxLines: 2, 
              overflow: TextOverflow.ellipsis, 
              style: GoogleFonts.inter( 
                fontSize: 14, 
                height: 1.6, 
                color: ZenTokens.fgMuted, 
              ), 
            ), 
            const SizedBox(height: 12), 
            Text( 
              pattern.steps.join(' • '), 
              style: GoogleFonts.inter( 
                fontSize: 14, 
                color: ZenTokens.secondary, 
              ), 
            ), 
            const Spacer(), 
            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [ 
                Text( 
                  '~${pattern.defaultMinutes} min', 
                  style: GoogleFonts.inter( 
                    fontSize: 12, 
                    color: ZenTokens.fgSubtle, 
                  ), 
                ), 
                Container( 
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), 
                  decoration: BoxDecoration( 
                    color: ZenTokens.bg, 
                    borderRadius: BorderRadius.circular(ZenTokens.radiusFull), 
                    border: Border.all(color: ZenTokens.borderSoft), 
                  ), 
                  child: Text( 
                    pattern.difficulty, 
                    style: GoogleFonts.inter( 
                      fontSize: 12, 
                      color: ZenTokens.fgSubtle, 
                    ), 
                  ), 
                ) 
              ], 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
} 
 
class BreathingPlayerOverlay extends StatefulWidget { 
  final BreathingPattern pattern; 
  final VoidCallback onClose; 
 
  const BreathingPlayerOverlay({ 
    super.key, 
    required this.pattern, 
    required this.onClose, 
  }); 
 
  @override 
  State<BreathingPlayerOverlay> createState() => _BreathingPlayerOverlayState(); 
} 
 
class _BreathingPlayerOverlayState extends State<BreathingPlayerOverlay> with TickerProviderStateMixin { 
  late AnimationController _orbController; 
  String _uiPhase = 'ready'; // ready, active, complete 
  bool _isPaused = true; 
  String _phase = 'Inhale'; 
  int _remainingSeconds = 0; 
  Timer? _timer; 
  int _currentStepIndex = 0; 
  int _stepElapsed = 0; 
 
  // HSL Color translations 
  // hsl(210 80% 70%) = Color(0xFF7CB8F8) 
  // hsl(262 48% 65%) = Color(0xFF8F73CE) 
  // hsl(210 90% 96%) = Color(0xFFEDF5FE) 
  // hsl(210 70% 68%) = Color(0xFF75B3F0) 
  // hsl(262 48% 58%) = Color(0xFF7A53D0) 
 
  @override 
  void initState() { 
    super.initState(); 
    _remainingSeconds = widget.pattern.steps[0]; 
    _orbController = AnimationController( 
      vsync: this, 
      duration: Duration(seconds: widget.pattern.steps[0]), 
    ); 
  } 
 
  @override 
  void dispose() { 
    _timer?.cancel(); 
    _orbController.dispose(); 
    super.dispose(); 
  } 
 
  void _begin() { 
    setState(() { 
      _uiPhase = 'active'; 
      _isPaused = false; 
      _currentStepIndex = 0; 
      _stepElapsed = 0; 
      _phase = 'Inhale'; 
      _remainingSeconds = widget.pattern.steps[0]; 
    }); 
    _startCurrentPhaseAnimation(); 
    _startTimer(); 
  } 
 
  void _togglePlayPause() { 
    if (_uiPhase == 'ready') { 
      _begin(); 
      return; 
    } 
    setState(() { 
      _isPaused = !_isPaused; 
    }); 
    if (_isPaused) { 
      _timer?.cancel(); 
      _orbController.stop(); 
    } else { 
      _startTimer(); 
      if (_orbController.isAnimating == false) { 
        if (_phase == 'Inhale' || _phase == 'Hold (In)') { 
          _orbController.forward(); 
        } else { 
          _orbController.reverse(); 
        } 
      } 
    } 
  } 
 
  void _startTimer() { 
    _timer?.cancel(); 
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
      if (_isPaused) return; 
 
      setState(() { 
        _stepElapsed++; 
        final stepDuration = widget.pattern.steps[_currentStepIndex]; 
         
        if (_stepElapsed >= stepDuration) { 
          _nextPhase(); 
        } else { 
          _remainingSeconds = stepDuration - _stepElapsed; 
        } 
      }); 
    }); 
  } 
 
  void _nextPhase() { 
    _currentStepIndex++; 
    if (_currentStepIndex >= widget.pattern.steps.length) { 
      _currentStepIndex = 0; 
    } 
     
    final stepDuration = widget.pattern.steps[_currentStepIndex]; 
    if (stepDuration == 0) { 
      _nextPhase(); // Skip 0 duration steps 
      return; 
    } 
 
    _stepElapsed = 0; 
    _remainingSeconds = stepDuration; 
     
    // Determine phase name based on index 
    // 0: Inhale, 1: Hold (In), 2: Exhale, 3: Hold (Out) 
    switch (_currentStepIndex) { 
      case 0: _phase = 'Inhale'; break; 
      case 1: _phase = 'Hold'; break; 
      case 2: _phase = 'Exhale'; break; 
      case 3: _phase = 'Hold'; break; 
    } 
 
    _startCurrentPhaseAnimation(); 
  } 
 
  void _startCurrentPhaseAnimation() { 
    final duration = Duration(seconds: widget.pattern.steps[_currentStepIndex]); 
    _orbController.duration = duration; 
     
    if (_currentStepIndex == 0) { 
      // Inhale -> expand 
      _orbController.forward(from: 0.0); 
    } else if (_currentStepIndex == 1) { 
      // Hold In -> stay expanded 
      _orbController.value = 1.0; 
    } else if (_currentStepIndex == 2) { 
      // Exhale -> contract 
      _orbController.reverse(from: 1.0); 
    } else if (_currentStepIndex == 3) { 
      // Hold Out -> stay contracted 
      _orbController.value = 0.0; 
    } 
  } 
 
  String _phaseInstruction(String phase) { 
    switch (phase) { 
      case 'Inhale': return 'Draw breath in deeply'; 
      case 'Exhale': return 'Release breath slowly'; 
      case 'Hold': return 'Let it settle'; 
      default: return 'Breathe'; 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return ModuleBackground( 
      moduleKey: 'breathing', 
      child: SafeArea( 
        child: Column( 
          children: [ 
            // Header 
            Padding( 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
              child: Row( 
                children: [ 
                  Container( 
                    width: 56, 
                    height: 56, 
                    decoration: BoxDecoration( 
                      color: ZenTokens.secondary.withValues(alpha: 0.2), 
                      shape: BoxShape.circle, 
                    ), 
                    child: Icon(Icons.air_rounded, color: ZenTokens.secondary), 
                  ), 
                  const SizedBox(width: 16), 
                  Expanded( 
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [ 
                        Text( 
                          widget.pattern.name, 
                          style: GoogleFonts.lora( 
                            fontSize: 20, 
                            fontWeight: FontWeight.w600, 
                            color: ZenTokens.fg, 
                            letterSpacing: -0.5, 
                          ), 
                        ), 
                        Text( 
                          '${widget.pattern.defaultMinutes} min session', 
                          style: GoogleFonts.inter( 
                            fontSize: 14, 
                            color: ZenTokens.fgMuted, 
                          ), 
                        ), 
                      ], 
                    ), 
                  ), 
                  IconButton( 
                    onPressed: widget.onClose, 
                    icon: const Icon(Icons.close_rounded), 
                    color: ZenTokens.fg, 
                  ), 
                ], 
              ), 
            ), 
 
            // Main Body 
            Expanded( 
              child: Column( 
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [ 
                  Text( 
                    _phase.toUpperCase(), 
                    style: GoogleFonts.inter( 
                      fontSize: 11, 
                      fontWeight: FontWeight.w500, 
                      letterSpacing: 1.6, 
                      color: ZenTokens.secondary, 
                    ), 
                  ), 
                  const SizedBox(height: 4), 
                  Text( 
                    _uiPhase == 'ready' ? 'When you are ready' : _phaseInstruction(_phase), 
                    style: GoogleFonts.inter( 
                      fontSize: 16, 
                      color: ZenTokens.fg.withValues(alpha: 0.8), 
                    ), 
                  ), 
                  const SizedBox(height: 32), 
                   
                  // Orb 
                  SizedBox( 
                    height: 288, 
                    child: Center( 
                      child: AnimatedBuilder( 
                        animation: _orbController, 
                        builder: (context, child) { 
                          // Scale goes from 0.5 to 1.0 based on controller 
                          final scale = 0.5 + (_orbController.value * 0.5); 
                           
                          return Stack( 
                            alignment: Alignment.center, 
                            children: [ 
                              // Outer ring 
                              Transform.scale( 
                                scale: scale * 1.3, 
                                child: Container( 
                                  width: 200, 
                                  height: 200, 
                                  decoration: BoxDecoration( 
                                    shape: BoxShape.circle, 
                                    border: Border.all( 
                                      color: const Color(0xFF7A53D0).withValues(alpha: 0.2), 
                                      width: 1.5, 
                                    ), 
                                  ), 
                                ), 
                              ), 
                              // Mid ring 
                              Transform.scale( 
                                scale: scale * 1.15, 
                                child: Container( 
                                  width: 200, 
                                  height: 200, 
                                  decoration: BoxDecoration( 
                                    shape: BoxShape.circle, 
                                    border: Border.all( 
                                      color: const Color(0xFF7CB8F8).withValues(alpha: 0.4), 
                                      width: 2, 
                                    ), 
                                  ), 
                                ), 
                              ), 
                              // Core orb 
                              Transform.scale( 
                                scale: scale, 
                                child: Container( 
                                  width: 200, 
                                  height: 200, 
                                  decoration: const BoxDecoration( 
                                    shape: BoxShape.circle, 
                                    gradient: RadialGradient( 
                                      colors: [ 
                                        Color(0xFFEDF5FE), 
                                        Color(0xFF75B3F0), 
                                        Color(0xFF7A53D0), 
                                      ], 
                                      stops: [0.0, 0.4, 1.0], 
                                    ), 
                                  ), 
                                ), 
                              ), 
                            ], 
                          ); 
                        }, 
                      ), 
                    ), 
                  ), 
 
                  const SizedBox(height: 32), 
                  Text( 
                    _remainingSeconds.toString().padLeft(2, '0'), 
                    style: GoogleFonts.lora( 
                      fontSize: 52, 
                      fontWeight: FontWeight.w400, 
                      letterSpacing: -1, 
                      color: ZenTokens.fg, 
                    ), 
                  ), 
 
                  if (_uiPhase == 'ready') ...[ 
                    const SizedBox(height: 24), 
                    SizedBox( 
                      height: 48, 
                      width: 140, 
                      child: ElevatedButton( 
                        onPressed: _begin, 
                        style: ElevatedButton.styleFrom( 
                          backgroundColor: ZenTokens.primary, 
                          foregroundColor: Colors.white, 
                          elevation: 0, 
                          shape: RoundedRectangleBorder( 
                            borderRadius: BorderRadius.circular(ZenTokens.radiusLg), 
                          ), 
                        ), 
                        child: Text( 
                          'Begin', 
                          style: GoogleFonts.inter( 
                            fontSize: 14, 
                            fontWeight: FontWeight.w500, 
                          ), 
                        ), 
                      ), 
                    ) 
                  ], 
                ], 
              ), 
            ), 
 
            // Controls 
            if (_uiPhase != 'ready') 
              Container( 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), 
                decoration: BoxDecoration( 
                  color: Colors.white.withValues(alpha: 0.7), 
                  border: Border(top: BorderSide(color: ZenTokens.borderSoft)), 
                ), 
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [ 
                    GestureDetector( 
                      onTap: _togglePlayPause, 
                      child: Container( 
                        width: 56, 
                        height: 56, 
                        decoration: BoxDecoration( 
                          color: ZenTokens.primary, 
                          shape: BoxShape.circle, 
                        ), 
                        child: Icon( 
                          _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded, 
                          color: Colors.white, 
                          size: 32, 
                        ), 
                      ), 
                    ), 
                  ], 
                ), 
              ), 
          ], 
        ), 
      ), 
    ); 
  } 
}
