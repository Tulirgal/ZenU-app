import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class ScribbleScreen extends StatelessWidget { 
  const ScribbleScreen({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'scribble', 
        child: SafeArea( 
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [ 
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
                child: Center( 
                  child: Padding( 
                    padding: const EdgeInsets.symmetric(horizontal: 24), 
                    child: Column( 
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [ 
                        Text( 
                          'Scribble Pad', 
                          textAlign: TextAlign.center, 
                          style: GoogleFonts.lora( 
                            fontSize: 36, 
                            fontWeight: FontWeight.w600, 
                            color: Colors.white, 
                            letterSpacing: -0.5, 
                          ), 
                        ), 
                        const SizedBox(height: 32), 
                        Container( 
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24), 
                          decoration: BoxDecoration( 
                            color: Colors.white.withValues(alpha: 0.15), 
                            borderRadius: BorderRadius.circular(24), 
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)), 
                            boxShadow: [ 
                              BoxShadow( 
                                color: Colors.black.withValues(alpha: 0.1), 
                                blurRadius: 20, 
                                spreadRadius: -5, 
                              ) 
                            ], 
                          ), 
                          child: Column( 
                            children: [ 
                              const Text('🚧', style: TextStyle(fontSize: 48)), 
                              const SizedBox(height: 16), 
                              Text( 
                                'Coming soon in the next update', 
                                textAlign: TextAlign.center, 
                                style: GoogleFonts.inter( 
                                  fontSize: 16, 
                                  fontWeight: FontWeight.w500, 
                                  color: Colors.white, 
                                  height: 1.5, 
                                ), 
                              ), 
                            ], 
                          ), 
                        ), 
                      ], 
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
