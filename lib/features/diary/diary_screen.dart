import 'package:flutter/material.dart'; 
import 'package:go_router/go_router.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
import '../../core/theme/app_theme.dart'; 
import '../../shared/widgets/module_background.dart'; 
import 'package:intl/intl.dart'; 
 
class JournalEntry { 
  final String id; 
  final String title; 
  final String? mood; 
  final String content; 
  final DateTime createdAt; 
 
  JournalEntry({ 
    required this.id, 
    required this.title, 
    this.mood, 
    required this.content, 
    required this.createdAt, 
  }); 
} 
 
class DiaryScreen extends StatefulWidget { 
  const DiaryScreen({super.key}); 
 
  @override 
  State<DiaryScreen> createState() => _DiaryScreenState(); 
} 
 
class _DiaryScreenState extends State<DiaryScreen> { 
  final List<JournalEntry> _entries = []; 
  bool _isWriting = false; 
   
  final TextEditingController _titleCtrl = TextEditingController(); 
  final TextEditingController _contentCtrl = TextEditingController(); 
  String? _selectedMood; 
 
  final List<String> _moodOptions = [ 
    'Anxious', 'Calm', 'Creative', 'Depressed', 'Energetic', 
    'Focused', 'Grateful', 'Happy', 'Overwhelmed', 'Sad', 
    'Stressed', 'Tired' 
  ]; 
 
  void _startWriting() { 
    _titleCtrl.clear(); 
    _contentCtrl.clear(); 
    _selectedMood = null; 
    setState(() { 
      _isWriting = true; 
    }); 
  } 
 
  void _cancelWriting() { 
    setState(() { 
      _isWriting = false; 
    }); 
  } 
 
  void _saveEntry() { 
    if (_contentCtrl.text.trim().isEmpty) return; 
    final entry = JournalEntry( 
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      title: _titleCtrl.text.trim().isNotEmpty ? _titleCtrl.text.trim() : 'Untitled', 
      mood: _selectedMood, 
      content: _contentCtrl.text.trim(), 
      createdAt: DateTime.now(), 
    ); 
    setState(() { 
      _entries.insert(0, entry); 
      _isWriting = false; 
    }); 
  } 
 
