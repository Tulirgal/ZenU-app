import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:provider/provider.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../core/auth/auth_service.dart'; 
import '../../core/api/api_client.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
import 'widgets/mood_check_in.dart'; 
import 'widgets/recommendation_card.dart'; 
import 'widgets/module_grid.dart'; 
 
class DashboardScreen extends StatefulWidget { 
  const DashboardScreen({super.key}); 
  @override 
  State<DashboardScreen> createState() => _DashboardScreenState(); 
} 
 
class _DashboardScreenState extends State<DashboardScreen> { 
  List<Map<String, dynamic>> _recs = []; 
  bool _loadingRecs = true; 
  int _selectedMood = -1; 
 
  @override 
  void initState() { 
    super.initState(); 
    _loadRecs(); 
  } 
 
  Future<void> _loadRecs() async { 
    try { 
      final c   = await ApiClient.getInstance(); 
      final res = await c.get('/api/recommendations/today'); 
      if (res.statusCode == 200 && mounted) { 
        setState(() { 
          _recs        = List<Map<String, dynamic>>.from(res.data['recommendations'] ?? []); 
          _loadingRecs = false; 
        }); 
      } 
    } catch (_) { 
      if (mounted) setState(() => _loadingRecs = false); 
    } 
  } 
 
  Future<void> _logMood(int score) async { 
    setState(() => _selectedMood = score); 
    try { 
      final c = await ApiClient.getInstance(); 
      await c.post('/api/signals/mood', data: {'mood_score': score}); 
      _loadRecs(); 
    } catch (_) {} 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.home; 
    final user  = context.watch<AuthService>().currentUser; 
 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'home', 
        child: SafeArea( 
          child: CustomScrollView( 
            slivers: [ 
              // Header 
              SliverToBoxAdapter( 
                child: Padding( 
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 0), 
                  child: Row(children: [ 
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                      Text('WELCOME BACK', style: GoogleFonts.inter( 
                        fontSize: 10, letterSpacing: 0.18, fontWeight: FontWeight.w700, 
                        color: theme.accentColor, 
                      )), 
                      const SizedBox(height: 5), 
                      Text("Hey ${user?.displayName ?? 'there'}, you're safe here.", 
                        style: GoogleFonts.inter( 
                          fontSize: 22, fontWeight: FontWeight.w700, color: theme.textPrimary, 
                        )), 
                      const SizedBox(height: 3), 
                      Text('Pick a practice or follow today\'s focus.', 
                        style: GoogleFonts.inter(fontSize: 13, color: theme.textSecondary)), 
                    ])), 
                    IconButton( 
                      icon: Icon(Icons.logout_rounded, color: theme.textSecondary, size: 20), 
                      onPressed: () async { 
                        await context.read<AuthService>().signOut(); 
                        if (context.mounted) context.go('/signin'); 
                      }, 
                    ), 
                  ]).animate().fadeIn(duration: 400.ms), 
                ), 
              ), 
 
              // Mood check-in 
              SliverToBoxAdapter( 
                child: Padding( 
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 0), 
                  child: MoodCheckIn( 
                    selected: _selectedMood, 
                    onSelect: _logMood, 
                    theme: theme, 
                  ).animate().fadeIn(delay: 100.ms), 
                ), 
              ), 
 
              // Recommendations 
              SliverToBoxAdapter( 
                child: Padding( 
                  padding: const EdgeInsets.fromLTRB(22, 22, 22, 0), 
                  child: _loadingRecs 
                    ? _buildRecSkeleton(theme) 
                    : _recs.isEmpty 
                      ? const SizedBox.shrink() 
                      : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                          Text('For you right now', style: GoogleFonts.inter( 
                            fontSize: 10, letterSpacing: 0.18, fontWeight: FontWeight.w700, 
                            color: theme.accentColor, 
                          )), 
                          const SizedBox(height: 10), 
                          ..._recs.take(3).toList().asMap().entries.map((e) => Padding( 
                            padding: const EdgeInsets.only(bottom: 10), 
                            child: RecommendationCard(rec: e.value, rank: e.key, theme: theme) 
                                .animate().fadeIn(delay: Duration(milliseconds: 150 + e.key * 80)), 
                          )), 
                        ]), 
                ), 
              ), 
 
              // Module grid 
              SliverToBoxAdapter( 
                child: Padding( 
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 0), 
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ 
                    Text('Your wellness space', style: GoogleFonts.inter( 
                      fontSize: 17, fontWeight: FontWeight.w600, color: theme.textPrimary, 
                    )), 
                    const SizedBox(height: 14), 
                    ModuleGrid(theme: theme), 
                  ]).animate().fadeIn(delay: 200.ms), 
                ), 
              ), 
 
              const SliverToBoxAdapter(child: SizedBox(height: 100)), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildRecSkeleton(ModuleTheme theme) => Column(children: List.generate(3, (_) => 
    Container( 
      height: 80, margin: const EdgeInsets.only(bottom: 10), 
      decoration: BoxDecoration(color: theme.cardBg, borderRadius: BorderRadius.circular(14)), 
    ), 
  )); 
}
