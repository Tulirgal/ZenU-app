import 'dart:convert'; 
import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:http/http.dart' as http; 
import 'package:audioplayers/audioplayers.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class MindfulnessScreen extends StatefulWidget { 
  const MindfulnessScreen({super.key}); 
 
  @override 
  State<MindfulnessScreen> createState() => _MindfulnessScreenState(); 
} 
 
class _MindfulnessScreenState extends State<MindfulnessScreen> with SingleTickerProviderStateMixin { 
  final AudioPlayer _audioPlayer = AudioPlayer(); 
  bool _isLoading = true; 
  Map<String, dynamic>? _session; 
   
  String _phase = 'idle'; // idle, active, completed 
  bool _isPlaying = false; 
  Duration _duration = Duration.zero; 
  Duration _position = Duration.zero; 
 
  late AnimationController _orbCtrl; 
  late Animation<double> _orbScale; 
  late Animation<double> _orbOpacity; 
 
  final List<Map<String, String>> _jpmrSteps = [ 
    {'muscle': 'Right hand & forearm', 'instruction': 'Make a fist with your right hand. Squeeze tightly.'}, 
    {'muscle': 'Right upper arm', 'instruction': 'Bring your right forearm up to your shoulder to "make a muscle".'}, 
    {'muscle': 'Left hand & forearm', 'instruction': 'Make a fist with your left hand. Squeeze tightly.'}, 
    {'muscle': 'Left upper arm', 'instruction': 'Bring your left forearm up to your shoulder.'}, 
    {'muscle': 'Forehead', 'instruction': 'Raise your eyebrows as high as they will go, as though you were surprised.'}, 
    {'muscle': 'Eyes and cheeks', 'instruction': 'Squeeze your eyes tight shut.'}, 
    {'muscle': 'Mouth and jaw', 'instruction': 'Open your mouth as wide as you can, as you might when you yawn.'}, 
    {'muscle': 'Neck', 'instruction': 'Carefully pull your head back slightly, as though you are looking at the ceiling.'}, 
    {'muscle': 'Shoulders', 'instruction': 'Tense your shoulders by bringing them up towards your ears.'}, 
    {'muscle': 'Shoulder blades/Back', 'instruction': 'Push your shoulder blades back, trying to touch them together.'}, 
    {'muscle': 'Chest and stomach', 'instruction': 'Breathe in deeply, filling your lungs and chest with air.'}, 
    {'muscle': 'Hips and buttocks', 'instruction': 'Squeeze your buttocks together.'}, 
    {'muscle': 'Right upper leg', 'instruction': 'Tighten your right thigh.'}, 
    {'muscle': 'Right lower leg', 'instruction': 'Slowly and carefully pull your right toes towards you.'}, 
    {'muscle': 'Right foot', 'instruction': 'Curl your right toes downwards.'}, 
    {'muscle': 'Left upper leg', 'instruction': 'Tighten your left thigh.'}, 
    {'muscle': 'Left lower leg', 'instruction': 'Slowly and carefully pull your left toes towards you.'}, 
    {'muscle': 'Left foot', 'instruction': 'Curl your left toes downwards.'}, 
  ]; 
 
  final List<String> _tips = [ 
    "Find a quiet space where you won't be interrupted.", 
    "Sit or lie in a comfortable position.", 
    "It's okay if your mind wanders. Gently bring it back.", 
    "Don't strain or tense muscles to the point of pain." 
  ]; 
 
