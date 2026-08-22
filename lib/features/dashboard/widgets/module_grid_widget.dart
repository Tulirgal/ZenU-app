import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/zen_tokens.dart';

class ModuleGridWidget extends StatefulWidget {
  const ModuleGridWidget({super.key});

  @override
  State<ModuleGridWidget> createState() => _ModuleGridWidgetState();
}

class _ModuleGridWidgetState extends State<ModuleGridWidget> {
  bool _showAll = false;

  final List<Map<String, dynamic>> _modules = [
    {'id': 'breathing', 'name': 'Breathing', 'desc': 'Steady your heart rate and center your focus.', 'icon': '🌬️', 'route': '/breathing'},
    {'id': 'mindfulness', 'name': 'Mindfulness', 'desc': 'Anchor yourself in the present moment.', 'icon': '🧠', 'route': '/mindfulness'},
    {'id': 'diary', 'name': 'My Diary', 'desc': 'A safe space to untangle your thoughts.', 'icon': '📖', 'route': '/diary'},
    {'id': 'journal_gratitude', 'name': 'Gratitude', 'desc': 'Find one good thing today.', 'icon': '☀️', 'route': '/gratitude'},
    {'id': 'doodle_dreams', 'name': 'Doodle Dreams', 'desc': 'Abstract away the stress with colors.', 'icon': '🎨', 'route': '/doodle'},
    {'id': 'bubble_canvas', 'name': 'Bubble Canvas', 'desc': 'Pop the tension away.', 'icon': '🫧', 'route': '/bubble'},
    {'id': 'burst_it_out', 'name': 'Burst it out', 'desc': 'Release built-up energy.', 'icon': '💥', 'route': '/burst'},
    {'id': 'scribble_pad', 'name': 'Scribble Pad', 'desc': 'Let out the chaos on paper.', 'icon': '✍️', 'route': '/scribble'},
    {'id': 'chatbot_seviyan', 'name': 'Seviyan Chat', 'desc': 'A companion who listens without judgment.', 'icon': '💬', 'route': '/chat'},
    {'id': 'healing_garden', 'name': 'Healing Garden', 'desc': 'Watch your tiny seeds grow over time.', 'icon': '🌱', 'route': '/healing-garden'},
    {'id': 'inner_compass', 'name': 'Inner Compass', 'desc': 'Reflect on your values and direction.', 'icon': '🧭', 'route': '/inner-compass'},
  ];

  @override
  Widget build(BuildContext context) {
    final visibleModules = _showAll ? _modules : _modules.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your wellness space',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ZenTokens.zenFg,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: visibleModules.length,
          itemBuilder: (context, index) {
            final mod = visibleModules[index];
            return _buildModuleCard(context, mod);
          },
        ),
        const SizedBox(height: 24),
        Center(
          child: _showAll
              ? TextButton.icon(
                  onPressed: () => setState(() => _showAll = false),
                  icon: const Icon(Icons.expand_less_rounded, color: ZenTokens.zenFgSubtle),
                  label: Text('Show less', style: GoogleFonts.inter(color: ZenTokens.zenFgSubtle)),
                )
              : OutlinedButton.icon(
                  onPressed: () => setState(() => _showAll = true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ZenTokens.zenFg,
                    backgroundColor: ZenTokens.zenSurface,
                    side: const BorderSide(color: ZenTokens.zenBorderSoft),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl)),
                  ),
                  icon: const Icon(Icons.expand_more_rounded, size: 16),
                  label: Text('Show ${_modules.length - 6} more modules', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
                ),
        ),
      ],
    );
  }

  Widget _buildModuleCard(BuildContext context, Map<String, dynamic> mod) {
    return GestureDetector(
      onTap: () => context.go(mod['route'] as String),
      child: Container(
        decoration: BoxDecoration(
          color: ZenTokens.zenSurface,
          borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
          border: Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.6)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mod['name'] as String,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ZenTokens.zenFg,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                mod['desc'] as String,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: ZenTokens.zenFgMuted,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: ZenTokens.zenBgSubtle.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, size: 14, color: ZenTokens.zenFgMuted),
                ),
                Text(
                  mod['icon'] as String,
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
