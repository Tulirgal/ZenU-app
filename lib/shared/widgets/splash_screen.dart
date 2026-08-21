import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../core/theme/module_themes.dart'; 
import 'module_background.dart'; 
 
class SplashScreen extends StatelessWidget { 
  const SplashScreen({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'home', 
        child: Center( 
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [ 
              Text('ZenU', 
                style: GoogleFonts.inter( 
                  fontSize: 52, fontWeight: FontWeight.w700, 
                  color: ModuleThemes.home.textPrimary, letterSpacing: -1, 
                ), 
              ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.85, 0.85)), 
 
              const SizedBox(height: 10), 
 
              Text('your personal wellness companion', 
                style: GoogleFonts.inter( 
                  fontSize: 14, 
                  color: ModuleThemes.home.textSecondary, 
                ), 
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms), 
 
              const SizedBox(height: 56), 
 
              CircularProgressIndicator( 
                valueColor: AlwaysStoppedAnimation(ModuleThemes.home.accentColor), 
                strokeWidth: 2, 
              ).animate().fadeIn(delay: 700.ms), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}
