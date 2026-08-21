import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class PSSScreen extends StatelessWidget { 
  const PSSScreen({super.key}); 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.pss; 
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: theme.textPrimary)), 
      body: ModuleBackground( 
        moduleKey: 'pss', 
        child: Center( 
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [ 
              Text('PSS Assessment', style: GoogleFonts.inter(fontSize: 24, color: theme.textPrimary, fontWeight: FontWeight.w600)), 
              const SizedBox(height: 16), 
              Text('Coming soon...', style: GoogleFonts.inter(color: theme.textSecondary)), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}
