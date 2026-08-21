import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class DoodleScreen extends StatelessWidget { 
  const DoodleScreen({super.key}); 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.doodle; 
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: theme.textPrimary)), 
      body: ModuleBackground( 
        moduleKey: 'doodle', 
        child: Center( 
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [ 
              Text('Doodle Dreams', style: GoogleFonts.inter(fontSize: 24, color: theme.textPrimary, fontWeight: FontWeight.w600)), 
              const SizedBox(height: 16), 
              Text('Coming soon...', style: GoogleFonts.inter(color: theme.textSecondary)), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}
