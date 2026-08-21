import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../core/api/api_client.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
enum CompassStep { core, sub, result } 
 
class InnerCompassScreen extends StatefulWidget { 
  const InnerCompassScreen({super.key}); 
  @override 
  State<InnerCompassScreen> createState() => _InnerCompassScreenState(); 
} 
 
class _InnerCompassScreenState extends State<InnerCompassScreen> { 
  CompassStep _step = CompassStep.core; 
  String? _selectedCore; 
  String? _selectedSub; 
 
  static const coreEmotions = [ 
    {'id': 'angry',     'label': 'Angry',     'emoji': '😡', 'color': Color(0xFFEF4444)}, 
    {'id': 'sad',       'label': 'Sad',       'emoji': '😢', 'color': Color(0xFF3B82F6)}, 
    {'id': 'happy',     'label': 'Happy',     'emoji': '✨', 'color': Color(0xFFEAB308)}, 
    {'id': 'fearful',   'label': 'Fearful',   'emoji': '😨', 'color': Color(0xFF8B5CF6)}, 
    {'id': 'surprised', 'label': 'Surprised', 'emoji': '⚡', 'color': Color(0xFFF97316)}, 
    {'id': 'disgusted', 'label': 'Disgusted', 'emoji': '🤢', 'color': Color(0xFF22C55E)}, 
    {'id': 'bad',       'label': 'Bad',       'emoji': '😩', 'color': Color(0xFF64748B)}, 
  ]; 
 
  static const subEmotions = { 
    'angry':     ['Frustrated', 'Resentful', 'Furious', 'Overwhelmed'], 
    'sad':       ['Lonely', 'Heartbroken', 'Hopeless', 'Grieving'], 
    'happy':     ['Grateful', 'Excited', 'Proud', 'Peaceful'], 
    'fearful':   ['Anxious', 'Insecure', 'Scared', 'Worried'], 
    'surprised': ['Shocked', 'Confused', 'Amazed', 'Eager'], 
    'disgusted': ['Disappointed', 'Awful', 'Repulsed', 'Horrified'], 
    'bad':       ['Tired', 'Stressed', 'Bored', 'Numb'], 
  }; 
 
  static const affirmations = { 
    'Frustrated': 'It is completely valid to feel blocked right now. Take a step back and let the frustration settle before moving forward.', 
    'Resentful': 'Holding onto bitterness is heavy. It is okay to acknowledge it, but you don\'t have to carry it forever.', 
    'Furious': 'Your anger is a protective signal, and it is valid. Honor it, but let it pass through you instead of consuming you.', 
    'Overwhelmed': 'When everything feels like too much, focus on just the very next step. You don\'t have to figure it all out right now.', 
    'Lonely': 'You are worthy of connection, even when it feels out of reach. Remember that this feeling of isolation is temporary.', 
    'Heartbroken': 'Pain is the echo of how deeply you care. Give yourself the grace and time you need to heal.', 
    'Hopeless': 'Even in the darkest moments, the sun eventually rises. Let yourself rest, and hope will find its way back.', 
    'Grieving': 'Grief has no timeline. Honor your loss and be gentle with yourself as you navigate these waves.', 
    'Grateful': 'Appreciation anchors you in the present. Savor this goodness and let it warm your spirit.', 
    'Excited': 'Your energy is radiant and infectious! Embrace the joy of anticipation and let it move you forward.', 
    'Proud': 'You worked hard for this, and you deserve to celebrate. Let yourself feel the fullness of your accomplishments.', 
    'Peaceful': 'There is profound power in stillness. Absorb this calm and let it recharge your entire being.', 
    'Anxious': 'Your mind is racing to protect you, but you are safe right now. Ground yourself in the present moment.', 
    'Insecure': 'Your doubts do not define your worth. You are enough exactly as you are, flaws and all.', 
    'Scared': 'Fear means you are at the edge of your comfort zone. Acknowledge the fear, and bravely take the next step.', 
    'Worried': 'You cannot control the future, only how you respond to it. Bring your focus back to what you can influence today.', 
    'Shocked': 'Unexpected things disrupt our balance. Give yourself a moment to steady your footing before reacting.', 
    'Confused': 'Clarity often takes time to emerge from the fog. It is okay to not have the answers right now.', 
    'Amazed': 'Wonder is a beautiful state of mind. Let the awe wash over you and inspire your perspective.', 
    'Eager': 'Your readiness is a powerful force. Channel that momentum purposefully toward your goals.', 
    'Disappointed': 'It is hard when things don\'t meet our hopes. Allow yourself to feel the letdown before adjusting your sails.', 
    'Awful': 'Some days are just profoundly difficult. Be kind to yourself today, and remember tomorrow is a blank page.', 
    'Repulsed': 'Your boundaries are speaking to you. Listen to them and protect your peace.', 
    'Horrified': 'Shocking moments take time to process. Ensure you are in a safe space and breathe through the intensity.', 
    'Tired': 'Rest is not a reward, it is a requirement. Give your body and mind the deep rest they are asking for.', 
    'Stressed': 'The pressure is high, but you have handled difficult things before. Take it one task, one breath at a time.', 
    'Bored': 'Boredom is often the predecessor to creativity. See it as a pause rather than a deficit.', 
    'Numb': 'Feeling disconnected is a defense mechanism. Gently invite small sensations back when you feel safe enough.', 
  }; 
 
