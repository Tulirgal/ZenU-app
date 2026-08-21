import 'dart:math'; 
import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../core/api/api_client.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
enum BurstPhase { typing, traveling, expanding, popping, affirming } 
 
class BurstScreen extends StatefulWidget { 
  const BurstScreen({super.key}); 
  @override 
  State<BurstScreen> createState() => _BurstScreenState(); 
} 
 
class _BurstScreenState extends State<BurstScreen> { 
  final _ctrl = TextEditingController(); 
  BurstPhase _phase = BurstPhase.typing; 
  double _bubbleSize = 80; 
  String _randomAffirmation = ''; 
 
  static const affirmations = [ 
    "That feeling no longer owns you. You released it. 🕊️", 
    "You are not your thoughts — you are the one who notices them. ✨", 
    "Every exhale is a letting go. You did that. 🌬️", 
    "Lighter now. That burden was never yours to keep forever. 🦋", 
    "You faced it, you felt it, you freed it. That is courage. 💪", 
  ]; 
 
  @override 
  void initState() { 
    super.initState(); 
    _ctrl.addListener(() { 
      if (_phase == BurstPhase.typing) { 
        setState(() { 
          _bubbleSize = min(220.0, 80.0 + _ctrl.text.length * 1.2); 
        }); 
      } 
    }); 
  } 
 
  @override 
  void dispose() { 
    _ctrl.dispose(); 
    super.dispose(); 
  } 
 
  Future<void> _burstIt() async { 
    if (_ctrl.text.trim().isEmpty) return; 
     
    FocusManager.instance.primaryFocus?.unfocus(); 
 
    // traveling 
    setState(() => _phase = BurstPhase.traveling); 
    await Future.delayed(const Duration(milliseconds: 600)); 
     
    if (!mounted) return; 
    // expanding 
    setState(() { 
      _phase = BurstPhase.expanding; 
      _bubbleSize = 280.0; 
    }); 
    await Future.delayed(const Duration(milliseconds: 1200)); 
     
    if (!mounted) return; 
    // popping 
    setState(() => _phase = BurstPhase.popping); 
    await Future.delayed(const Duration(milliseconds: 500)); 
     
    // log engagement 
    try { 
      final c = await ApiClient.getInstance(); 
      await c.post('/api/signals/engagement', data: {'module_id': 'burst_it_out', 'event_type': 'completed'}); 
    } catch (_) {} 
 
    if (!mounted) return; 
    // affirming 
    setState(() { 
      _phase = BurstPhase.affirming; 
      _randomAffirmation = affirmations[Random().nextInt(affirmations.length)]; 
    }); 
  } 
 
  void _reset() { 
    _ctrl.clear(); 
    setState(() { 
      _phase = BurstPhase.typing; 
      _bubbleSize = 80.0; 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.burst; 
     
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: theme.textPrimary)), 
      body: ModuleBackground( 
        moduleKey: 'burst', 
        child: SafeArea( 
          child: Stack( 
            alignment: Alignment.center, 
            children: [ 
              // The Bubble 
              if (_phase != BurstPhase.affirming) 
                AnimatedPositioned( 
                  duration: _phase == BurstPhase.expanding  
                      ? const Duration(milliseconds: 1200)  
                      : const Duration(milliseconds: 200), 
                  curve: _phase == BurstPhase.expanding ? Curves.easeOutBack : Curves.easeOut, 
                  bottom: _phase == BurstPhase.typing ? 20 : MediaQuery.of(context).size.height / 2 - (_bubbleSize / 2), 
                  child: AnimatedScale( 
                    duration: const Duration(milliseconds: 500), 
                    scale: _phase == BurstPhase.popping ? 1.4 : 1.0, 
                    child: AnimatedOpacity( 
                      duration: const Duration(milliseconds: 400), 
                      opacity: _phase == BurstPhase.popping ? 0.0 : 1.0, 
                      child: Container( 
                        width: _bubbleSize, 
                        height: _bubbleSize, 
                        decoration: BoxDecoration( 
                          shape: BoxShape.circle, 
                          gradient: RadialGradient( 
                            colors: [theme.accentColor.withValues(alpha: 0.6), theme.accentColor.withValues(alpha: 0.1), Colors.transparent], 
                            stops: const [0.3, 0.7, 1.0], 
                          ), 
                        ), 
                      ), 
                    ), 
                  ), 
                ), 
               
              // Typing Phase 
              if (_phase == BurstPhase.typing || _phase == BurstPhase.traveling) 
                Positioned( 
                  top: 50, 
                  left: 24, 
                  right: 24, 
                  child: AnimatedOpacity( 
                    duration: const Duration(milliseconds: 500), 
                    opacity: _phase == BurstPhase.typing ? 1.0 : 0.0, 
                    child: AnimatedScale( 
                      duration: const Duration(milliseconds: 500), 
                      scale: _phase == BurstPhase.typing ? 1.0 : 0.5, 
                      alignment: Alignment.bottomCenter, 
                      child: Column( 
                        children: [ 
                          Text('What do you want to release?', style: GoogleFonts.inter(fontSize: 20, color: theme.textPrimary, fontWeight: FontWeight.w600)), 
                          const SizedBox(height: 20), 
                          TextField( 
                            controller: _ctrl, 
                            maxLines: 5, 
                            style: GoogleFonts.inter(color: theme.textPrimary, fontSize: 16), 
                            decoration: InputDecoration( 
                              hintText: 'Type it all out here...', 
                              hintStyle: GoogleFonts.inter(color: theme.textSecondary), 
                              filled: true, 
                              fillColor: theme.cardBg, 
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), 
                            ), 
                          ), 
                          const SizedBox(height: 30), 
                          ElevatedButton( 
                            onPressed: _burstIt, 
                            style: ElevatedButton.styleFrom( 
                              backgroundColor: theme.accentColor, 
                              foregroundColor: Colors.white, 
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), 
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), 
                            ), 
                            child: const Text('Let it go'), 
                          ), 
                        ], 
                      ), 
                    ), 
                  ), 
                ), 
                 
              // Affirming Phase 
              if (_phase == BurstPhase.affirming) 
                Padding( 
                  padding: const EdgeInsets.all(32.0), 
                  child: Column( 
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [ 
                      Text(_randomAffirmation, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 22, color: theme.textPrimary, fontWeight: FontWeight.w500)).animate().fadeIn().slideY(begin: 0.2, end: 0), 
                      const SizedBox(height: 40), 
                      OutlinedButton( 
                        onPressed: _reset, 
                        style: OutlinedButton.styleFrom( 
                          foregroundColor: theme.accentColor, 
                          side: BorderSide(color: theme.accentColor), 
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), 
                        ), 
                        child: const Text('Release another thought'), 
                      ).animate().fadeIn(delay: 500.ms), 
                    ], 
                  ), 
                ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}
