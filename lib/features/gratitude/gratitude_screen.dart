import 'dart:math'; 
import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import 'package:flutter_animate/flutter_animate.dart'; 
import '../../core/api/api_client.dart'; 
import '../../core/theme/module_themes.dart'; 
import '../../shared/widgets/module_background.dart'; 
 
class GratitudeScreen extends StatefulWidget { 
  const GratitudeScreen({super.key}); 
  @override 
  State<GratitudeScreen> createState() => _GratitudeScreenState(); 
} 
 
class _GratitudeScreenState extends State<GratitudeScreen> { 
  List<Map<String, dynamic>> _entries = []; 
  bool _loading = true; 
 
  @override 
  void initState() { 
    super.initState(); 
    _loadEntries(); 
  } 
 
  Future<void> _loadEntries() async { 
    setState(() => _loading = true); 
    try { 
      final c = await ApiClient.getInstance(); 
      var res = await c.get('/api/gratitude'); 
      if (res.statusCode != 200) { 
        res = await c.get('/api/journal?type=gratitude'); 
      } 
      if (res.statusCode == 200 && mounted) { 
        setState(() { 
          _entries = List<Map<String, dynamic>>.from(res.data['entries'] ?? res.data['gratitude'] ?? []); 
        }); 
      } 
    } catch (_) {} 
    if (mounted) setState(() => _loading = false); 
  } 
 
  Future<void> _addMoment(String text) async { 
    if (text.trim().isEmpty) return; 
    try { 
      final c = await ApiClient.getInstance(); 
      try { 
        await c.post('/api/gratitude', data: {'content': text}); 
      } catch (_) { 
        await c.post('/api/journal', data: {'content': text, 'type': 'gratitude'}); 
      } 
      _loadEntries(); 
    } catch (_) {} 
  } 
 
  void _showAddModal(ModuleTheme theme) { 
    final ctrl = TextEditingController(); 
    showModalBottomSheet( 
      context: context, 
      backgroundColor: theme.cardBg, 
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), 
      builder: (ctx) => Padding( 
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 24, right: 24, top: 24), 
        child: Column( 
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [ 
            Text("I'm grateful for...", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: theme.textPrimary)), 
            const SizedBox(height: 16), 
            TextField( 
              controller: ctrl, 
              autofocus: true, 
              style: GoogleFonts.inter(color: theme.textPrimary), 
              decoration: InputDecoration( 
                hintText: 'A warm cup of coffee, a friend, sunshine...', 
                hintStyle: GoogleFonts.inter(color: theme.textSecondary), 
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.cardBorder)), 
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.accentColor)), 
              ), 
            ), 
            const SizedBox(height: 24), 
            SizedBox( 
              width: double.infinity, height: 50, 
              child: ElevatedButton( 
                onPressed: () { 
                  _addMoment(ctrl.text); 
                  Navigator.pop(ctx); 
                }, 
                style: ElevatedButton.styleFrom(backgroundColor: theme.accentColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999))), 
                child: const Text('Save into Jar'), 
              ), 
            ), 
            const SizedBox(height: 24), 
          ], 
        ), 
      ), 
    ); 
  } 
 
  void _pickMemory(ModuleTheme theme) { 
    if (_entries.isEmpty) return; 
    final rnd = _entries[Random().nextInt(_entries.length)]; 
    final content = rnd['content'] as String? ?? ''; 
     
    showDialog( 
      context: context, 
      builder: (ctx) => AlertDialog( 
        backgroundColor: theme.cardBg, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: theme.cardBorder)), 
        title: const Text('🐼', textAlign: TextAlign.center, style: TextStyle(fontSize: 48)), 
        content: Text(content, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 16, color: theme.textPrimary, fontStyle: FontStyle.italic)), 
        actions: [ 
          Center( 
            child: TextButton( 
              onPressed: () => Navigator.pop(ctx), 
              child: Text('Close', style: GoogleFonts.inter(color: theme.accentColor)), 
            ), 
          ) 
        ], 
      ), 
    ); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    final theme = ModuleThemes.gratitude; 
    return Scaffold( 
      extendBodyBehindAppBar: true, 
      appBar: AppBar( 
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: IconThemeData(color: theme.textPrimary), 
      ), 
      body: ModuleBackground( 
        moduleKey: 'gratitude', 
        child: SafeArea( 
          child: Column( 
            children: [ 
              const SizedBox(height: 10), 
              const Text('🐼', style: TextStyle(fontSize: 48)).animate().scaleXY(duration: 800.ms), 
              const SizedBox(height: 8), 
              Text('Your desk of tiny thankful moments', 
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: theme.textPrimary), 
              ).animate().fadeIn(), 
              const SizedBox(height: 32), 
               
              // Jar 
              Expanded( 
                child: Padding( 
                  padding: const EdgeInsets.symmetric(horizontal: 40), 
                  child: Container( 
                    width: double.infinity, 
                    padding: const EdgeInsets.all(20), 
                    decoration: BoxDecoration( 
                      color: theme.accentColor.withValues(alpha: 0.1), 
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(60), top: Radius.circular(10)), 
                      border: Border.all(color: theme.accentColor.withValues(alpha: 0.3), width: 3), 
                    ), 
                    child: _loading  
                      ? const Center(child: CircularProgressIndicator()) 
                      : _entries.isEmpty 
                        ? Center(child: Text('Jar is empty', style: GoogleFonts.inter(color: theme.textSecondary))) 
                        : Wrap( 
                            spacing: 8, runSpacing: 8, 
                            alignment: WrapAlignment.center, 
                            children: _entries.map((e) => Container( 
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), 
                              decoration: BoxDecoration( 
                                color: theme.cardBg, 
                                borderRadius: BorderRadius.circular(12), 
                                border: Border.all(color: theme.cardBorder), 
                              ), 
                              child: const Text('📜', style: TextStyle(fontSize: 16)), 
                            )).toList(), 
                          ).animate().fadeIn(), 
                  ), 
                ), 
              ), 
              const SizedBox(height: 32), 
               
              // Buttons 
              Padding( 
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32), 
                child: Row( 
                  children: [ 
                    Expanded( 
                      child: ElevatedButton.icon( 
                        onPressed: () => _showAddModal(theme), 
                        icon: const Icon(Icons.add), 
                        label: const Text('Add a moment'), 
                        style: ElevatedButton.styleFrom( 
                          backgroundColor: theme.accentColor, 
                          foregroundColor: Colors.white, 
                          padding: const EdgeInsets.symmetric(vertical: 14), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), 
                        ), 
                      ), 
                    ), 
                    const SizedBox(width: 16), 
                    Expanded( 
                      child: OutlinedButton.icon( 
                        onPressed: _entries.isEmpty ? null : () => _pickMemory(theme), 
                        icon: const Icon(Icons.favorite), 
                        label: const Text('Pick a memory'), 
                        style: OutlinedButton.styleFrom( 
                          foregroundColor: theme.accentColor, 
                          side: BorderSide(color: theme.accentColor), 
                          padding: const EdgeInsets.symmetric(vertical: 14), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), 
                        ), 
                      ), 
                    ), 
                  ], 
                ).animate().slideY(begin: 0.5, end: 0).fadeIn(), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
}