  static const recs = { 
    'angry':     [{'route': '/burst', 'label': 'Burst It Out'}, {'route': '/breathing', 'label': 'Breathing'}], 
    'sad':       [{'route': '/chat', 'label': 'Talk to Seviyan'}, {'route': '/doodle', 'label': 'Doodle Dreams'}], 
    'happy':     [{'route': '/gratitude', 'label': 'Gratitude Journal'}, {'route': '/healing-garden', 'label': 'Healing Garden'}], 
    'fearful':   [{'route': '/breathing', 'label': 'Zen Breath Zone'}, {'route': '/mindfulness', 'label': 'Meditate'}], 
    'surprised': [{'route': '/diary', 'label': 'My Diary'}, {'route': '/bubble', 'label': 'Bubble Canvas'}], 
    'disgusted': [{'route': '/scribble', 'label': 'Scribble Pad'}, {'route': '/burst', 'label': 'Burst It Out'}], 
    'bad':       [{'route': '/bubble', 'label': 'Bubble Canvas'}, {'route': '/healing-garden', 'label': 'Healing Garden'}], 
  }; 
 
  void _selectCore(String id) { 
    setState(() { 
      _selectedCore = id; 
      _step = CompassStep.sub; 
    }); 
  } 
 
  Future<void> _selectSub(String sub) async { 
    setState(() { 
      _selectedSub = sub; 
      _step = CompassStep.result; 
    }); 
     
    try { 
      final c = await ApiClient.getInstance(); 
      await c.post('/api/signals/engagement', data: {'module_id': 'inner_compass', 'event_type': 'completed'}); 
    } catch (_) {} 
  } 
 
