import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../../core/theme/module_themes.dart'; 
 
const _routes = { 
  'breathing':         '/breathing', 
  'mindfulness':       '/mindfulness', 
  'diary':             '/diary', 
  'journal_gratitude': '/gratitude', 
  'doodle_dreams':     '/doodle', 
  'bubble_canvas':     '/bubble', 
  'burst_it_out':      '/burst', 
  'scribble_pad':      '/scribble', 
  'chatbot_seviyan':   '/chat', 
  'healing_garden':    '/healing-garden', 
  'inner_compass':     '/inner-compass', 
}; 
 
const _emojis = { 
  'breathing':         '🌬', 
  'mindfulness':       '🧘', 
  'diary':             '📖', 
  'journal_gratitude': '🌸', 
  'doodle_dreams':     '🎨', 
  'bubble_canvas':     '🫧', 
  'burst_it_out':      '💥', 
  'scribble_pad':      '✏', 
  'chatbot_seviyan':   '💬', 
  'healing_garden':    '🌿', 
  'inner_compass':     '🧭', 
}; 
 
class RecommendationCard extends StatelessWidget { 
  final Map<String, dynamic> rec; 
  final int rank; 
  final ModuleTheme theme; 
 
  const RecommendationCard({super.key, required this.rec, required this.rank, required 
this.theme}); 
 
  @override 
  Widget build(BuildContext context) { 
    final id    = rec['module_id'] as String? ?? ''; 
    final name  = rec['name']       as String? ?? ''; 
    final dur   = rec['duration_min'] as int? ?? 5; 
    final tags  = List<String>.from(rec['tags'] ?? []); 
    final route = _routes[id] ?? '/dashboard'; 
    final emoji = _emojis[id] ?? '✨'; 
    final isTop = rank == 0; 
 
    return GestureDetector( 
      onTap: () => context.push(route), 
      child: Container( 
        padding: const EdgeInsets.all(14), 
        decoration: BoxDecoration( 
          color: theme.cardBg, 
          borderRadius: BorderRadius.circular(14), 
          border: Border.all( 
            color: isTop ? theme.accentColor.withValues(alpha: 0.5) : theme.cardBorder, 
            width: isTop ? 1.5 : 1, 
          ), 
        ), 
        child: Row(children: [ 
          Text(emoji, style: const TextStyle(fontSize: 26)), 
          const SizedBox(width: 12), 
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
            Row(children: [ 
              Container( 
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), 
                decoration: BoxDecoration( 
                  color: isTop ? theme.accentColor.withValues(alpha: 0.15) : theme.cardBg, 
                  borderRadius: BorderRadius.circular(999), 
                  border: isTop ? null : Border.all(color: theme.cardBorder), 
                ), 
                child: Text(isTop ? '✦ Top pick' : '#${rank + 1}', 
                  style: GoogleFonts.inter( 
                    fontSize: 10, color: isTop ? theme.accentColor : theme.textSecondary, 
                    fontWeight: FontWeight.w600, 
                  )), 
              ), 
              const Spacer(), 
              Text('$dur min', style: GoogleFonts.inter(fontSize: 11, color: theme.textSecondary)), 
            ]), 
            const SizedBox(height: 4), 
            Text(name, style: GoogleFonts.inter( 
              fontSize: 15, fontWeight: FontWeight.w600, color: theme.textPrimary, 
            )), 
            if (tags.isNotEmpty) 
              Padding( 
                padding: const EdgeInsets.only(top: 3), 
                child: Text(tags.take(2).join(' · '), 
                  style: GoogleFonts.inter(fontSize: 11, color: theme.textSecondary)), 
              ), 
          ])), 
          const SizedBox(width: 8), 
          Icon(Icons.arrow_forward_ios_rounded, size: 13, color: theme.textSecondary), 
        ]), 
      ), 
    ); 
  } 
}
