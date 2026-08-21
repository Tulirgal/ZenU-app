import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class ScribbleScreen extends StatelessWidget { 
  const ScribbleScreen({super.key}); 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.scribble; 
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: theme.textPrimary)), 
      body: ModuleBackground( 
        moduleKey: 'scribble', 
        child: Center( 
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [ 
              Text('Scribble Pad', style: GoogleFonts.inter(fontSize: 24, color: theme.textPrimary, fontWeight: FontWeight.w600)), 
              const SizedBox(height: 16), 
              Text('Coming soon...', style: GoogleFonts.inter(color: theme.textSecondary)), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}
