import 'dart:ui';
import 'package:flutter/material.dart'; 
import '../../shared/widgets/module_background.dart'; 
import 'widgets/mood_check_in.dart'; 
import 'widgets/recommendation_card.dart'; 
import 'widgets/module_grid.dart'; 
import '../../core/theme/app_theme.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
 
class DashboardScreen extends StatefulWidget { 
  const DashboardScreen({super.key}); 
 
  @override 
  State<DashboardScreen> createState() => _DashboardScreenState(); 
} 
 
class _DashboardScreenState extends State<DashboardScreen> { 
  String _greeting() { 
    final hour = DateTime.now().hour; 
    if (hour < 12) return 'Good morning'; 
    if (hour < 18) return 'Good afternoon'; 
    return 'Good evening'; 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'home', 
        child: Stack( 
          children: [ 
            // Atmospheric glows 
            Positioned( 
              top: MediaQuery.of(context).size.height * 0.04, 
              left: -MediaQuery.of(context).size.width * 0.12, 
              child: Container( 
                width: 192, 
                height: 192, 
                decoration: BoxDecoration( 
                  shape: BoxShape.circle, 
                  color: ZenTokens.secondary.withValues(alpha: 0.12), 
                ), 
                child: BackdropFilter( 
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), 
                  child: Container(color: Colors.transparent), 
                ), 
              ), 
            ), 
            Positioned( 
              top: MediaQuery.of(context).size.height * 0.18, 
              right: -MediaQuery.of(context).size.width * 0.10, 
              child: Container( 
                width: 208, 
                height: 208, 
                decoration: BoxDecoration( 
                  shape: BoxShape.circle, 
                  color: ZenTokens.secondary.withValues(alpha: 0.3), 
                ), 
                child: BackdropFilter( 
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50), 
                  child: Container(color: Colors.transparent), 
                ), 
              ), 
            ), 
            // Content 
            SafeArea( 
              child: ListView( 
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 32), 
                children: [ 
                  Padding( 
                    padding: const EdgeInsets.symmetric(horizontal: 16), 
                    child: _buildGreeting(), 
                  ), 
                  const SizedBox(height: 36), 
                  Padding( 
                    padding: const EdgeInsets.symmetric(horizontal: 16), 
                    child: MoodCheckIn( 
                      onSelect: (score) {}, 
                    ), 
                  ), 
                  const SizedBox(height: 36), 
                  const Padding( 
                    padding: EdgeInsets.symmetric(horizontal: 16), 
                    child: RecommendationCard(), 
                  ), 
                  const SizedBox(height: 36), 
                  const ModuleGrid(), 
                  const SizedBox(height: 48), // Padding before bottom nav 
                ], 
              ), 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildGreeting() { 
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [ 
        Text( 
          '${_greeting()}, friend', 
          style: GoogleFonts.inter( 
            fontSize: 13, 
            fontWeight: FontWeight.w500, 
            letterSpacing: -0.3, 
            color: ZenTokens.secondary, 
          ), 
        ), 
        const SizedBox(height: 10), 
        Text( 
          "You're safe here.", 
          style: GoogleFonts.inter( 
            fontSize: 25, 
            fontWeight: FontWeight.w600, 
            letterSpacing: -0.75, 
            height: 1.16, 
            color: ZenTokens.fg, 
          ), 
        ), 
        const SizedBox(height: 10), 
        Text( 
          "Let's take a gentle step today.", 
          style: GoogleFonts.inter( 
            fontSize: 14, 
            height: 1.625, 
            color: ZenTokens.fgMuted, 
          ), 
        ), 
      ], 
    ); 
  } 
}
