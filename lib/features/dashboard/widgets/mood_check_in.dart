import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../../core/theme/module_themes.dart'; 
 
class MoodCheckIn extends StatelessWidget { 
  final int selected; 
  final Function(int) onSelect; 
  final ModuleTheme theme; 
 
  const MoodCheckIn({super.key, required this.selected, required this.onSelect, required 
this.theme}); 
 
  @override 
  Widget build(BuildContext context) { 
    const moods = [ 
      {'label': 'Low',   'score': 2,  'emoji': '😔'}, 
      {'label': 'Okay',  'score': 4,  'emoji': '😐'}, 
      {'label': 'Calm',  'score': 6,  'emoji': '😌'}, 
      {'label': 'Good',  'score': 8,  'emoji': '😊'}, 
      {'label': 'Great', 'score': 10, 'emoji': '🌟'}, 
    ]; 
 
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
      Text('How are you feeling?', style: GoogleFonts.inter(fontSize: 12, color: 
theme.textSecondary)), 
      const SizedBox(height: 10), 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: moods.map((m) { 
        final score  = m['score'] as int; 
        final isSel  = selected == score; 
        return GestureDetector( 
          onTap: () => onSelect(score), 
          child: AnimatedContainer( 
            duration: const Duration(milliseconds: 180), 
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), 
            decoration: BoxDecoration( 
              color: isSel ? theme.accentColor.withValues(alpha: 0.2) : theme.cardBg, 
              borderRadius: BorderRadius.circular(999), 
              border: Border.all(color: isSel ? theme.accentColor : theme.cardBorder, 
                  width: isSel ? 1.5 : 1), 
            ), 
            child: Row(mainAxisSize: MainAxisSize.min, children: [ 
              Text(m['emoji'] as String, style: const TextStyle(fontSize: 13)), 
              const SizedBox(width: 4), 
              Text(m['label'] as String, style: GoogleFonts.inter( 
                fontSize: 11, 
                color: isSel ? theme.accentColor : theme.textSecondary, 
                fontWeight: isSel ? FontWeight.w600 : FontWeight.w400, 
              )), 
            ]), 
          ), 
        ); 
      }).toList()), 
    ]); 
  } 
}
