import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/api_client.dart';
import '../../core/theme/zen_tokens.dart';

class _Question {
  final String text;
  final bool isReverse;

  const _Question(this.text, this.isReverse);
}

const List<_Question> _questions = [
  _Question('Today, how often have you been upset because of something that happened unexpectedly?', false),
  _Question('Today, how often have you felt that you were unable to control the important things in your life?', false),
  _Question("Today, how often have you felt nervous and 'stressed'?", false),
  _Question('Today, how often have you felt confident about your ability to handle your personal problems?', true),
  _Question('Today, how often have you felt that things were going your way?', true),
  // User explicitly asked to reverse score question 6 as well:
  _Question('Today, how often have you found that you could not cope with all the things that you had to do?', true),
  _Question('Today, how often have you been able to control irritations in your life?', true),
  _Question('Today, how often have you felt that you were on top of things?', true),
  _Question('Today, how often have you been angered because of things that were outside of your control?', false),
  _Question('Today, how often have you felt difficulties were piling up so high that you could not overcome them?', false),
];

const List<String> _options = [
  'Never',
  'Almost Never',
  'Sometimes',
  'Fairly Often',
  'Very Often'
];

class PSSScreen extends StatefulWidget {
  const PSSScreen({super.key});

  @override
  State<PSSScreen> createState() => _PSSScreenState();
}

class _PSSScreenState extends State<PSSScreen> {
  bool _isLoading = true;
  int? _daysRemaining;
  
  int _currentIndex = 0;
  final Map<int, int> _answers = {};
  
  bool _isCompleted = false;
  int _totalScore = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _checkEligibility();
  }

  Future<void> _checkEligibility() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCompletedStr = prefs.getString('zenu_pss_last_completed');
    
    if (lastCompletedStr != null) {
      final lastCompleted = DateTime.parse(lastCompletedStr);
      final daysPassed = DateTime.now().difference(lastCompleted).inDays;
      if (daysPassed < 7) {
        setState(() {
          _daysRemaining = 7 - daysPassed;
          _isLoading = false;
        });
        return;
      }
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _submitScore(int total) async {
    setState(() => _isSubmitting = true);
    try {
      final c = await ApiClient.getInstance();
      await c.post('/api/signals/pss', data: {'raw_score': total});
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('zenu_pss_last_completed', DateTime.now().toIso8601String());
      
      setState(() {
        _totalScore = total;
        _isCompleted = true;
      });
    } catch (e) {
      debugPrint('Error submitting PSS: $e');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save assessment.')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _handleAnswer(int optionIndex) {
    setState(() {
      _answers[_currentIndex] = optionIndex;
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_currentIndex < _questions.length - 1) {
        setState(() => _currentIndex++);
      } else {
        // Calculate score
        int total = 0;
        for (int i = 0; i < _questions.length; i++) {
          final q = _questions[i];
          final rawAns = _answers[i] ?? 0;
          final score = q.isReverse ? (4 - rawAns) : rawAns;
          total += score;
        }
        _submitScore(total);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: ZenTokens.zenBg,
        body: Center(child: CircularProgressIndicator(color: ZenTokens.zenPrimary)),
      );
    }

    if (_daysRemaining != null) {
      return Scaffold(
        backgroundColor: ZenTokens.zenBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: ZenTokens.zenFg),
            onPressed: () => context.go('/dashboard'),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 80, color: ZenTokens.zenPrimary),
                const SizedBox(height: 24),
                Text(
                  'You\'re all caught up.',
                  style: GoogleFonts.lora(fontSize: 24, color: ZenTokens.zenFg),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Next check-in in $_daysRemaining days.',
                  style: GoogleFonts.inter(fontSize: 16, color: ZenTokens.zenFgMuted),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isCompleted) {
      return Scaffold(
        backgroundColor: ZenTokens.zenBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: ZenTokens.zenFg),
            onPressed: () => context.go('/dashboard'),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.health_and_safety_outlined, size: 80, color: ZenTokens.zenPrimary),
                const SizedBox(height: 24),
                Text(
                  'Assessment Complete',
                  style: GoogleFonts.lora(fontSize: 28, color: ZenTokens.zenFg),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: ZenTokens.zenSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ZenTokens.zenBorderSoft),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your Score: $_totalScore / 40',
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: ZenTokens.zenFg),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _totalScore <= 13 ? 'Low Stress' : _totalScore <= 26 ? 'Moderate Stress' : 'High Stress',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: _totalScore <= 13 ? ZenTokens.zenPrimary : _totalScore <= 26 ? Colors.orange : ZenTokens.zenDanger,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: ZenTokens.zenFg),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text(
          'Check-in (${_currentIndex + 1}/${_questions.length})',
          style: GoogleFonts.inter(fontSize: 14, color: ZenTokens.zenFgMuted),
        ),
        centerTitle: true,
      ),
      body: _isSubmitting 
        ? const Center(child: CircularProgressIndicator(color: ZenTokens.zenPrimary))
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / _questions.length,
                    backgroundColor: ZenTokens.zenBorderSoft,
                    valueColor: const AlwaysStoppedAnimation<Color>(ZenTokens.zenPrimary),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    q.text,
                    style: GoogleFonts.lora(
                      fontSize: 24,
                      color: ZenTokens.zenFg,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  ...List.generate(_options.length, (i) {
                    final isSelected = _answers[_currentIndex] == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _handleAnswer(i),
                        borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected ? ZenTokens.zenPrimary.withValues(alpha: 0.1) : ZenTokens.zenSurface,
                            borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl),
                            border: Border.all(
                              color: isSelected ? ZenTokens.zenPrimary : ZenTokens.zenBorderSoft,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            _options[i],
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? ZenTokens.zenPrimary : ZenTokens.zenFg,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }
}
