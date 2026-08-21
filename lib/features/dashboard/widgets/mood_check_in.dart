import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../../core/theme/app_theme.dart'; 
 
class _MoodOption { 
  final int score; 
  final String label; 
  final IconData icon; 
  final Color color; 
  final Color softColor; 
 
  const _MoodOption(this.score, this.label, this.icon, this.color, this.softColor); 
} 
 
const _moods = [ 
  _MoodOption(1, 'Low', Icons.cloud_rounded, Color(0xFF4796F0), Color(0xFFE8F2FD)), 
  _MoodOption(2, 'Okay', Icons.sentiment_satisfied_rounded, Color(0xFF379E8C), Color(0xFFE5F5F3)), 
  _MoodOption(3, 'Calm', Icons.auto_awesome_rounded, Color(0xFF7A53D0), Color(0xFFEDE8F9)), 
  _MoodOption(4, 'Good', Icons.wb_sunny_rounded, Color(0xFFF8BA20), Color(0xFFFEF8E8)), 
  _MoodOption(5, 'Great', Icons.star_rounded, Color(0xFFEC4F63), Color(0xFFFDE8EB)), 
]; 
 
class MoodCheckIn extends StatefulWidget { 
  final Function(int) onSelect; 
  const MoodCheckIn({super.key, required this.onSelect}); 
 
  @override 
  State<MoodCheckIn> createState() => _MoodCheckInState(); 
} 
 
class _MoodCheckInState extends State<MoodCheckIn> { 
  int? _selected; 
  bool _saved = false; 
 
  void _handleSelect(int score) { 
    setState(() { 
      _selected = score; 
      _saved = true; 
    }); 
    widget.onSelect(score); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Container( 
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), 
      decoration: BoxDecoration( 
        color: ZenTokens.surface.withValues(alpha: 0.9), 
        borderRadius: BorderRadius.circular(ZenTokens.radiusXl), 
        border: Border.all(color: ZenTokens.borderSoft.withValues(alpha: 0.55)), 
        boxShadow: [ 
          BoxShadow( 
            color: const Color(0xFF1E295A).withValues(alpha: 0.1), 
            blurRadius: 18, 
            offset: const Offset(0, 6), 
            spreadRadius: -14, 
          ) 
        ], 
      ), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [ 
          Text( 
            _saved ? 'Thanks for checking in' : 'How are you feeling?', 
            style: GoogleFonts.inter( 
              fontSize: 13, 
              color: ZenTokens.fgMuted, 
            ), 
          ), 
          const SizedBox(height: 12), 
          Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: _moods.map((mood) { 
              final isActive = _selected == mood.score; 
              return GestureDetector( 
                onTap: () => _handleSelect(mood.score), 
                behavior: HitTestBehavior.opaque, 
                child: AnimatedContainer( 
                  duration: const Duration(milliseconds: 200), 
                  curve: Curves.easeOut, 
                  height: 66.4, // min-h-[4.15rem] 
                  width: (MediaQuery.of(context).size.width - 64) / 5.2, // Rough fit for 5 items 
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), 
                  decoration: BoxDecoration( 
                    color: isActive ? mood.softColor : Colors.transparent, 
                    borderRadius: BorderRadius.circular(ZenTokens.radiusSm), 
                  ), 
                  child: Column( 
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [ 
                      Icon( 
                        mood.icon, 
                        color: isActive ? mood.color : ZenTokens.fgMuted, 
                        size: isActive ? 20 : 18, 
                      ), 
                      const SizedBox(height: 6), 
                      Text( 
                        mood.label, 
                        style: GoogleFonts.inter( 
                          fontSize: 11, // text-[0.6875rem] 
                          fontWeight: FontWeight.w500, 
                          color: isActive ? mood.color : ZenTokens.fgMuted, 
                        ), 
                      ), 
                    ], 
                  ), 
                ), 
              ); 
            }).toList(), 
          ), 
        ], 
      ), 
    ); 
  } 
}
