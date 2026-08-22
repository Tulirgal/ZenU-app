import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';
import 'widgets/mood_check_in_widget.dart';
import 'widgets/recommendation_card_widget.dart';
import 'widgets/dynamic_recommendations_widget.dart';
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
                    const DynamicRecommendationsWidget(),
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
}
