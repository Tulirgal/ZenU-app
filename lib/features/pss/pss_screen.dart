import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/api/api_client.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class PSSScreen extends StatefulWidget { 
  const PSSScreen({super.key}); 
 
  @override 
  State<PSSScreen> createState() => _PSSScreenState(); 
} 
 
class _PSSScreenState extends State<PSSScreen> { 
  int _currentQIndex = 0; 
  final Map<int, int> _answers = {}; 
  bool _isSubmitting = false; 
  int? _selectedOption; 
  bool _isTransitioning = false; 
  String? _error; 
 
  final List<Map<String, dynamic>> _questions = [ 
    {'id': 1, 'text': 'Today, how often have you been upset because of something that happened unexpectedly?', 'reverse': false}, 
    {'id': 2, 'text': 'Today, how often have you felt that you were unable to control the important things in your life?', 'reverse': false}, 
    {'id': 3, 'text': "Today, how often have you felt nervous and 'stressed'?", 'reverse': false}, 
    {'id': 4, 'text': 'Today, how often have you felt confident about your ability to handle your personal problems?', 'reverse': true}, 
    {'id': 5, 'text': 'Today, how often have you felt that things were going your way?', 'reverse': true}, 
    {'id': 6, 'text': 'Today, how often have you found that you could not cope with all the things that you had to do?', 'reverse': false}, 
    {'id': 7, 'text': 'Today, how often have you been able to control irritations in your life?', 'reverse': true}, 
    {'id': 8, 'text': 'Today, how often have you felt that you were on top of things?', 'reverse': true}, 
    {'id': 9, 'text': 'Today, how often have you been angered because of things that were outside of your control?', 'reverse': false}, 
    {'id': 10, 'text': 'Today, how often have you felt difficulties were piling up so high that you could not overcome them?', 'reverse': false}, 
  ]; 
 
  final List<Map<String, dynamic>> _options = [ 
    {'label': 'Never', 'value': 0}, 
    {'label': 'Almost Never', 'value': 1}, 
    {'label': 'Sometimes', 'value': 2}, 
    {'label': 'Fairly Often', 'value': 3}, 
    {'label': 'Very Often', 'value': 4}, 
  ]; 
 
  double get _progress => ((_currentQIndex + 1) / _questions.length); 
 
  Future<void> _submitResults() async { 
    setState(() { 
      _isSubmitting = true; 
      _error = null; 
    }); 
 
    try { 
      final scores = _questions.map((q) { 
        final val = _answers[q['id']] ?? 0; 
        return q['reverse'] == true ? 4 - val : val; 
      }).toList(); 
 
      final client = await ApiClient.getInstance(); 
      final res = await client.post('/api/dashboard/pss', data: {'scores': scores}); 
       
      if (res.statusCode == 200 || res.statusCode == 201) { 
        if (mounted) context.go('/'); 
      } else { 
        setState(() { 
          _error = 'Failed to submit assessment.'; 
          _isSubmitting = false; 
        }); 
      } 
    } catch (e) { 
      if (mounted) { 
        setState(() { 
          _error = 'Network error. Please try again.'; 
          _isSubmitting = false; 
        }); 
      } 
    } 
  } 
 
