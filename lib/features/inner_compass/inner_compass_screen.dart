import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';
import 'emotion_data.dart';

class InnerCompassScreen extends StatefulWidget {
  const InnerCompassScreen({super.key});

  @override
  State<InnerCompassScreen> createState() => _InnerCompassScreenState();
}

class _InnerCompassScreenState extends State<InnerCompassScreen> {
  int _viewState = 0; // 0 = primary, 1 = secondary, 2 = tertiary, 3 = complete
  String? _selectedPrimary;
  String? _selectedSecondary;
  String? _selectedTertiary;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().trackEngagement('inner_compass', 'opened');
    });
  }

  void _onPrimarySelect(String primary) {
    setState(() {
      _selectedPrimary = primary;
      _selectedSecondary = null;
      _selectedTertiary = null;
      _viewState = 1;
    });
  }

  void _onSecondarySelect(String secondary) {
    setState(() {
      _selectedSecondary = secondary;
      _selectedTertiary = null;
      _viewState = 2;
    });
  }

  void _onTertiarySelect(String tertiary) {
    setState(() {
      _selectedTertiary = tertiary;
      _viewState = 3;
    });
    context.read<AuthService>().trackEngagement('inner_compass', 'completed');
  }

  void _onBack() {
    if (_viewState == 3) {
      setState(() {
        _viewState = 2;
        _selectedTertiary = null;
      });
    } else if (_viewState == 2) {
      setState(() {
        _viewState = 1;
        _selectedSecondary = null;
      });
    } else if (_viewState == 1) {
      setState(() {
        _viewState = 0;
        _selectedPrimary = null;
      });
    }
  }

  void _onReset() {
    setState(() {
      _viewState = 0;
      _selectedPrimary = null;
      _selectedSecondary = null;
      _selectedTertiary = null;
    });
  }

  Color _getPrimaryColor(String? emotion) {
    switch (emotion) {
      case 'angry':
        return const Color(0xFFEF4444); // Red
      case 'disgusted':
        return const Color(0xFF10B981); // Green
      case 'sad':
        return const Color(0xFF3B82F6); // Blue
      case 'happy':
        return const Color(0xFFF59E0B); // Amber
      case 'surprised':
        return const Color(0xFF8B5CF6); // Purple
      case 'fearful':
        return const Color(0xFFF97316); // Orange
      case 'bad':
        return const Color(0xFF64748B); // Slate
      default:
        return ZenTokens.zenPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'inner_compass',
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _buildCurrentView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ZenTokens.zenFg),
                onPressed: () => context.go('/dashboard'),
              ),
              Text(
                'Inner Compass',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _selectedPrimary != null ? _getPrimaryColor(_selectedPrimary) : ZenTokens.zenFgMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _viewState != 3
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _viewState == 0 ? 'How are you feeling right now?' : 'What feels closest?',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: ZenTokens.zenFg,
                          letterSpacing: -0.02 * 28,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _viewState == 0
                            ? "There's no right or wrong. Just be real with yourself."
                            : "Take your time - choose what resonates most.",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: ZenTokens.zenFgMuted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_viewState) {
      case 0:
        return _buildPrimaryView();
      case 1:
        return _buildSecondaryView();
      case 2:
        return _buildTertiaryView();
      case 3:
        return _buildResultView();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPrimaryView() {
    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(24),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: emotions.keys.map((primary) {
          final color = _getPrimaryColor(primary);
          return _buildCoreEmotionCircle(
            label: primary,
            color: color,
            onTap: () => _onPrimarySelect(primary),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCoreEmotionCircle({required String label, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.85),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryView() {
    if (_selectedPrimary == null) return const SizedBox.shrink();
    final primaryMap = emotions[_selectedPrimary!] as Map<String, dynamic>;
    return _buildListOptions(
      key: 1,
      options: primaryMap.keys.toList(),
      onSelect: _onSecondarySelect,
    );
  }

  Widget _buildTertiaryView() {
    if (_selectedPrimary == null || _selectedSecondary == null) return const SizedBox.shrink();
    final primaryMap = emotions[_selectedPrimary!] as Map<String, dynamic>;
    final tertiaryList = primaryMap[_selectedSecondary!] as List<dynamic>;
    return _buildListOptions(
      key: 2,
      options: tertiaryList.map((e) => e.toString()).toList(),
      onSelect: _onTertiarySelect,
    );
  }

  Widget _buildListOptions({required int key, required List<String> options, required Function(String) onSelect}) {
    final color = _getPrimaryColor(_selectedPrimary);
    return SingleChildScrollView(
      key: ValueKey(key),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: _onBack,
            icon: const Icon(Icons.arrow_back_rounded, size: 16),
            label: const Text('back'),
            style: TextButton.styleFrom(
              foregroundColor: ZenTokens.zenFgMuted,
              textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: options.map((option) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelect(option),
                  borderRadius: BorderRadius.circular(ZenTokens.radiusZenLg),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: ZenTokens.zenSurface,
                      border: Border.all(color: color.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(ZenTokens.radiusZenLg),
                    ),
                    child: Text(
                      option,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ZenTokens.zenFg,
                      ),
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

  Widget _buildResultView() {
    if (_selectedTertiary == null) return const SizedBox.shrink();
    final data = tertiaryData[_selectedTertiary!] as Map<String, dynamic>?;
    if (data == null) return const SizedBox.shrink();

    final color = _getPrimaryColor(_selectedPrimary);

    return SingleChildScrollView(
      key: const ValueKey(3),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('back'),
              style: TextButton.styleFrom(
                foregroundColor: ZenTokens.zenFgMuted,
                textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
            ),
            child: const Center(
              child: Text(
                '🐼',
                style: TextStyle(fontSize: 64),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            '${_selectedPrimary!} • ${_selectedSecondary!} • ${_selectedTertiary!}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          
          Container(
            height: 2,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 16),
            color: color.withValues(alpha: 0.7),
          ),

          Text(
            "It's okay to feel ${_selectedTertiary!}.",
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: ZenTokens.zenFg,
              letterSpacing: -0.02 * 32,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          Text(
            "You're not alone, and this feeling will pass. Let's find what helps you right now.",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: ZenTokens.zenFgMuted,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ZenTokens.zenSurface,
              border: Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.55)),
              borderRadius: BorderRadius.circular(ZenTokens.radiusZen2xl),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['affirmation'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: ZenTokens.zenFg,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  data['tip'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: ZenTokens.zenFgMuted,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'What might help right now',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
                color: color,
              ).copyWith(textBaseline: TextBaseline.alphabetic),
            ),
          ),
          const SizedBox(height: 16),
          
          Column(
            children: (data['modules'] as List<dynamic>).map((mod) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => context.push(mod['route'] as String),
                    borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: ZenTokens.zenSurface,
                        border: Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.7)),
                        borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
                      ),
                      child: Row(
                        children: [
                          Text(mod['emoji'] as String, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              mod['name'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ZenTokens.zenFg,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_rounded, color: color, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          TextButton(
            onPressed: _onReset,
            style: TextButton.styleFrom(
              foregroundColor: ZenTokens.zenFgMuted,
            ),
            child: const Text('Check in again'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
