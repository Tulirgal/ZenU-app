import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';

class MindfulnessScreen extends StatefulWidget {
  const MindfulnessScreen({super.key});

  @override
  State<MindfulnessScreen> createState() => _MindfulnessScreenState();
}

class _MindfulnessScreenState extends State<MindfulnessScreen> {
  final AudioPlayer _player = AudioPlayer();
  
  bool _isLoading = true;
  String? _error;
  String? _audioUrl;
  String? _title;
  String? _description;

  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  late StreamSubscription _posSub;
  late StreamSubscription _durSub;
  late StreamSubscription _stateSub;
  late StreamSubscription _compSub;

  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    _posSub = _player.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    
    _durSub = _player.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _duration = dur);
    });

    _stateSub = _player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _compSub = _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
        final elapsed = DateTime.now().difference(_startTime!).inSeconds;
        context.read<AuthService>().trackEngagement('mindfulness', 'completed', durationSec: elapsed);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().trackEngagement('mindfulness', 'opened');
      _loadMeditation();
    });
  }

  @override
  void dispose() {
    _posSub.cancel();
    _durSub.cancel();
    _stateSub.cancel();
    _compSub.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadMeditation() async {
    try {
      final c = await ApiClient.getInstance();
      final r = await c.get('/api/meditations');
      if (r.statusCode == 200) {
        final List data = r.data is List ? r.data : (r.data['meditations'] ?? []);
        if (data.isNotEmpty) {
          final session = data.first;
          _title = session['title'] ?? 'Find your inner peace';
          _description = session['description'] ?? 'A few quiet minutes to slow down and release tension.';
          _audioUrl = session['audio_url'];
          
          if (_audioUrl != null) {
            await _player.setSourceUrl(_audioUrl!);
          }
        } else {
          _error = 'No guided meditations are available yet.';
        }
      }
    } catch (e) {
      debugPrint('Failed to load meditation: $e');
      _error = 'We could not load guided sessions. Please try again later.';
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'mindfulness',
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ZenTokens.zenFg),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        'GUIDED STILLNESS',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0,
                          color: ZenTokens.zenPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _title ?? 'Find your inner peace',
                        style: GoogleFonts.lora(
                          fontSize: 32,
                          color: ZenTokens.zenFg,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _description ?? 'A few quiet minutes to slow down and release tension.',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: ZenTokens.zenFgMuted,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: CircularProgressIndicator(color: ZenTokens.zenPrimary),
                        )
                      else if (_error != null)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ZenTokens.zenDanger.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: ZenTokens.zenDanger.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            children: [
                              Text(_error!, style: GoogleFonts.inter(color: ZenTokens.zenDanger)),
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                    _error = null;
                                  });
                                  _loadMeditation();
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: ZenTokens.zenDanger,
                                  side: BorderSide(color: ZenTokens.zenDanger.withValues(alpha: 0.3)),
                                ),
                                child: const Text('Try Again'),
                              )
                            ],
                          ),
                        )
                      else if (_audioUrl != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                          decoration: BoxDecoration(
                            color: ZenTokens.zenSurface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: ZenTokens.zenBorderSoft),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_isPlaying) {
                                    _player.pause();
                                  } else {
                                    _player.play(UrlSource(_audioUrl!));
                                  }
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: ZenTokens.zenPrimary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: ZenTokens.zenPrimary.withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: ZenTokens.zenPrimary,
                                  inactiveTrackColor: ZenTokens.zenBorderSoft,
                                  thumbColor: ZenTokens.zenPrimary,
                                  trackHeight: 4.0,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                                ),
                                child: Slider(
                                  value: _position.inSeconds.toDouble(),
                                  min: 0.0,
                                  max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                                  onChanged: (val) {
                                    _player.seek(Duration(seconds: val.toInt()));
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(_position),
                                      style: GoogleFonts.inter(fontSize: 12, color: ZenTokens.zenFgMuted, fontFeatures: [const FontFeature.tabularFigures()]),
                                    ),
                                    Text(
                                      _formatDuration(_duration),
                                      style: GoogleFonts.inter(fontSize: 12, color: ZenTokens.zenFgMuted, fontFeatures: [const FontFeature.tabularFigures()]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
