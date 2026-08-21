import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../core/api/api_client.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class DiaryScreen extends StatefulWidget { 
  const DiaryScreen({super.key}); 
  @override 
  State<DiaryScreen> createState() => _DiaryScreenState(); 
} 
 
class _DiaryScreenState extends State<DiaryScreen> { 
  final _ctrl = TextEditingController(); 
  List<Map<String, dynamic>> _entries = []; 
  bool _isWriting = false; 
  bool _loading = true; 
 
  @override 
  void initState() { 
    super.initState(); 
    _logEngagement(); 
    _loadEntries(); 
  } 
 
  Future<void> _logEngagement() async { 
    try { 
      final c = await ApiClient.getInstance(); 
      await c.post('/api/signals/engagement', data: {'module_id': 'diary', 'event_type': 'opened'}); 
    } catch (_) {} 
  } 
 
  Future<void> _loadEntries() async { 
    setState(() => _loading = true); 
    try { 
      final c = await ApiClient.getInstance(); 
      final res = await c.get('/api/journal'); 
      if (res.statusCode == 200 && mounted) { 
        setState(() { 
          _entries = List<Map<String, dynamic>>.from(res.data['entries'] ?? []); 
          _loading = false; 
        }); 
      } 
    } catch (_) { 
      if (mounted) setState(() => _loading = false); 
    } 
  } 
 
  Future<void> _save() async { 
    final text = _ctrl.text.trim(); 
    if (text.isEmpty) return; 
    try { 
      final c = await ApiClient.getInstance(); 
      await c.post('/api/journal', data: {'content': text}); 
      _ctrl.clear(); 
      setState(() => _isWriting = false); 
      _loadEntries(); 
    } catch (_) {} 
  } 
 
  @override 
  void dispose() { 
    _ctrl.dispose(); 
    super.dispose(); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.diary; 
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar( 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: IconThemeData(color: theme.textPrimary), 
        title: Text('My Diary', style: GoogleFonts.inter(color: theme.textPrimary, fontWeight: FontWeight.w600)), 
        actions: [ 
          if (!_isWriting) 
            IconButton( 
              icon: const Icon(Icons.add_rounded), 
              onPressed: () => setState(() => _isWriting = true), 
            ), 
        ], 
      ), 
      body: ModuleBackground( 
        moduleKey: 'diary', 
        child: SafeArea( 
          child: _isWriting 
              ? _buildWriteMode(theme) 
              : _buildReadMode(theme), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildWriteMode(ModuleTheme theme) { 
    return Padding( 
      padding: const EdgeInsets.all(24.0), 
      child: Column( 
        children: [ 
          Expanded( 
            child: TextField( 
              controller: _ctrl, 
              maxLines: null, 
              expands: true, 
              style: GoogleFonts.inter(color: theme.textPrimary, fontSize: 16), 
              decoration: InputDecoration( 
                hintText: 'Dear Diary...', 
                hintStyle: GoogleFonts.inter(color: theme.textSecondary), 
                border: InputBorder.none, 
              ), 
            ), 
          ).animate().fadeIn(), 
          const SizedBox(height: 16), 
          Row( 
            children: [ 
              Expanded( 
                child: OutlinedButton( 
                  onPressed: () { 
                    _ctrl.clear(); 
                    setState(() => _isWriting = false); 
                  }, 
                  style: OutlinedButton.styleFrom( 
                    foregroundColor: theme.textPrimary, 
                    side: BorderSide(color: theme.cardBorder), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
                  ), 
                  child: const Text('Cancel'), 
                ), 
              ), 
              const SizedBox(width: 16), 
              Expanded( 
                child: ElevatedButton( 
                  onPressed: _save, 
                  style: ElevatedButton.styleFrom( 
                    backgroundColor: theme.accentColor, 
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
                  ), 
                  child: const Text('Save'), 
                ), 
              ), 
            ], 
          ).animate().slideY(begin: 0.5, end: 0).fadeIn(), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildReadMode(ModuleTheme theme) { 
    if (_loading) { 
      return const Center(child: CircularProgressIndicator()); 
    } 
    if (_entries.isEmpty) { 
      return Center( 
        child: Text('No entries yet.\nTap + to write your first entry.', 
          textAlign: TextAlign.center, 
          style: GoogleFonts.inter(color: theme.textSecondary), 
        ).animate().fadeIn(), 
      ); 
    } 
    return ListView.separated( 
      padding: const EdgeInsets.all(24), 
      itemCount: _entries.length, 
      separatorBuilder: (context, index) => const SizedBox(height: 16), 
      itemBuilder: (context, i) { 
        final e = _entries[i]; 
        final content = e['content'] as String? ?? ''; 
        final date = e['created_at'] as String? ?? ''; 
        return Container( 
          padding: const EdgeInsets.all(16), 
          decoration: BoxDecoration( 
            color: theme.cardBg, 
            borderRadius: BorderRadius.circular(16), 
            border: Border.all(color: theme.cardBorder), 
          ), 
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [ 
              Text(date, style: GoogleFonts.inter(fontSize: 11, color: theme.textSecondary)), 
              const SizedBox(height: 8), 
              Text(content, style: GoogleFonts.inter(fontSize: 15, color: theme.textPrimary)), 
            ], 
          ), 
        ).animate().fadeIn(delay: (i * 100).ms); 
      }, 
    ); 
  } 
}
