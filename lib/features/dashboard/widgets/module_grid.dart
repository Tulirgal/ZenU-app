import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../../core/theme/module_themes.dart'; 
 
class ModuleGrid extends StatefulWidget { 
  final ModuleTheme theme; 
  const ModuleGrid({super.key, required this.theme}); 
 
  @override 
  State<ModuleGrid> createState() => _ModuleGridState(); 
} 
 
class _ModuleGridState extends State<ModuleGrid> { 
  bool _showAll = false; 
 
  static const _modules = [ 
    {'id': 'breathing',         'name': 'Zen Breath Zone',   'desc': 'A gentle rhythm for your nervous system.', 'route': '/breathing',      'emoji': '🌬'}, 
    {'id': 'mindfulness',       'name': 'Meditate',          'desc': 'Stillness in a few quiet minutes.',         'route': '/mindfulness',    'emoji': '🧘'}, 
    {'id': 'chatbot_seviyan',   'name': 'Seviyan',           'desc': 'Talk it through with a calm companion.',    'route': '/chat',           'emoji': '💬'}, 
    {'id': 'diary',             'name': 'My Diary',          'desc': 'Reflect on your day.',                     'route': '/diary',          'emoji': '📖'}, 
    {'id': 'journal_gratitude', 'name': 'Gratitude Journal', 'desc': 'Count your blessings.',                    'route': '/gratitude',      'emoji': '🌸'}, 
    {'id': 'doodle_dreams',     'name': 'Doodle Dreams',     'desc': 'Soft patterns when words feel heavy.',     'route': '/doodle',         'emoji': '🎨'}, 
    {'id': 'bubble_canvas',     'name': 'Bubble Canvas',     'desc': 'Pop stress away.',                         'route': '/bubble',         'emoji': '🫧'}, 
    {'id': 'burst_it_out',      'name': 'Burst It Out',      'desc': 'Release when energy builds.',              'route': '/burst',          'emoji': '💥'}, 
    {'id': 'scribble_pad',      'name': 'Scribble Pad',      'desc': 'Express freely.',                          'route': '/scribble',       'emoji': '✏'}, 
    {'id': 'healing_garden',    'name': 'Healing Garden',    'desc': 'Grow your streak.',                        'route': '/healing-garden', 'emoji': '🌿'}, 
    {'id': 'inner_compass',     'name': 'Inner Compass',     'desc': 'Find your direction.',                     'route': '/inner-compass',  'emoji': '🧭'}, 
  ]; 
 
  static const _initial = 6; 
 
  @override 
  Widget build(BuildContext context) { 
    final visible = _showAll ? _modules : _modules.take(_initial).toList(); 
    return Column(children: [ 
      GridView.builder( 
        shrinkWrap: true, 
        physics: const NeverScrollableScrollPhysics(), 
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( 
          crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.6, 
        ), 
        itemCount: visible.length, 
        itemBuilder: (_, i) => _ModuleTile(m: visible[i], theme: widget.theme) 
            .animate().fadeIn(delay: Duration(milliseconds: i * 35)), 
      ), 
      const SizedBox(height: 10), 
      if (!_showAll && _modules.length > _initial) 
        TextButton.icon( 
          onPressed: () => setState(() => _showAll = true), 
          icon: Icon(Icons.expand_more_rounded, color: widget.theme.textSecondary, size: 16), 
          label: Text('Show ${_modules.length - _initial} more', 
            style: GoogleFonts.inter(color: widget.theme.textSecondary, fontSize: 13)), 
        ) 
      else if (_showAll) 
        TextButton( 
          onPressed: () => setState(() => _showAll = false), 
          child: Text('Show less', 
            style: GoogleFonts.inter(color: widget.theme.textSecondary, fontSize: 13)), 
        ), 
    ]); 
  } 
} 
 
class _ModuleTile extends StatelessWidget { 
  final Map<String, String> m; 
  final ModuleTheme theme; 
  const _ModuleTile({required this.m, required this.theme}); 
 
  @override 
  Widget build(BuildContext context) => GestureDetector( 
    onTap: () => context.push(m['route']!), 
    child: Container( 
      padding: const EdgeInsets.all(13), 
      decoration: BoxDecoration( 
        color: theme.cardBg, 
        borderRadius: BorderRadius.circular(14), 
        border: Border.all(color: theme.cardBorder), 
      ), 
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [ 
          Text(m['emoji']!, style: const TextStyle(fontSize: 22)), 
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
            Text(m['name']!, style: GoogleFonts.inter( 
              fontSize: 13, fontWeight: FontWeight.w600, color: theme.textPrimary, 
            )), 
            const SizedBox(height: 2), 
            Text(m['desc']!, style: GoogleFonts.inter(fontSize: 10, color: theme.textSecondary), 
              maxLines: 2, overflow: TextOverflow.ellipsis), 
          ]), 
        ]), 
    ), 
  ); 
}
