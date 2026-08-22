import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/auth_service.dart';
import '../../../core/theme/zen_tokens.dart';
import '../../../shared/widgets/module_background.dart';
import '../breathing_screen.dart'; // For BreathingPattern class

class BreathingPlayerWidget extends StatefulWidget {
  final BreathingPattern pattern;
  final VoidCallback onClose;

  const BreathingPlayerWidget({
    super.key,
    required this.pattern,
    required this.onClose,
  });

  @override
  State<BreathingPlayerWidget> createState() => _BreathingPlayerWidgetState();
}

class _BreathingPlayerWidgetState extends State<BreathingPlayerWidget> with TickerProviderStateMixin {
  late final AnimationController _orbController;
  late final AnimationController _ringController;

  bool _isPlaying = false;
  int _phaseIndex = 0;
  late int _secondsRemaining;
  Timer? _timer;
  int _cyclesCompleted = 0;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(vsync: this);
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _secondsRemaining = widget.pattern.steps[0];
    
    // Auto-start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _togglePlay();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _orbController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _playPhase(resume: true);
        _startTimer();
      } else {
        _timer?.cancel();
        _orbController.stop();
      }
    });
  }

  String _getPhaseName(int index, int totalSteps) {
    if (totalSteps == 2) {
      return index == 0 ? 'Breathe In' : 'Breathe Out';
    }
    if (totalSteps == 3) {
      return index == 0 ? 'Breathe In' : (index == 1 ? 'Hold' : 'Breathe Out');
    }
    return index == 0
        ? 'Breathe In'
        : (index == 1
            ? 'Hold'
            : (index == 2 ? 'Breathe Out' : 'Hold'));
  }

  void _playPhase({bool resume = false}) {
    final duration = widget.pattern.steps[_phaseIndex];
    final phaseName = _getPhaseName(_phaseIndex, widget.pattern.steps.length);
    
    _orbController.duration = Duration(seconds: duration);
    
    if (phaseName == 'Breathe In') {
      resume ? _orbController.forward() : _orbController.forward(from: 0.0);
    } else if (phaseName == 'Breathe Out') {
      resume ? _orbController.reverse() : _orbController.reverse(from: 1.0);
    }
    // Hold phase does nothing to the controller
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _totalSeconds++;
        _secondsRemaining--;

        if (_secondsRemaining <= 0) {
          _phaseIndex = (_phaseIndex + 1) % widget.pattern.steps.length;
          _secondsRemaining = widget.pattern.steps[_phaseIndex];
          
          if (_phaseIndex == 0) {
            _cyclesCompleted++;
            if (_cyclesCompleted % 3 == 0) {
              context.read<AuthService>().trackEngagement(
                    'breathing',
                    'completed',
                    durationSec: _totalSeconds,
                  );
            }
          }
          _playPhase();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'breathing',
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Center(
                  child: _buildOrb(),
                ),
              ),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: ZenTokens.zenFg),
            onPressed: widget.onClose,
          ),
          Text(
            widget.pattern.name,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ZenTokens.zenFg,
            ),
          ),
          const SizedBox(width: 48), // Balance close button
        ],
      ),
    );
  }

  Widget _buildOrb() {
    final phaseName = _getPhaseName(_phaseIndex, widget.pattern.steps.length);
    final orbSize = 240.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            phaseName,
            key: ValueKey(phaseName),
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: ZenTokens.zenFg,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: orbSize,
          height: orbSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer rings
              for (int i = 2; i >= 0; i--)
                AnimatedBuilder(
                  animation: _ringController,
                  builder: (context, child) {
                    final pulse = _isPlaying ? math.sin(_ringController.value * math.pi) : 0.0;
                    final baseSize = orbSize * (0.55 + (0.15 * i));
                    final size = baseSize + (pulse * 10 * (i + 1));
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.15 - (i * 0.04)),
                          width: 1.5,
                        ),
                      ),
                    );
                  },
                ),

              // Orb
              AnimatedBuilder(
                animation: _orbController,
                builder: (context, child) {
                  // Tween from 0.55 to 1.0 based on controller
                  final scale = 0.55 + (_orbController.value * 0.45);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: orbSize,
                      height: orbSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0x8038BDF8),
                            Color(0x2038BDF8),
                            Colors.transparent,
                          ],
                          stops: [0.2, 0.7, 1.0],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _isPlaying ? '$_secondsRemaining' : 'Start',
                          style: GoogleFonts.inter(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        Text(
          'Follow the rhythm',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: ZenTokens.zenFgMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: FilledButton(
        onPressed: _togglePlay,
        style: FilledButton.styleFrom(
          backgroundColor: ZenTokens.zenPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
          ),
        ),
        child: Text(
          _isPlaying ? 'Pause' : 'Resume',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