  void _reset() { 
    setState(() { 
      _step = CompassStep.core; 
      _selectedCore = null; 
      _selectedSub = null; 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.innerCompass; 
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar( 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: IconThemeData(color: theme.textPrimary), 
        title: Text('Inner Compass', style: GoogleFonts.inter(color: theme.textPrimary, fontWeight: FontWeight.w600)), 
      ), 
      body: ModuleBackground( 
        moduleKey: 'inner_compass', 
        child: SafeArea( 
          child: AnimatedSwitcher( 
            duration: const Duration(milliseconds: 400), 
            child: _buildStep(theme), 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildStep(ModuleTheme theme) { 
    switch (_step) { 
      case CompassStep.core: return _buildCore(theme); 
      case CompassStep.sub:  return _buildSub(theme); 
      case CompassStep.result: return _buildResult(theme); 
    } 
  } 
 
  Widget _buildCore(ModuleTheme theme) { 
    return SingleChildScrollView( 
      padding: const EdgeInsets.all(24), 
      child: Column( 
        key: const ValueKey('core'), 
        children: [ 
          const SizedBox(height: 20), 
          Text('How are you feeling at your core?', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 22, color: theme.textPrimary, fontWeight: FontWeight.w600)), 
          const SizedBox(height: 40), 
          Wrap( 
            spacing: 20, runSpacing: 20, 
            alignment: WrapAlignment.center, 
            children: coreEmotions.map((e) => GestureDetector( 
              onTap: () => _selectCore(e['id'] as String), 
              child: Container( 
                width: 120, height: 120, 
                decoration: BoxDecoration( 
                  shape: BoxShape.circle, 
                  gradient: LinearGradient( 
                    begin: Alignment.topLeft, end: Alignment.bottomRight, 
                    colors: [(e['color'] as Color).withValues(alpha: 0.8), (e['color'] as Color).withValues(alpha: 0.2)], 
                  ), 
                  border: Border.all(color: (e['color'] as Color).withValues(alpha: 0.5)), 
                ), 
                child: Column( 
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [ 
                    Text(e['emoji'] as String, style: const TextStyle(fontSize: 32)), 
                    const SizedBox(height: 8), 
                    Text(e['label'] as String, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)), 
                  ], 
                ), 
              ).animate().fadeIn().scaleXY(begin: 0.8, end: 1.0, duration: 300.ms), 
            )).toList(), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildSub(ModuleTheme theme) { 
    final subs = subEmotions[_selectedCore] ?? []; 
    return SingleChildScrollView( 
      padding: const EdgeInsets.all(24), 
      child: Column( 
        key: const ValueKey('sub'), 
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: [ 
          const SizedBox(height: 20), 
          Text('Let\'s go a little deeper.', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 22, color: theme.textPrimary, fontWeight: FontWeight.w600)), 
          const SizedBox(height: 8), 
          Text('Which word best describes this?', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 16, color: theme.textSecondary)), 
          const SizedBox(height: 40), 
          ...subs.map((s) => Padding( 
            padding: const EdgeInsets.only(bottom: 12), 
            child: ElevatedButton( 
              onPressed: () => _selectSub(s), 
              style: ElevatedButton.styleFrom( 
                backgroundColor: theme.cardBg, 
                foregroundColor: theme.textPrimary, 
                padding: const EdgeInsets.symmetric(vertical: 20), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.cardBorder)), 
              ), 
              child: Text(s, style: GoogleFonts.inter(fontSize: 18)), 
            ).animate().fadeIn().slideX(begin: 0.2, end: 0, duration: 300.ms), 
          )), 
          const SizedBox(height: 20), 
          TextButton( 
            onPressed: () => setState(() => _step = CompassStep.core), 
            child: Text('Go back', style: GoogleFonts.inter(color: theme.textSecondary)), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildResult(ModuleTheme theme) { 
    final coreLabel = coreEmotions.firstWhere((e) => e['id'] == _selectedCore)['label']; 
    final affirm = affirmations[_selectedSub] ?? 'Your feelings are valid.'; 
    final r = recs[_selectedCore] ?? []; 
 
    return SingleChildScrollView( 
      padding: const EdgeInsets.all(24), 
      child: Column( 
        key: const ValueKey('result'), 
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: [ 
          const SizedBox(height: 20), 
          Container( 
            padding: const EdgeInsets.all(24), 
            decoration: BoxDecoration( 
              color: theme.cardBg, 
              borderRadius: BorderRadius.circular(24), 
              border: Border.all(color: theme.accentColor.withValues(alpha: 0.5)), 
            ), 
            child: Column( 
              children: [ 
                Text('$coreLabel → $_selectedSub', style: GoogleFonts.inter(color: theme.accentColor, fontWeight: FontWeight.w600, letterSpacing: 1)), 
                const SizedBox(height: 20), 
                Text(affirm, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 20, color: theme.textPrimary, height: 1.5)), 
              ], 
            ), 
          ).animate().fadeIn().slideY(begin: 0.2, end: 0, duration: 400.ms), 
           
          const SizedBox(height: 40), 
          Text('Recommended for you now', style: GoogleFonts.inter(color: theme.textSecondary, fontWeight: FontWeight.w600)), 
          const SizedBox(height: 16), 
          ...r.map((rec) => Padding( 
            padding: const EdgeInsets.only(bottom: 12), 
            child: OutlinedButton( 
              onPressed: () => context.push(rec['route'] as String), 
              style: OutlinedButton.styleFrom( 
                foregroundColor: theme.textPrimary, 
                side: BorderSide(color: theme.cardBorder), 
                padding: const EdgeInsets.symmetric(vertical: 20), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
              ), 
              child: Row( 
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [ 
                  Text(rec['label'] as String, style: GoogleFonts.inter(fontSize: 16)), 
                  const SizedBox(width: 8), 
                  Icon(Icons.arrow_forward_rounded, size: 16, color: theme.textSecondary), 
                ], 
              ), 
            ).animate().fadeIn(delay: 200.ms), 
          )), 
          const SizedBox(height: 24), 
          TextButton( 
            onPressed: _reset, 
            child: Text('Check in again', style: GoogleFonts.inter(color: theme.accentColor)), 
          ), 
        ], 
      ), 
    ); 
  } 
}