  @override 
  void initState() { 
    super.initState(); 
     
    _orbCtrl = AnimationController( 
      vsync: this, 
      duration: const Duration(milliseconds: 5500), 
    ); 
 
    _orbScale = TweenSequence<double>([ 
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.06).chain(CurveTween(curve: Curves.easeInOut)), weight: 50), 
      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 50), 
    ]).animate(_orbCtrl); 
     
    _orbOpacity = TweenSequence<double>([ 
      TweenSequenceItem(tween: Tween(begin: 0.55, end: 0.85).chain(CurveTween(curve: Curves.easeInOut)), weight: 50), 
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 0.55).chain(CurveTween(curve: Curves.easeInOut)), weight: 50), 
    ]).animate(_orbCtrl); 
 
    _audioPlayer.onDurationChanged.listen((d) { 
      if (mounted) setState(() => _duration = d); 
    }); 
 
    _audioPlayer.onPositionChanged.listen((p) { 
      if (mounted) { 
        setState(() => _position = p); 
        // Trigger completion 
        if (_duration.inSeconds > 0 && p.inSeconds >= _duration.inSeconds - 1) { 
          _completePractice(); 
        } 
      } 
    }); 
 
    _audioPlayer.onPlayerStateChanged.listen((state) { 
      if (mounted) { 
        setState(() { 
          _isPlaying = state == PlayerState.playing; 
          if (_isPlaying) { 
            _orbCtrl.repeat(); 
          } else { 
            _orbCtrl.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut); 
          } 
        }); 
      } 
    }); 
 
    _loadMeditation(); 
  } 
 
  Future<void> _loadMeditation() async { 
    try { 
      final res = await http.get(Uri.parse('http://localhost:3000/api/meditations')); 
      if (res.statusCode == 200) { 
        final List data = jsonDecode(res.body); 
        if (data.isNotEmpty) { 
          _session = data[0]; 
        } 
      } else { 
        // Fallback for mock if API fails 
        _session = { 
          'title': "Jacobson's Deep Relaxation", 
          'description': "Jacobson's Progressive Muscle Relaxation guides you through systematically tensing and releasing each muscle group so the body can settle into stillness.", 
          'durationMinutes': 12, 
          'category': 'Relaxation', 
          'audio_url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', // Sample fallback 
        }; 
      } 
    } catch (e) { 
      _session = { 
        'title': "Jacobson's Deep Relaxation", 
        'description': "Jacobson's Progressive Muscle Relaxation guides you through systematically tensing and releasing each muscle group so the body can settle into stillness.", 
        'durationMinutes': 12, 
        'category': 'Relaxation', 
        'audio_url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3', 
      }; 
    } 
    if (mounted) { 
      setState(() => _isLoading = false); 
      if (_session != null && _session!['audio_url'] != null) { 
        await _audioPlayer.setSourceUrl(_session!['audio_url']); 
      } 
    } 
  } 
 
  @override 
  void dispose() { 
    _audioPlayer.dispose(); 
    _orbCtrl.dispose(); 
    super.dispose(); 
  } 
 
  void _beginPractice() { 
    setState(() => _phase = 'active'); 
    _audioPlayer.play(UrlSource(_session!['audio_url'])); 
  } 
 
  void _togglePlay() { 
    if (_isPlaying) { 
      _audioPlayer.pause(); 
    } else { 
      _audioPlayer.resume(); 
    } 
  } 
 
  void _completePractice() { 
    _audioPlayer.stop(); 
    setState(() => _phase = 'completed'); 
  } 
 
  String _formatTime(Duration d) { 
    final min = d.inMinutes; 
    final sec = (d.inSeconds % 60).toString().padLeft(2, '0'); 
    return '$min:$sec'; 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'mindfulness', 
        child: SafeArea( 
          child: Column( 
            children: [ 
              Align( 
                alignment: Alignment.centerLeft, 
                child: Padding( 
                  padding: const EdgeInsets.only(left: 16, top: 12), 
                  child: IconButton( 
                    onPressed: () => context.pop(), 
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87), 
                  ), 
                ), 
              ), 
              Expanded( 
                child: SingleChildScrollView( 
                  child: Center( 
                    child: Container( 
                      width: double.infinity, 
                      constraints: const BoxConstraints(maxWidth: 1200), 
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), 
                      child: Column( 
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [ 
                          // Header 
                          Text( 
                            'GUIDED STILLNESS', 
                            style: GoogleFonts.inter( 
                              fontSize: 11, 
                              fontWeight: FontWeight.w600, 
                              letterSpacing: 1.4, 
                              color: ZenTokens.secondary, 
                            ), 
                          ), 
                          const SizedBox(height: 12), 
                          Text( 
                            'Find your inner peace', 
                            style: GoogleFonts.lora( 
                              fontSize: 36, 
                              fontWeight: FontWeight.w600, 
                              color: Colors.black87, 
                              letterSpacing: -0.5, 
                            ), 
                            textAlign: TextAlign.center, 
                          ), 
                          const SizedBox(height: 16), 
                          Text( 
                            'A few quiet minutes to slow down and release tension.', 
                            style: GoogleFonts.inter( 
                              fontSize: 16, 
                              color: Colors.black54, 
                              height: 1.5, 
                            ), 
                            textAlign: TextAlign.center, 
                          ), 
                           
                          const SizedBox(height: 48), 
                           
                          if (_isLoading) 
                            Container( 
                              width: double.infinity, 
                              padding: const EdgeInsets.symmetric(vertical: 80), 
                              decoration: BoxDecoration( 
                                color: Colors.white.withValues(alpha: 0.6), 
                                borderRadius: BorderRadius.circular(24), 
                                border: Border.all(color: Colors.black.withValues(alpha: 0.05)), 
                              ), 
                              child: Center( 
                                child: Text('Loading session...', style: GoogleFonts.inter(color: Colors.black54)), 
                              ), 
                            ) 
                          else if (_session == null) 
                            Container( 
                              width: double.infinity, 
                              padding: const EdgeInsets.symmetric(vertical: 60), 
                              decoration: BoxDecoration( 
                                color: Colors.white.withValues(alpha: 0.5), 
                                borderRadius: BorderRadius.circular(24), 
                                border: Border.all(color: Colors.black.withValues(alpha: 0.1), style: BorderStyle.solid), 
                              ), 
                              child: Center( 
                                child: Text('No guided meditations are available yet. Check back soon.', style: GoogleFonts.inter(color: Colors.black54)), 
                              ), 
                            ) 
                          else 
                            _buildPracticeCard(), 
 
                          if (_session != null) ...[ 
                            const SizedBox(height: 48), 
                            Row( 
                              crossAxisAlignment: CrossAxisAlignment.start, 
                              children: [ 
                                Expanded( 
                                  child: Column( 
                                    crossAxisAlignment: CrossAxisAlignment.start, 
                                    children: [ 
                                      Text( 
                                        'About this practice', 
                                        style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87), 
                                      ), 
                                      const SizedBox(height: 12), 
                                      Text( 
                                        _session!['description'], 
                                        style: GoogleFonts.inter(fontSize: 16, color: Colors.black54, height: 1.6), 
                                      ), 
                                    ], 
                                  ), 
                                ), 
                                const SizedBox(width: 48), 
                                Expanded( 
                                  child: _buildSequenceTimeline(), 
                                ), 
                              ], 
                            ), 
                            const SizedBox(height: 48), 
                            _buildTipsDisclosure(), 
                          ], 
                        ], 
                      ), 
                    ), 
                  ), 
                ), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildPracticeCard() { 
    final meta = '${_session!['durationMinutes']} min • ${_session!['category']} • Beginner'; 
     
    return Container( 
      width: double.infinity, 
      decoration: BoxDecoration( 
        color: const Color(0xFFFCFAF8), // hsl(40,40%,99%) 
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)), 
        boxShadow: [ 
          BoxShadow( 
            color: const Color(0xFF281E3C).withValues(alpha: 0.15), 
            blurRadius: 40, 
            spreadRadius: -14, 
            offset: const Offset(0, 12), 
          ), 
        ], 
      ), 
      child: Stack( 
        children: [ 
          // Atmospheric background wash 
          Positioned.fill( 
            child: ClipRRect( 
              borderRadius: BorderRadius.circular(24), 
              child: CustomPaint(painter: _WashPainter()), 
            ), 
          ), 
           
          Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48), 
            child: AnimatedSwitcher( 
              duration: const Duration(milliseconds: 350), 
              child: _phase == 'idle' 
                ? _buildIdlePhase(meta) 
                : _phase == 'active' 
                  ? _buildActivePhase(meta) 
                  : _buildCompletedPhase(), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildIdlePhase(String meta) { 
    return Column( 
      key: const ValueKey('idle'), 
      children: [ 
        const Text('🐼', style: TextStyle(fontSize: 88)), 
        const SizedBox(height: 12), 
        Text('Take a quiet moment.', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)), 
        const SizedBox(height: 4), 
        Text('Take your time.', style: GoogleFonts.inter(fontSize: 13, color: Colors.black38)), 
        const SizedBox(height: 24), 
        Text( 
          _session!['title'], 
          style: GoogleFonts.lora(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87, letterSpacing: -0.5), 
          textAlign: TextAlign.center, 
        ), 
        const SizedBox(height: 12), 
        Text( 
          _session!['description'], 
          style: GoogleFonts.inter(fontSize: 15, color: Colors.black54, height: 1.6), 
          textAlign: TextAlign.center, 
        ), 
        const SizedBox(height: 8), 
        Text(meta, style: GoogleFonts.inter(fontSize: 13, color: Colors.black38)), 
        const SizedBox(height: 32), 
        ElevatedButton( 
          onPressed: _beginPractice, 
          style: ElevatedButton.styleFrom( 
            backgroundColor: ZenTokens.primary, 
            foregroundColor: Colors.white, 
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
            elevation: 0, 
          ), 
          child: Text('Begin practice', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)), 
        ), 
      ], 
    ); 
  } 
 
  Widget _buildActivePhase(String meta) { 
    final progress = _duration.inMilliseconds > 0 ? _position.inMilliseconds / _duration.inMilliseconds : 0.0; 
     
    return Column( 
      key: const ValueKey('active'), 
      children: [ 
        SizedBox( 
          height: 180, 
          child: Center( 
            child: Stack( 
              alignment: Alignment.center, 
              children: [ 
                AnimatedBuilder( 
                  animation: _orbCtrl, 
                  builder: (context, child) { 
                    return Transform.scale( 
                      scale: _orbScale.value, 
                      child: Opacity( 
                        opacity: _orbOpacity.value, 
                        child: Container( 
                          width: 160, 
                          height: 160, 
                          decoration: BoxDecoration( 
                            shape: BoxShape.circle, 
                            gradient: RadialGradient( 
                              colors: [ 
                                HSLColor.fromAHSL(0.35, 262, 0.45, 0.70).toColor(), 
                                HSLColor.fromAHSL(0.12, 220, 0.50, 0.75).toColor(), 
                                Colors.transparent, 
                              ], 
                              stops: const [0.0, 0.45, 0.70], 
                            ), 
                          ), 
                        ), 
                      ), 
                    ); 
                  }, 
                ), 
                const Text('🐼', style: TextStyle(fontSize: 100)), 
              ], 
            ), 
          ), 
        ), 
        const SizedBox(height: 8), 
        Text('Let\'s settle in.', style: GoogleFonts.inter(fontSize: 13, color: Colors.black54)), 
        const SizedBox(height: 8), 
        Text( 
          _session!['title'], 
          style: GoogleFonts.lora(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87, letterSpacing: -0.5), 
          textAlign: TextAlign.center, 
        ), 
        const SizedBox(height: 8), 
        Text(meta, style: GoogleFonts.inter(fontSize: 13, color: Colors.black38)), 
        const SizedBox(height: 24), 
        OutlinedButton.icon( 
          onPressed: _togglePlay, 
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 20), 
          label: Text(_isPlaying ? 'Pause' : 'Resume', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500)), 
          style: OutlinedButton.styleFrom( 
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), 
            side: BorderSide(color: Colors.black.withValues(alpha: 0.1)), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
            foregroundColor: Colors.black87, 
          ), 
        ), 
        const SizedBox(height: 32), 
        SizedBox( 
          width: 300, 
          child: Column( 
            children: [ 
              GestureDetector( 
                onTapDown: (details) { 
                  if (_duration.inSeconds > 0) { 
                    final RenderBox box = context.findRenderObject() as RenderBox; 
                    final percent = details.localPosition.dx / box.size.width; 
                    final seekMillis = (_duration.inMilliseconds * percent.clamp(0.0, 1.0)).round(); 
                    _audioPlayer.seek(Duration(milliseconds: seekMillis)); 
                  } 
                }, 
                child: Container( 
                  height: 6, // h-1.5 
                  width: double.infinity, 
                  decoration: BoxDecoration( 
                    color: const Color(0xFFD4D4D4), // zen-border-soft approx 
                    borderRadius: BorderRadius.circular(3), 
                  ), 
                  child: Stack( 
                    clipBehavior: Clip.none, 
                    children: [ 
                      FractionallySizedBox( 
                        widthFactor: progress.clamp(0.0, 1.0), 
                        child: Container( 
                          decoration: BoxDecoration( 
                            color: ZenTokens.secondary.withValues(alpha: 0.7), 
                            borderRadius: BorderRadius.circular(3), 
                          ), 
                        ), 
                      ), 
                      Positioned( 
                        left: (300 * progress.clamp(0.0, 1.0)) - 6, 
                        top: -3, 
                        child: Container( 
                          width: 12, 
                          height: 12, 
                          decoration: BoxDecoration( 
                            shape: BoxShape.circle, 
                            color: ZenTokens.secondary, 
                            border: Border.all(color: Colors.white, width: 2), 
                            boxShadow: [ 
                              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 2) 
                            ], 
                          ), 
                        ), 
                      ), 
                    ], 
                  ), 
                ), 
              ), 
              const SizedBox(height: 8), 
              Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [ 
                  Text(_formatTime(_position), style: GoogleFonts.inter(fontSize: 12, color: Colors.black38)), 
                  Text(_formatTime(_duration), style: GoogleFonts.inter(fontSize: 12, color: Colors.black38)), 
                ], 
              ) 
            ], 
          ), 
        ), 
      ], 
    ); 
  } 
 
  Widget _buildCompletedPhase() { 
    return Column( 
      key: const ValueKey('completed'), 
      children: [ 
        const Text('🐼', style: TextStyle(fontSize: 96)), 
        const SizedBox(height: 16), 
        Text('Nice. You gave yourself a few quiet minutes.', style: GoogleFonts.inter(fontSize: 15, color: Colors.black54)), 
        const SizedBox(height: 16), 
        Text( 
          _session!['title'], 
          style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87), 
          textAlign: TextAlign.center, 
        ), 
        const SizedBox(height: 24), 
        OutlinedButton( 
          onPressed: () { 
            _audioPlayer.seek(Duration.zero); 
            _beginPractice(); 
          }, 
          style: OutlinedButton.styleFrom( 
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), 
            side: BorderSide(color: Colors.black.withValues(alpha: 0.2)), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), 
            foregroundColor: Colors.black87, 
          ), 
          child: Text('Practice again', style: GoogleFonts.inter(fontSize: 16)), 
        ), 
      ], 
    ); 
  } 
 
  Widget _buildSequenceTimeline() { 
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [ 
        Text('Guided sequence', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87, letterSpacing: -0.01)), 
        const SizedBox(height: 4), 
        Text('Muscle groups in this practice', style: GoogleFonts.inter(fontSize: 15, color: Colors.black54)), 
        const SizedBox(height: 24), 
        ...List.generate(_jpmrSteps.length, (i) { 
          final step = _jpmrSteps[i]; 
          final isLast = i == _jpmrSteps.length - 1; 
          return IntrinsicHeight( 
            child: Row( 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [ 
                Column( 
                  children: [ 
                    Container( 
                      width: 32, 
                      height: 32, 
                      decoration: BoxDecoration( 
                        shape: BoxShape.circle, 
                        color: Colors.white, 
                        border: Border.all(color: Colors.black.withValues(alpha: 0.1)), 
                      ), 
                      alignment: Alignment.center, 
                      child: Text( 
                        (i + 1).toString().padLeft(2, '0'), 
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: ZenTokens.secondary), 
                      ), 
                    ), 
                    if (!isLast) 
                      Expanded( 
                        child: Container( 
                          width: 1, 
                          color: Colors.black.withValues(alpha: 0.1), 
                        ), 
                      ), 
                  ], 
                ), 
                const SizedBox(width: 16), 
                Expanded( 
                  child: Padding( 
                    padding: const EdgeInsets.only(bottom: 24.0), 
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [ 
                        Text.rich( 
                          TextSpan( 
                            children: [ 
                              TextSpan(text: '↳ ', style: TextStyle(color: Colors.black.withValues(alpha: 0.4))), 
                              TextSpan(text: step['muscle']), 
                            ] 
                          ), 
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87), 
                        ), 
                        const SizedBox(height: 4), 
                        Text( 
                          step['instruction']!, 
                          style: GoogleFonts.inter(fontSize: 15, color: Colors.black54, height: 1.6), 
                        ), 
                      ], 
                    ), 
                  ), 
                ), 
              ], 
            ), 
          ); 
        }), 
      ], 
    ); 
  } 
 
  Widget _buildTipsDisclosure() { 
    return ExpansionTile( 
      title: Text('Tips for your practice', style: GoogleFonts.lora(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87)), 
      tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), 
      collapsedShape: RoundedRectangleBorder( 
        borderRadius: BorderRadius.circular(16), 
        side: BorderSide(color: Colors.black.withValues(alpha: 0.1)), 
      ), 
      shape: RoundedRectangleBorder( 
        borderRadius: BorderRadius.circular(16), 
        side: BorderSide(color: Colors.black.withValues(alpha: 0.1)), 
      ), 
      backgroundColor: Colors.white.withValues(alpha: 0.7), 
      collapsedBackgroundColor: Colors.white.withValues(alpha: 0.7), 
      children: [ 
        Container( 
          padding: const EdgeInsets.all(20), 
          decoration: BoxDecoration( 
            border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.1))), 
          ), 
          child: Column( 
            children: _tips.map((tip) { 
              return Padding( 
                padding: const EdgeInsets.only(bottom: 8.0), 
                child: Row( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [ 
                    Padding( 
                      padding: const EdgeInsets.only(top: 8.0), 
                      child: Container( 
                        width: 4, 
                        height: 4, 
                        decoration: BoxDecoration( 
                          shape: BoxShape.circle, 
                          color: ZenTokens.secondary.withValues(alpha: 0.6), 
                        ), 
                      ), 
                    ), 
                    const SizedBox(width: 12), 
                    Expanded(child: Text(tip, style: GoogleFonts.inter(fontSize: 15, color: Colors.black54, height: 1.6))), 
                  ], 
                ), 
              ); 
            }).toList(), 
          ), 
        ) 
      ], 
    ); 
  } 
} 
 
class _WashPainter extends CustomPainter { 
  @override 
  void paint(Canvas canvas, Size size) { 
    final paint1 = Paint() 
      ..shader = RadialGradient( 
        colors: [HSLColor.fromAHSL(0.16, 262, 0.40, 0.72).toColor(), Colors.transparent], 
        stops: const [0.0, 1.0], 
        center: const Alignment(0.0, -0.64), 
        radius: 0.7, 
      ).createShader(Offset.zero & size); 
       
    canvas.drawRect(Offset.zero & size, paint1); 
     
    final paint2 = Paint() 
      ..shader = RadialGradient( 
        colors: [HSLColor.fromAHSL(0.08, 200, 0.50, 0.70).toColor(), Colors.transparent], 
        stops: const [0.0, 1.0], 
        center: const Alignment(0.6, 0.8), 
        radius: 0.65, 
      ).createShader(Offset.zero & size); 
       
    canvas.drawRect(Offset.zero & size, paint2); 
  } 
 
  @override 
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; 
}
