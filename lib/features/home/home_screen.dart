import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class HomeScreen extends StatelessWidget { 
  const HomeScreen({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'home', 
        child: SafeArea( 
          child: SingleChildScrollView( 
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32), 
            child: Column( 
              children: [ 
                // Hero Card 
                Container( 
                  width: double.infinity, 
                  constraints: const BoxConstraints(minHeight: 500, maxWidth: 1000), 
                  decoration: BoxDecoration( 
                    color: Colors.white.withValues(alpha: 0.7), 
                    borderRadius: BorderRadius.circular(32), 
                    border: Border.all(color: Colors.black.withValues(alpha: 0.05)), 
                  ), 
                  child: Stack( 
                    children: [ 
                      Positioned( 
                        top: 0, right: 0, 
                        child: Container( 
                          width: 300, 
                          height: 300, 
                          decoration: BoxDecoration( 
                            gradient: RadialGradient( 
                              colors: [ZenTokens.primary.withValues(alpha: 0.15), Colors.transparent], 
                              stops: const [0.0, 0.7], 
                            ), 
                          ), 
                        ), 
                      ), 
                      Padding( 
                        padding: const EdgeInsets.all(40.0), 
                        child: Column( 
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          mainAxisAlignment: MainAxisAlignment.end, 
                          children: [ 
                            const SizedBox(height: 120), 
                            Text( 
                              'ZENU', 
                              style: GoogleFonts.inter( 
                                fontSize: 13, 
                                fontWeight: FontWeight.w700, 
                                letterSpacing: 1.2, 
                                color: ZenTokens.primary, 
                              ), 
                            ), 
                            const SizedBox(height: 16), 
                            Text( 
                              'Your calm,\nbetween classes.', 
                              style: GoogleFonts.lora( 
                                fontSize: 48, 
                                fontWeight: FontWeight.w600, 
                                color: Colors.black87, 
                                letterSpacing: -1.0, 
                                height: 1.1, 
                              ), 
                            ), 
                            const SizedBox(height: 20), 
                            Text( 
                              'Guided breathing, journaling, and a companion who listens — built for student stress, not generic wellness noise.', 
                              style: GoogleFonts.inter(fontSize: 16, color: Colors.black54, height: 1.6), 
                            ), 
                            const SizedBox(height: 40), 
                            Wrap( 
                              spacing: 12, 
                              runSpacing: 12, 
                              children: [ 
                                ElevatedButton( 
                                  onPressed: () => context.push('/signin'), 
                                  style: ElevatedButton.styleFrom( 
                                    backgroundColor: ZenTokens.primary, 
                                    foregroundColor: Colors.white, 
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
                                    elevation: 0, 
                                  ), 
                                  child: Row( 
                                    mainAxisSize: MainAxisSize.min, 
                                    children: [ 
                                      Text('Sign in', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)), 
                                      const SizedBox(width: 8), 
                                      const Icon(Icons.arrow_forward_rounded, size: 20), 
                                    ], 
                                  ), 
                                ), 
                                OutlinedButton( 
                                  onPressed: () => context.push('/signup'), 
                                  style: OutlinedButton.styleFrom( 
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
                                    side: BorderSide(color: Colors.black.withValues(alpha: 0.2)), 
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
                                    foregroundColor: Colors.black87, 
                                  ), 
                                  child: Text('Create account', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)), 
                                ), 
                              ], 
                            ) 
                          ], 
                        ), 
                      ), 
                    ], 
                  ), 
                ), 
                const SizedBox(height: 48), 
                 
                // Features 
                ConstrainedBox( 
                  constraints: const BoxConstraints(maxWidth: 800), 
                  child: Wrap( 
                    spacing: 24, 
                    runSpacing: 24, 
                    children: [ 
                      SizedBox( 
                        width: 300, 
                        child: Row( 
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [ 
                            Icon(Icons.spa_rounded, color: ZenTokens.accent, size: 24), 
                            const SizedBox(width: 12), 
                            Expanded( 
                              child: Text( 
                                'Micro-practices under five minutes to reset between lectures.', 
                                style: GoogleFonts.inter(fontSize: 14, color: Colors.black54, height: 1.5), 
                              ), 
                            ), 
                          ], 
                        ), 
                      ), 
                      SizedBox( 
                        width: 300, 
                        child: Row( 
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: [ 
                            Icon(Icons.nature_rounded, color: ZenTokens.primary, size: 24), 
                            const SizedBox(width: 12), 
                            Expanded( 
                              child: Text( 
                                'Gentle growth that celebrates showing up, not perfection.', 
                                style: GoogleFonts.inter(fontSize: 14, color: Colors.black54, height: 1.5), 
                              ), 
                            ), 
                          ], 
                        ), 
                      ), 
                    ], 
                  ), 
                ) 
              ], 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
}
