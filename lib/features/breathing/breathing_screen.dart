import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';
import 'widgets/breathing_player_widget.dart';
import 'widgets/pattern_motif_visual.dart';

class BreathingPattern {
  final String id;
  final String name;
  final String description;
  final List<int> steps; // Inhale, hold, exhale, hold
  final int defaultMinutes;
  final String difficulty;

  const BreathingPattern(
    this.id,
    this.name,
    this.description,
    this.steps,
    this.defaultMinutes,
    this.difficulty,
  );
}

const List<BreathingPattern> _patterns = [
  BreathingPattern(
    'box', 
    'Box Breathing', 
    'Steady calming rhythm', 
    [4, 4, 4, 4], 
    3, 
    'Beginner'
  ),
  BreathingPattern(
    '478', 
    '4-7-8 Breathing', 
    'Deep slow exhale', 
    [4, 7, 8], 
    3, 
    'Intermediate'
  ),
  BreathingPattern(
    'coherent', 
    'Coherent Breathing', 
    'Slow and even 5-5 rhythm', 
    [5, 5], 
    5, 
    'Intermediate'
  ),
];

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  BreathingPattern? _selectedPattern;

  void _startPattern(BreathingPattern pattern) {
    setState(() {
      _selectedPattern = pattern;
    });
  }

  void _closePlayer() {
    setState(() {
      _selectedPattern = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'breathing',
        child: Stack(
          children: [
            // Dashboard Layout
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildQuickSession(),
                    const SizedBox(height: 48),
                    _buildPracticeGrid(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // Full Screen Player Overlay
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedPattern != null
                  ? BreathingPlayerWidget(
                      key: ValueKey(_selectedPattern!.id),
                      pattern: _selectedPattern!,
                      onClose: _closePlayer,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => context.go('/dashboard'),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: ZenTokens.zenFgMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Breathe',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ZenTokens.zenFgMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Breathing',
                style: GoogleFonts.lora(
                  fontSize: 42,
                  fontWeight: FontWeight.w600,
                  color: ZenTokens.zenFg,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find your rhythm. 🤍',
                style: GoogleFonts.lora(
                  fontSize: 20,
                  color: ZenTokens.zenFg,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'A few slow breaths can change the way this moment feels.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: ZenTokens.zenFgMuted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        // Panda Avatar Placeholder (Using an asset if available, else a colored circle)
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1E293B),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/panda/idle.png', // Or whatever valid panda asset exists
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.favorite_rounded,
                color: Colors.pinkAccent,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSession() {
    final pattern = _patterns[0]; // Box Breathing
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFD3DFE2).withValues(alpha: 0.8), // Sage/blueish background from screenshot
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E295A).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 500;
          
          final content = [
            const PatternMotifVisual(size: 80, isActive: true),
            const SizedBox(width: 24, height: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Text(
                    'QUICK SESSION FOR YOU',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: const Color(0xFF6366F1), // Indigo accent
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pattern.name,
                    style: GoogleFonts.lora(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: ZenTokens.zenFg,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pattern.steps.join(' · ')}  ·  ${pattern.defaultMinutes} min',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: ZenTokens.zenFgMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24, height: 24),
            FilledButton(
              onPressed: () => _startPattern(pattern),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6), // Blue button
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Start',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ];

          if (isDesktop) {
            return Row(children: content);
          } else {
            return Column(
              children: [
                content[0], // Icon
                content[1], // Spacer
                content[2], // Text Column
                content[3], // Spacer
                content[4], // Button
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPracticeGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a practice',
          style: GoogleFonts.lora(
            fontSize: 24,
            color: ZenTokens.zenFg,
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 700;
            if (isDesktop) {
              return Row(
                children: _patterns.map((pattern) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: pattern != _patterns.last ? 16.0 : 0,
                      ),
                      child: _buildPracticeCard(pattern),
                    ),
                  );
                }).toList(),
              );
            }
            
            return Column(
              children: _patterns.map((pattern) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildPracticeCard(pattern),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPracticeCard(BreathingPattern pattern) {
    return GestureDetector(
      onTap: () => _startPattern(pattern),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.9), // Lighter soft blue-gray
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E295A).withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: PatternMotifVisual(size: 64, isActive: false),
            ),
            const SizedBox(height: 24),
            Text(
              pattern.name,
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: ZenTokens.zenFg,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              pattern.description,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: ZenTokens.zenFgMuted,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              pattern.steps.join(' · '),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6366F1), // Indigo accent
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '~${pattern.defaultMinutes} min',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ZenTokens.zenFgMuted,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pattern.difficulty,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: ZenTokens.zenFgMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Start',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF3B82F6)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