  @override 
  void dispose() { 
    _titleCtrl.dispose(); 
    _contentCtrl.dispose(); 
    super.dispose(); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: ModuleBackground( 
        moduleKey: 'diary', // NextJS uses 'diary' for Journal 
        child: SafeArea( 
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [ 
              Align( 
                alignment: Alignment.centerLeft, 
                child: Padding( 
                  padding: const EdgeInsets.only(left: 16, top: 12), 
                  child: IconButton( 
                    onPressed: () { 
                      if (_isWriting) { 
                        _cancelWriting(); 
                      } else { 
                        context.pop(); 
                      } 
                    }, 
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87), 
                  ), 
                ), 
              ), 
              Expanded( 
                child: AnimatedSwitcher( 
                  duration: const Duration(milliseconds: 300), 
                  child: _isWriting ? _buildWriteView() : _buildContentsView(), 
                ), 
              ), 
            ], 
          ), 
        ), 
      ), 
    ); 
  } 
 
  Widget _buildContentsView() { 
    return Container( 
      key: const ValueKey('contents'), 
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: [ 
          Text( 
            'CONTENTS', 
            style: GoogleFonts.inter( 
              fontSize: 10, 
              fontWeight: FontWeight.w600, 
              letterSpacing: 1.4, 
              color: Colors.black54, 
            ), 
          ), 
          const SizedBox(height: 4), 
          Text( 
            'Your pages', 
            style: GoogleFonts.lora( 
              fontSize: 24, 
              fontWeight: FontWeight.w600, 
              color: Colors.black87, 
              letterSpacing: -0.5, 
            ), 
          ), 
          const SizedBox(height: 24), 
           
          Expanded( 
            child: _entries.isEmpty 
                ? Center( 
                    child: Text( 
                      'Nothing written yet. The right page is waiting for your first reflection.', 
                      textAlign: TextAlign.center, 
                      style: GoogleFonts.inter( 
                        fontSize: 14, 
                        color: Colors.black54, 
                        height: 1.6, 
                      ), 
                    ), 
                  ) 
                : ListView.separated( 
                    itemCount: _entries.length, 
                    separatorBuilder: (context, index) => const SizedBox(height: 8), 
                    itemBuilder: (context, index) { 
                      final entry = _entries[index]; 
                      return InkWell( 
                        onTap: () {}, // Future: view/edit entry 
                        borderRadius: BorderRadius.circular(8), 
                        child: Container( 
                          padding: const EdgeInsets.all(12), 
                          decoration: BoxDecoration( 
                            color: Colors.white.withValues(alpha: 0.6), 
                            borderRadius: BorderRadius.circular(8), 
                            border: Border.all(color: Colors.black.withValues(alpha: 0.05)), 
                          ), 
                          child: Column( 
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [ 
                              Row( 
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                children: [ 
                                  Expanded( 
                                    child: Text( 
                                      entry.title, 
                                      style: GoogleFonts.lora( 
                                        fontSize: 16, 
                                        fontWeight: FontWeight.w600, 
                                        color: Colors.black87, 
                                      ), 
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis, 
                                    ), 
                                  ), 
                                  if (entry.mood != null) 
                                    Container( 
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                                      decoration: BoxDecoration( 
                                        color: ZenTokens.primary.withValues(alpha: 0.1), 
                                        borderRadius: BorderRadius.circular(12), 
                                      ), 
                                      child: Text( 
                                        entry.mood!, 
                                        style: GoogleFonts.inter( 
                                          fontSize: 10, 
                                          fontWeight: FontWeight.w500, 
                                          color: ZenTokens.primary, 
                                        ), 
                                      ), 
                                    ), 
                                ], 
                              ), 
                              const SizedBox(height: 4), 
                              Text( 
                                entry.content, 
                                maxLines: 1, 
                                overflow: TextOverflow.ellipsis, 
                                style: GoogleFonts.inter( 
                                  fontSize: 12, 
                                  color: Colors.black54, 
                                ), 
                              ), 
                              const SizedBox(height: 8), 
                              Text( 
                                DateFormat('MMMM d, yyyy').format(entry.createdAt), 
                                style: GoogleFonts.inter( 
                                  fontSize: 10, 
                                  color: Colors.black38, 
                                ), 
                              ), 
                            ], 
                          ), 
                        ), 
                      ); 
                    }, 
                  ), 
          ), 
           
          const SizedBox(height: 16), 
          Container( 
            decoration: BoxDecoration( 
              border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.1))), 
            ), 
            padding: const EdgeInsets.only(top: 16), 
            child: TextButton.icon( 
              onPressed: _startWriting, 
              icon: const Icon(Icons.add, size: 18), 
              label: const Text('+ Write a new reflection'), 
              style: TextButton.styleFrom( 
                foregroundColor: ZenTokens.primary, 
                alignment: Alignment.centerLeft, 
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12), 
                textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500), 
              ), 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
 
  Widget _buildWriteView() { 
    return Container( 
      key: const ValueKey('write'), 
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: [ 
          Text( 
            'NEW PAGE', 
            style: GoogleFonts.inter( 
              fontSize: 10, 
              fontWeight: FontWeight.w600, 
              letterSpacing: 1.4, 
              color: Colors.black54, 
            ), 
          ), 
          const SizedBox(height: 4), 
          Text( 
            'Write a reflection', 
            style: GoogleFonts.lora( 
              fontSize: 24, 
              fontWeight: FontWeight.w600, 
              color: Colors.black87, 
              letterSpacing: -0.5, 
            ), 
          ), 
          const SizedBox(height: 4), 
          Text( 
            'Only you can see this. You don\'t have to make it perfect.', 
            style: GoogleFonts.inter( 
              fontSize: 14, 
              color: Colors.black54, 
            ), 
          ), 
          const SizedBox(height: 24), 
           
          Expanded( 
            child: SingleChildScrollView( 
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [ 
                  TextField( 
                    controller: _titleCtrl, 
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500), 
                    decoration: InputDecoration( 
                      labelText: 'Title', 
                      hintText: 'A thought for today...', 
                      labelStyle: GoogleFonts.inter(color: Colors.black54), 
                      hintStyle: GoogleFonts.inter(color: Colors.black38), 
                      filled: true, 
                      fillColor: Colors.white.withValues(alpha: 0.6), 
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), 
                    ), 
                  ), 
                  const SizedBox(height: 16), 
                   
                  Text( 
                    'Mood / feeling (optional)', 
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54), 
                  ), 
                  const SizedBox(height: 8), 
                  InputDecorator(
                    decoration: InputDecoration( 
                      filled: true, 
                      fillColor: Colors.white.withValues(alpha: 0.6), 
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none), 
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ), 
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>( 
                        value: _selectedMood, 
                        hint: Text('How are you arriving?', style: GoogleFonts.inter(color: Colors.black38)), 
                        isExpanded: true,
                        items: _moodOptions.map((mood) { 
                          return DropdownMenuItem(value: mood, child: Text(mood)); 
                        }).toList(), 
                        onChanged: (val) { 
                          setState(() { 
                            _selectedMood = val; 
                          }); 
                        }, 
                      ),
                    ), 
                  ), 
                  const SizedBox(height: 16), 
                   
                  // Ruled text area 
                  Container( 
                    constraints: const BoxConstraints(minHeight: 200), 
                    decoration: BoxDecoration( 
                      color: Colors.white.withValues(alpha: 0.6), 
                      borderRadius: BorderRadius.circular(8), 
                    ), 
                    child: TextField( 
                      controller: _contentCtrl, 
                      maxLines: null, 
                      minLines: 10, 
                      style: GoogleFonts.inter(fontSize: 16, color: Colors.black87, height: 1.75), 
                      decoration: InputDecoration( 
                        hintText: 'Start writing...', 
                        hintStyle: GoogleFonts.inter(color: Colors.black38), 
                        border: InputBorder.none, 
                        contentPadding: const EdgeInsets.all(16), 
                      ), 
                    ), 
                  ), 
                ], 
              ), 
            ), 
          ), 
           
          const SizedBox(height: 16), 
          Container( 
            decoration: BoxDecoration( 
              border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.1))), 
            ), 
            padding: const EdgeInsets.only(top: 16), 
            child: Row( 
              children: [ 
                Expanded( 
                  child: OutlinedButton( 
                    onPressed: _cancelWriting, 
                    style: OutlinedButton.styleFrom( 
                      padding: const EdgeInsets.symmetric(vertical: 14), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), 
                      side: BorderSide(color: Colors.black.withValues(alpha: 0.2)), 
                    ), 
                    child: Text('Cancel', style: GoogleFonts.inter(color: Colors.black87, fontWeight: FontWeight.w500)), 
                  ), 
                ), 
                const SizedBox(width: 12), 
                Expanded( 
                  child: ElevatedButton( 
                    onPressed: _saveEntry, 
                    style: ElevatedButton.styleFrom( 
                      backgroundColor: ZenTokens.primary, 
                      padding: const EdgeInsets.symmetric(vertical: 14), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), 
                      elevation: 0, 
                    ), 
                    child: Text('Save', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)), 
                  ), 
                ), 
              ], 
            ), 
          ), 
        ], 
      ), 
    ); 
  } 
}
