import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/zen_tokens.dart';

class RecommendationCardWidget extends StatelessWidget {
  final int index;
  final String moduleKey;
  final String title;
  final String description;
  final int duration;
  final List<String> tags;

  const RecommendationCardWidget({
    super.key,
    required this.index,
    required this.moduleKey,
    required this.title,
    required this.description,
    required this.duration,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final isTopPick = index == 0;

    return Container(
      decoration: BoxDecoration(
        color: ZenTokens.zenSurfaceRaised,
        borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
        border: Border.all(
          color: isTopPick ? ZenTokens.zenPrimary.withValues(alpha: 0.2) : ZenTokens.zenBorderSoft.withValues(alpha: 0.55),
          width: isTopPick ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isTopPick ? ZenTokens.zenPrimary.withValues(alpha: 0.1) : ZenTokens.zenSurface,
                  borderRadius: BorderRadius.circular(ZenTokens.radiusZenFull),
                  border: isTopPick ? null : Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.4)),
                ),
                child: Text(
                  isTopPick ? '★ TOP PICK' : '#${index + 1}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    color: isTopPick ? ZenTokens.zenPrimary : ZenTokens.zenFgSubtle,
                  ),
                ),
              ),
              Text(
                '$duration min',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: ZenTokens.zenFgSubtle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ZenTokens.zenFg,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: ZenTokens.zenFgMuted,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ZenTokens.zenSurface,
                borderRadius: BorderRadius.circular(ZenTokens.radiusZenFull),
                border: Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.4)),
              ),
              child: Text(
                t,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: ZenTokens.zenFgSubtle,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 36,
            child: isTopPick
                ? FilledButton.icon(
                    onPressed: () => context.go('/$moduleKey'),
                    style: FilledButton.styleFrom(
                      backgroundColor: ZenTokens.zenPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl)),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: Text('Start', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
                  )
                : OutlinedButton.icon(
                    onPressed: () => context.go('/$moduleKey'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ZenTokens.zenFg,
                      backgroundColor: ZenTokens.zenSurface,
                      side: const BorderSide(color: ZenTokens.zenBorderSoft),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl)),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: Text('Start', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
          ),
        ],
      ),
    );
  }
}
