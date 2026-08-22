import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/api/api_client.dart';
import '../../../core/theme/zen_tokens.dart';
import 'recommendation_card_widget.dart';

class DynamicRecommendationsWidget extends StatefulWidget {
  const DynamicRecommendationsWidget({super.key});

  @override
  State<DynamicRecommendationsWidget> createState() => _DynamicRecommendationsWidgetState();
}

class _DynamicRecommendationsWidgetState extends State<DynamicRecommendationsWidget> {
  bool _isLoading = true;
  List<dynamic> _recommendations = [];
  Map<String, dynamic> _contextData = {};

  final List<Map<String, dynamic>> _defaultRecs = [
    {
      'module_id': 'mindfulness',
      'name': 'Mindfulness',
      'description': 'A gentle reset to find your center right now.',
      'duration_min': 5,
      'tags': ['Calm', 'Focus'],
    },
    {
      'module_id': 'breathing',
      'name': 'Box Breathing',
      'description': 'Steady your heart rate and ease tension.',
      'duration_min': 3,
      'tags': ['Quick', 'Reset'],
    },
    {
      'module_id': 'gratitude',
      'name': 'Gratitude',
      'description': 'Notice one good thing today.',
      'duration_min': 5,
      'tags': ['Reflect', 'Warmth'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    try {
      final c = await ApiClient.getInstance();
      final r = await c.get('/api/recommendations/today');
      if (mounted) {
        setState(() {
          _recommendations = r.data['recommendations'] ?? _defaultRecs;
          _contextData = r.data['context'] ?? {};
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _recommendations = _defaultRecs;
          _isLoading = false;
        });
      }
    }
  }

  String _getRoute(String moduleId) {
    switch (moduleId) {
      case 'mindfulness': return 'mindfulness';
      case 'breathing': return 'breathing';
      case 'gratitude': return 'gratitude';
      case 'journal_gratitude': return 'gratitude';
      case 'diary': return 'diary';
      case 'journal': return 'diary';
      case 'burst_it_out': return 'burst';
      case 'burst': return 'burst';
      case 'inner_compass': return 'inner-compass';
      case 'healing_garden': return 'healing-garden';
      case 'scribble': return 'scribble';
      case 'bubble': return 'bubble';
      case 'doodle': return 'doodle';
      default: return moduleId.replaceAll('_', '-');
    }
  }

  String _getDesc(String moduleId) {
    switch (moduleId) {
      case 'mindfulness': return 'A gentle reset to find your center right now.';
      case 'breathing': return 'Steady your heart rate and ease tension.';
      case 'gratitude': 
      case 'journal_gratitude': return 'Notice one good thing today.';
      case 'diary':
      case 'journal': return 'Write down your thoughts.';
      case 'burst_it_out':
      case 'burst': return 'Release pent up energy.';
      case 'inner_compass': return 'Navigate your feelings.';
      case 'healing_garden': return 'Tend to your inner garden.';
      default: return 'Take a moment for yourself.';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: ZenTokens.zenSurface,
          borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
          border: Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.55)),
        ),
        child: const Center(child: CircularProgressIndicator(color: ZenTokens.zenPrimary)),
      );
    }

    final displayRecs = _recommendations.take(3).toList();
    if (displayRecs.isEmpty) return const SizedBox.shrink();

    String contextLine = 'Personalised from your recent mood and time of day.';
    if (_contextData['time_of_day'] != null) {
      final tod = _contextData['time_of_day'].toString().replaceAll('_', ' ');
      contextLine = 'Personalised from your recent mood and time of day ($tod).';
    }

    return Container(
      decoration: BoxDecoration(
        color: ZenTokens.zenSurface,
        borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
        border: Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E295A).withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FOR YOU RIGHT NOW',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1 * 12,
              color: ZenTokens.zenSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            contextLine,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: ZenTokens.zenFgMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 640;
              final cards = displayRecs.asMap().entries.map((e) {
                final i = e.key;
                final rec = e.value as Map<String, dynamic>;
                final mId = rec['module_id'] as String? ?? 'mindfulness';
                final tagsRaw = rec['tags'];
                final tags = tagsRaw is List ? tagsRaw.map((e) => e.toString()).toList() : <String>[];
                return RecommendationCardWidget(
                  index: i,
                  moduleKey: _getRoute(mId),
                  title: rec['name'] as String? ?? mId,
                  description: rec['description'] ?? _getDesc(mId),
                  duration: (rec['duration_min'] as num?)?.toInt() ?? 5,
                  tags: tags,
                );
              }).toList();

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cards[0]),
                    if (cards.length > 1) ...[
                      const SizedBox(width: 16),
                      Expanded(child: cards[1]),
                    ],
                    if (cards.length > 2) ...[
                      const SizedBox(width: 16),
                      Expanded(child: cards[2]),
                    ],
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  cards[0],
                  if (cards.length > 1) ...[
                    const SizedBox(height: 16),
                    cards[1],
                  ],
                  if (cards.length > 2) ...[
                    const SizedBox(height: 16),
                    cards[2],
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Why these?',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: ZenTokens.zenFgMuted,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more_rounded, size: 16, color: ZenTokens.zenFgMuted),
            ],
          ),
        ],
      ),
    );
  }
}
