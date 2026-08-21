import 'dart:async'; 
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/api/api_client.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
const techniques = [ 
  {'id': 'box',    'name': 'Box',       'inhale': 4, 'hold1': 4, 'exhale': 4, 'hold2': 4}, 
  {'id': '478',    'name': '4-7-8',     'inhale': 4, 'hold1': 7, 'exhale': 8, 'hold2': 0}, 
  {'id': 'deep',   'name': 'Deep',      'inhale': 5, 'hold1': 0, 'exhale': 5, 'hold2': 0}, 
  {'id': 'cyclic', 'name': 'Cyclic',    'inhale': 3, 'hold1': 2, 'exhale': 6, 'hold2': 0}, 
]; 
 
class BreathingScreen extends StatefulWidget { 
  const BreathingScreen({super.key}); 
  @override 
  State<BreathingScreen> createState() => _BreathingScreenState(); 
} 
 
class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin { 
  late AnimationController _controller; 
  late Animation<double> _scaleAnimation; 
   
  int _activeTechIdx = 0; 
  bool _isActive = false; 
  String _phaseLabel = 'Ready'; 
  int _countdown = 0; 
  int _cycles = 0; 
 
  @override 
  void initState() { 
    super.initState(); 
    _controller = AnimationController(vsync: this); 
    _scaleAnimation = Tween<double>(begin: 0.55, end: 1.0).animate( 
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut), 
    ); 
    _logEngagement('opened'); 
  } 
 
  Future<void> _logEngagement(String type) async { 
    try { 
      final c = await ApiClient.getInstance(); 
      await c.post('/api/signals/engagement', data: { 
        'module_id': 'breathing', 
        'event_type': type 
      }); 
    } catch (_) {} 
  } 
 
  @override 
  void dispose() { 
    _isActive = false; 
    _controller.dispose(); 
    super.dispose(); 
  } 
 
  void _toggle() { 
    if (_isActive) { 
      _stop(); 
    } else { 
      _start(); 
    } 
  } 
 
  void _stop() { 
    setState(() { 
      _isActive = false; 
      _phaseLabel = 'Ready'; 
      _countdown = 0; 
      _cycles = 0; 
    }); 
    _controller.reset(); 
  } 
 
  void _start() { 
    setState(() { 
      _isActive = true; 
      _cycles = 0; 
    }); 
    _runCycle(); 
  } 
 
  Future<void> _runCycle() async { 
    if (!_isActive || !mounted) return; 
    if (_cycles >= 3) { 
      _stop(); 
      _logEngagement('completed'); 
      _showCompletionDialog(); 
      return; 
    } 
 
    final tech = techniques[_activeTechIdx]; 
    final inhale = tech['inhale'] as int; 
    final hold1 = tech['hold1'] as int; 
    final exhale = tech['exhale'] as int; 
    final hold2 = tech['hold2'] as int; 
 
    // Inhale 
    if (inhale > 0 && _isActive && mounted) { 
      setState(() => _phaseLabel = 'Breathe In'); 
      _controller.duration = Duration(seconds: inhale); 
      _controller.forward(from: 0.0); 
      await _countdownPhase(inhale); 
    } 
    // Hold 1 
    if (hold1 > 0 && _isActive && mounted) { 
      setState(() => _phaseLabel = 'Hold'); 
      await _countdownPhase(hold1); 
    } 
    // Exhale 
    if (exhale > 0 && _isActive && mounted) { 
      setState(() => _phaseLabel = 'Breathe Out'); 
      _controller.duration = Duration(seconds: exhale); 
      _controller.reverse(from: 1.0); 
      await _countdownPhase(exhale); 
    } 
    // Hold 2 
    if (hold2 > 0 && _isActive && mounted) { 
      setState(() => _phaseLabel = 'Hold'); 
      await _countdownPhase(hold2); 
    } 
 
    if (_isActive && mounted) { 
      _cycles++; 
      _runCycle(); 
    } 
  } 
 
  Future<void> _countdownPhase(int seconds) async { 
    for (int i = seconds; i > 0; i--) { 
      if (!_isActive || !mounted) break; 
      setState(() => _countdown = i); 
      await Future.delayed(const Duration(seconds: 1)); 
    } 
  } 
 
  void _showCompletionDialog() { 
    final theme = ModuleThemes.breathing; 
    showDialog( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        backgroundColor: theme.cardBg, 
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(20),  
          side: BorderSide(color: theme.cardBorder) 
        ), 
        title: Text('Well done!', style: GoogleFonts.inter(color: theme.textPrimary)), 
        content: Text('You have completed 3 cycles of breathing. Notice how your body feels.',  
          style: GoogleFonts.inter(color: theme.textSecondary)), 
        actions: [ 
          TextButton( 
            onPressed: () => ctx.pop(), 
            child: Text('Close', style: GoogleFonts.inter(color: theme.accentColor)), 
          ) 
        ], 
      ), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.breathing; 
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar( 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: IconThemeData(color: theme.textPrimary), 
      ), 
      body: ModuleBackground( 
        moduleKey: 'breathing', 
        child: SafeArea( 
          child: Column( 
            children: [ 
              const SizedBox(height: 20), 
              // Technique Selector 
              SizedBox( 
                height: 40, 
                child: ListView.separated( 
                  padding: const EdgeInsets.symmetric(horizontal: 24), 
                  scrollDirection: Axis.horizontal, 
                  itemCount: techniques.length, 
                  separatorBuilder: (context, index) => const SizedBox(width: 10), 
                  itemBuilder: (_, i) { 
                    final tech = techniques[i]; 
                    final isSel = _activeTechIdx == i; 
                    return GestureDetector( 
                      onTap: () { 
                        if (!_isActive) setState(() => _activeTechIdx = i); 
                      }, 
                      child: AnimatedContainer( 
                        duration: const Duration(milliseconds: 200), 
                        padding: const EdgeInsets.symmetric(horizontal: 16), 
                        alignment: Alignment.center, 
                        decoration: BoxDecoration( 
                          color: isSel ? theme.accentColor.withValues(alpha: 0.2) : theme.cardBg, 
                          borderRadius: BorderRadius.circular(20), 
                          border: Border.all(color: isSel ? theme.accentColor : theme.cardBorder), 
                        ), 
                        child: Text( 
                          tech['name'] as String, 
                          style: GoogleFonts.inter( 
                            color: isSel ? theme.accentColor : theme.textSecondary, 
                            fontWeight: isSel ? FontWeight.w600 : FontWeight.w400, 
                          ), 
                        ), 
                      ), 
                    ); 
                  }, 
                ), 
              ), 
              Expanded( 
                child: Center( 
                  child: Column( 
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [ 
                      Text( 
                        _phaseLabel, 
                        style: GoogleFonts.inter( 
                          fontSize: 24, 
                          fontWeight: FontWeight.w600, 
                          color: theme.textPrimary, 
                        ), 
                      ), 
                      const SizedBox(height: 40), 
                      AnimatedBuilder( 
                        animation: _scaleAnimation, 
                        builder: (context, child) { 
                          return Transform.scale( 
                            scale: _scaleAnimation.value, 
                            child: Container( 
                              width: 250, 
                              height: 250, 
                              decoration: BoxDecoration( 
                                shape: BoxShape.circle, 
                                gradient: RadialGradient( 
                                  colors: [ 
                                    theme.accentColor.withValues(alpha: 0.6), 
                                    theme.accentColor.withValues(alpha: 0.1), 
                                    Colors.transparent, 
                                  ], 
                                  stops: const [0.3, 0.7, 1.0], 
                                ), 
                              ), 
                              alignment: Alignment.center, 
                              child: _isActive 
                                  ? Text( 
                                      '$_countdown', 
                                      style: GoogleFonts.inter( 
                                        fontSize: 48, 
                                        fontWeight: FontWeight.w700, 
                                        color: theme.textPrimary, 
                                      ), 
                                    ) 
                                  : null, 
                            ), 
                          ); 
                        }, 
                      ), 
                    ], 
                  ), 
                ), 
              ), 
              Padding( 
                padding: const EdgeInsets.all(32.0), 
                child: SizedBox( 
                  width: double.infinity, 
                  height: 56, 
                  child: ElevatedButton( 
                    onPressed: _toggle, 
                    style: ElevatedButton.styleFrom( 
                      backgroundColor: _isActive ? theme.cardBg : theme.accentColor, 
                      foregroundColor: _isActive ? theme.textPrimary : Colors.white, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), 
                      side: _isActive ? BorderSide(color: theme.cardBorder) : BorderSide.none, 
                    ), 
                    child: Text( 
                      _isActive ? 'Stop' : 'Start', 
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600), 
                    ), 
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
