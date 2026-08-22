import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';
import 'widgets/mood_check_in_widget.dart';
import 'widgets/recommendation_card_widget.dart';
import 'widgets/module_grid_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final displayName = auth.currentUser?.displayName ?? 'friend';

    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'home',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1320), // Matches max-w-[1320px]
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildGreeting(displayName),
                    const SizedBox(height: 36),
                    const MoodCheckInWidget(),
                    const SizedBox(height: 36),
                    _buildRecommendations(),
                    const SizedBox(height: 36),
                    const ModuleGridWidget(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(String displayName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getTimeGreeting()}, $displayName',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: ZenTokens.zenSecondary,
            letterSpacing: -0.01 * 15,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "You're safe here.",
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: ZenTokens.zenFg,
            letterSpacing: -0.03 * 32,
            height: 1.16,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Let's take a gentle step today.",
          style: GoogleFonts.inter(
            fontSize: 17,
            color: ZenTokens.zenFgMuted,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
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
            'Personalised from your recent mood and time of day.',
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
              if (isDesktop) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: RecommendationCardWidget(
                      index: 0,
                      moduleKey: 'mindfulness',
                      title: 'Mindfulness',
                      description: 'A gentle reset to find your center right now.',
                      duration: 5,
                      tags: ['Calm', 'Focus'],
                    )),
                    SizedBox(width: 16),
                    Expanded(child: RecommendationCardWidget(
                      index: 1,
                      moduleKey: 'breathing',
                      title: 'Box Breathing',
                      description: 'Steady your heart rate and ease tension.',
                      duration: 3,
                      tags: ['Quick', 'Reset'],
                    )),
                    SizedBox(width: 16),
                    Expanded(child: RecommendationCardWidget(
                      index: 2,
                      moduleKey: 'gratitude',
                      title: 'Gratitude',
                      description: 'Notice one good thing today.',
                      duration: 5,
                      tags: ['Reflect', 'Warmth'],
                    )),
                  ],
                );
              }
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RecommendationCardWidget(
                    index: 0,
                    moduleKey: 'mindfulness',
                    title: 'Mindfulness',
                    description: 'A gentle reset to find your center right now.',
                    duration: 5,
                    tags: ['Calm', 'Focus'],
                  ),
                  SizedBox(height: 16),
                  RecommendationCardWidget(
                    index: 1,
                    moduleKey: 'breathing',
                    title: 'Box Breathing',
                    description: 'Steady your heart rate and ease tension.',
                    duration: 3,
                    tags: ['Quick', 'Reset'],
                  ),
                  SizedBox(height: 16),
                  RecommendationCardWidget(
                    index: 2,
                    moduleKey: 'gratitude',
                    title: 'Gratitude',
                    description: 'Notice one good thing today.',
                    duration: 5,
                    tags: ['Reflect', 'Warmth'],
                  ),
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