  void _handleSelect(int value) async { 
    if (_isTransitioning || _isSubmitting) return; 
 
    setState(() { 
      _selectedOption = value; 
      _answers[_questions[_currentQIndex]['id']] = value; 
    }); 
 
    await Future.delayed(const Duration(milliseconds: 150)); 
 
    if (!mounted) return; 
 
    setState(() => _isTransitioning = true); 
 
    if (_currentQIndex < _questions.length - 1) { 
      await Future.delayed(const Duration(milliseconds: 200)); 
      if (!mounted) return; 
      setState(() { 
        _currentQIndex++; 
        _selectedOption = null; 
        _isTransitioning = false; 
      }); 
    } else { 
      _submitResults(); 
    } 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.pss; 
    final currentQ = _questions[_currentQIndex]; 
 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'pss', 
        child: SafeArea( 
          child: SingleChildScrollView( 
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40), 
            child: Center( 
              child: ConstrainedBox( 
                constraints: const BoxConstraints(maxWidth: 600), 
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.stretch, 
                  children: [ 
                    Align( 
                      alignment: Alignment.centerLeft, 
                      child: IconButton( 
                        onPressed: () => context.pop(), 
                        icon: Icon(Icons.close, color: theme.textPrimary), 
                      ), 
                    ), 
                    const SizedBox(height: 16), 
                     
                    Text( 
                      'Stress Assessment', 
                      style: GoogleFonts.lora(fontSize: 36, fontWeight: FontWeight.w600, color: theme.textPrimary), 
                      textAlign: TextAlign.center, 
                    ), 
                    const SizedBox(height: 8), 
                    Text( 
                      'Reflect on how you felt over the last month.', 
                      style: GoogleFonts.inter(fontSize: 16, color: theme.textSecondary), 
                      textAlign: TextAlign.center, 
                    ), 
                    const SizedBox(height: 40), 
                     
                    if (_error != null) ...[ 
                      Container( 
                        padding: const EdgeInsets.all(12), 
                        decoration: BoxDecoration( 
                          color: Colors.red.withValues(alpha: 0.1), 
                          borderRadius: BorderRadius.circular(12), 
                          border: Border.all(color: Colors.red.withValues(alpha: 0.2)), 
                        ), 
                        child: Text(_error!, style: GoogleFonts.inter(color: Colors.red[700])), 
                      ), 
                      const SizedBox(height: 24), 
                    ], 
 
                    Text( 
                      'Question ${_currentQIndex + 1} of ${_questions.length} • ${(_progress * 100).round()}% complete', 
                      style: GoogleFonts.inter(fontSize: 14, color: theme.textSecondary), 
                    ), 
                    const SizedBox(height: 8), 
                    Container( 
                      height: 8, 
                      decoration: BoxDecoration( 
                        color: Colors.white.withValues(alpha: 0.4), 
                        borderRadius: BorderRadius.circular(4), 
                      ), 
                      child: FractionallySizedBox( 
                        alignment: Alignment.centerLeft, 
                        widthFactor: _progress, 
                        child: Container( 
                          decoration: BoxDecoration( 
                            color: ZenTokens.primary, 
                            borderRadius: BorderRadius.circular(4), 
                          ), 
                        ), 
                      ), 
                    ), 
                    const SizedBox(height: 40), 
 
                    AnimatedOpacity( 
                      duration: const Duration(milliseconds: 200), 
                      opacity: _isTransitioning ? 0.4 : 1.0, 
                      child: Container( 
                        padding: const EdgeInsets.all(32), 
                        decoration: BoxDecoration( 
                          color: Colors.white.withValues(alpha: 0.8), 
                          borderRadius: BorderRadius.circular(24), 
                          border: Border.all(color: Colors.white.withValues(alpha: 0.5)), 
                          boxShadow: [ 
                            BoxShadow( 
                              color: Colors.black.withValues(alpha: 0.05), 
                              blurRadius: 24, 
                              offset: const Offset(0, 12), 
                            ), 
                          ], 
                        ), 
                        child: Column( 
                          children: [ 
                            Text( 
                              currentQ['text'], 
                              style: GoogleFonts.inter(fontSize: 20, color: Colors.black87, height: 1.5), 
                              textAlign: TextAlign.center, 
                            ), 
                            const SizedBox(height: 32), 
                            Wrap( 
                              spacing: 12, 
                              runSpacing: 12, 
                              alignment: WrapAlignment.center, 
                              children: _options.map((opt) { 
                                final val = opt['value'] as int; 
                                final isSelected = _selectedOption == val; 
                                return GestureDetector( 
                                  onTap: () => _handleSelect(val), 
                                  child: Container( 
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), 
                                    decoration: BoxDecoration( 
                                      color: isSelected ? ZenTokens.primary.withValues(alpha: 0.1) : Colors.white, 
                                      borderRadius: BorderRadius.circular(16), 
                                      border: Border.all( 
                                        color: isSelected ? ZenTokens.primary : Colors.black.withValues(alpha: 0.1), 
                                        width: isSelected ? 2 : 1, 
                                      ), 
                                    ), 
                                    child: Text( 
                                      opt['label'], 
                                      style: GoogleFonts.inter( 
                                        fontSize: 15, 
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, 
                                        color: isSelected ? ZenTokens.primary : Colors.black87, 
                                      ), 
                                    ), 
                                  ), 
                                ); 
                              }).toList(), 
                            ), 
                          ], 
                        ), 
                      ), 
                    ), 
 
                    const SizedBox(height: 24), 
                    if (_isSubmitting) 
                      Center( 
                        child: Text( 
                          'Submitting your check-in...', 
                          style: GoogleFonts.inter(fontSize: 14, color: ZenTokens.primary), 
                        ), 
                      ), 
                  ], 
                ), 
              ), 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
}
