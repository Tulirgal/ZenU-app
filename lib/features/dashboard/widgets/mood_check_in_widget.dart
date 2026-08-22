import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/zen_tokens.dart';

class MoodCheckInWidget extends StatefulWidget {
  const MoodCheckInWidget({super.key});

  @override
  State<MoodCheckInWidget> createState() => _MoodCheckInWidgetState();
}

class _MoodCheckInWidgetState extends State<MoodCheckInWidget> {
  int? _selectedScore;

  final List<Map<String, dynamic>> _moods = [
    {
      'score': 1,
      'label': 'Low',
      'icon': Icons.cloud_rounded,
      'color': ZenTokens.zenEmotionSadness,
      'soft': ZenTokens.zenEmotionSadnessSoft,
    },
    {
      'score': 2,
      'label': 'Okay',
      'icon': Icons.sentiment_neutral_rounded,
      'color': ZenTokens.zenEmotionOkay,
      'soft': ZenTokens.zenEmotionOkaySoft,
    },
    {
      'score': 3,
      'label': 'Calm',
      'icon': Icons.auto_awesome_rounded,
      'color': ZenTokens.zenEmotionCalm,
      'soft': ZenTokens.zenEmotionCalmSoft,
    },
    {
      'score': 4,
      'label': 'Good',
      'icon': Icons.light_mode_rounded,
      'color': ZenTokens.zenEmotionJoy,
      'soft': ZenTokens.zenEmotionJoySoft,
    },
    {
      'score': 5,
      'label': 'Great',
      'icon': Icons.star_rounded,
      'color': ZenTokens.zenEmotionGreat,
      'soft': ZenTokens.zenEmotionGreatSoft,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ZenTokens.zenSurface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
        border: Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E295A).withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedScore != null ? 'Thanks for checking in' : 'How are you feeling?',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: ZenTokens.zenFgMuted,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _moods.map((mood) {
              final score = mood['score'] as int;
              final isActive = _selectedScore == score;
              final color = mood['color'] as Color;
              final soft = mood['soft'] as Color;
              final icon = mood['icon'] as IconData;
              final label = mood['label'] as String;

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedScore = score),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isActive ? soft : Colors.transparent,
                      borderRadius: BorderRadius.circular(ZenTokens.radiusZenLg),
                      border: Border.all(
                        color: isActive ? Colors.transparent : ZenTokens.zenBorderSoft.withValues(alpha: 0.7),
                      ),
                      boxShadow: isActive ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: 22,
                          offset: const Offset(0, 8),
                        )
                      ] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: isActive ? color : ZenTokens.zenFgMuted,
                          size: 20,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isActive ? color : ZenTokens.zenFgMuted,
                          ),
                        ),
                      ],
                    ),
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
