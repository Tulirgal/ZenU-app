import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../../core/theme/app_theme.dart'; 
 
class _ModuleData { 
  final String id; 
  final String name; 
  final String description; 
  final String route; 
  final String emoji; 
 
  const _ModuleData({ 
    required this.id, 
    required this.name, 
    required this.description, 
    required this.route, 
    required this.emoji, 
  }); 
} 
 
const _modules = [ 
  _ModuleData(id: 'breathing', name: 'Breathing', description: 'Box, 4-7-8, and deep calm.', route: '/breathing', emoji: '🌬️'), 
  _ModuleData(id: 'mindfulness', name: 'Mindfulness', description: 'Quick grounding exercises.', route: '/mindfulness', emoji: '🧘'), 
  _ModuleData(id: 'diary', name: 'Journal', description: 'Free-write your thoughts.', route: '/diary', emoji: '📝'), 
  _ModuleData(id: 'gratitude', name: 'Gratitude', description: 'Tiny thankful moments.', route: '/gratitude', emoji: '✨'), 
  _ModuleData(id: 'bubble', name: 'Bubbles', description: 'Pop your worries away.', route: '/bubble', emoji: '🫧'), 
  _ModuleData(id: 'burst', name: 'Burst', description: 'Release built-up tension.', route: '/burst', emoji: '🔥'), 
  _ModuleData(id: 'scribble', name: 'Scribble', description: 'Scribble it all out.', route: '/scribble', emoji: '✏️'), 
  _ModuleData(id: 'doodle', name: 'Doodle', description: 'Draw to relax.', route: '/doodle', emoji: '🎨'), 
  _ModuleData(id: 'healing_garden', name: 'Garden', description: 'Grow your streak.', route: '/healing-garden', emoji: '🌱'), 
  _ModuleData(id: 'inner_compass', name: 'Compass', description: 'Find your emotional north.', route: '/inner-compass', emoji: '🧭'), 
]; 
 
class ModuleGrid extends StatefulWidget { 
  const ModuleGrid({super.key}); 
 
  @override 
  State<ModuleGrid> createState() => _ModuleGridState(); 
} 
 
class _ModuleGridState extends State<ModuleGrid> { 
  bool _showAll = false; 
  static const int _initialShow = 6; 
 
  @override 
  Widget build(BuildContext context) { 
    final isDesktop = MediaQuery.of(context).size.width >= 768; 
    final visibleModules = _showAll ? _modules : _modules.take(_initialShow).toList(); 
 
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [ 
        Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 16), 
          child: Text( 
            'Your wellness space', 
            style: GoogleFonts.inter( 
              fontSize: 15, 
              fontWeight: FontWeight.w600, 
              color: ZenTokens.fg, 
            ), 
          ), 
        ), 
        const SizedBox(height: 16), 
        if (isDesktop || _showAll) 
          Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 16), 
            child: Wrap( 
              spacing: 12, 
              runSpacing: 12, 
              children: visibleModules.map((m) => SizedBox( 
                width: isDesktop ? 160 : (MediaQuery.of(context).size.width - 44) / 2, 
                child: _buildCard(context, m, isDesktop), 
              )).toList(), 
            ), 
          ) 
        else 
          SingleChildScrollView( 
            scrollDirection: Axis.horizontal, 
            padding: const EdgeInsets.symmetric(horizontal: 16), 
            child: Row( 
              children: visibleModules.map((m) => Padding( 
                padding: const EdgeInsets.only(right: 12), 
                child: SizedBox( 
                  width: 132, 
                  child: _buildCard(context, m, isDesktop), 
                ), 
              )).toList(), 
            ), 
          ), 
        if (!_showAll && _modules.length > _initialShow) 
          Padding( 
            padding: const EdgeInsets.only(top: 16, bottom: 8), 
            child: Center( 
              child: GestureDetector( 
                onTap: () => setState(() => _showAll = true), 
                behavior: HitTestBehavior.opaque, 
                child: Container( 
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
                  decoration: BoxDecoration( 
                    color: ZenTokens.surface, 
                    borderRadius: BorderRadius.circular(ZenTokens.radiusXl), 
                    border: Border.all(color: ZenTokens.borderSoft.withValues(alpha: 0.55)), 
                  ), 
                  child: Row( 
                    mainAxisSize: MainAxisSize.min, 
                    children: [ 
                      Text( 
                        'Show ${_modules.length - _initialShow} more modules', 
                        style: GoogleFonts.inter( 
                          fontSize: 14, 
                          color: ZenTokens.fgMuted, 
                        ), 
                      ), 
                      const SizedBox(width: 8), 
                      const Icon(Icons.expand_more_rounded, size: 16, color: ZenTokens.fgMuted), 
                    ], 
                  ), 
                ), 
              ), 
            ), 
          ), 
      ], 
    ); 
  } 
 
  Widget _buildCard(BuildContext context, _ModuleData module, bool isDesktop) { 
    return GestureDetector( 
      onTap: () => context.go(module.route), 
      child: Container( 
        height: isDesktop ? 184 : 136, 
        padding: const EdgeInsets.all(14), 
        decoration: BoxDecoration( 
          color: ZenTokens.surface, 
          borderRadius: BorderRadius.circular(ZenTokens.radiusXl), 
          border: Border.all(color: ZenTokens.borderSoft.withValues(alpha: 0.6)), 
        ), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [ 
            Text( 
              module.name, 
              style: GoogleFonts.inter( 
                fontSize: 13, 
                fontWeight: FontWeight.w600, 
                color: ZenTokens.fg, 
                height: 1.2, 
              ), 
            ), 
            const SizedBox(height: 4), 
            Expanded( 
              child: Text( 
                module.description, 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis, 
                style: GoogleFonts.inter( 
                  fontSize: 12, 
                  color: ZenTokens.fgMuted, 
                ), 
              ), 
            ), 
            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              crossAxisAlignment: CrossAxisAlignment.end, 
              children: [ 
                Container( 
                  width: 28, 
                  height: 28, 
                  decoration: BoxDecoration( 
                    color: ZenTokens.bgSubtle.withValues(alpha: 0.9), 
                    shape: BoxShape.circle, 
                  ), 
                  child: const Icon(Icons.arrow_forward_rounded, size: 14, color: ZenTokens.fgMuted), 
                ), 
                Text( 
                  module.emoji, 
                  style: const TextStyle(fontSize: 24), 
                ), 
              ], 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
}
