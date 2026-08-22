import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';
import 'widgets/journal_contents.dart';
import 'widgets/journal_spread.dart';
import 'widgets/journal_write_page.dart';

class JournalEntry {
  final String id;
  final String content;
  final String? title;
  final String? mood;
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.content,
    this.title,
    this.mood,
    required this.createdAt,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      title: json['title'],
      mood: json['mood'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  bool _isLoading = true;
  List<JournalEntry> _entries = [];
  bool _isOpen = false;
  
  JournalEntry? _selectedEntry; // if null, we are writing a new entry (or idle)
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().trackEngagement('diary', 'opened');
      _loadEntries();
    });
  }

  Future<void> _loadEntries() async {
    try {
      setState(() => _isLoading = true);
      final c = await ApiClient.getInstance();
      final r = await c.get('/api/journal?limit=100');
      if (r.statusCode == 200) {
        final data = r.data;
        if (data is List) {
          _entries = data.map((e) => JournalEntry.fromJson(e)).toList();
        } else if (data['entries'] != null) {
          _entries = (data['entries'] as List).map((e) => JournalEntry.fromJson(e)).toList();
        } else {
          _entries = [];
        }
      }
    } catch (e) {
      debugPrint('Failed to load journal: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveEntry(String title, String content) async {
    if (content.trim().isEmpty) return;
    setState(() => _isSaving = true);
    
    try {
      final c = await ApiClient.getInstance();
      if (_selectedEntry != null) {
        // Update
        final r = await c.put('/api/journal/${_selectedEntry!.id}', data: {
          'content': content.trim(),
          'title': title.trim().isNotEmpty ? title.trim() : null,
        });
        if (r.statusCode == 200) {
          final updated = JournalEntry.fromJson(r.data);
          final index = _entries.indexWhere((e) => e.id == _selectedEntry!.id);
          if (index != -1) {
            _entries[index] = updated;
          }
          _selectedEntry = updated;
        }
      } else {
        // Create
        final r = await c.post('/api/journal', data: {
          'content': content.trim(),
          'title': title.trim().isNotEmpty ? title.trim() : null,
        });
        if (r.statusCode == 200 || r.statusCode == 201) {
          if (r.data != null && r.data['id'] != null) {
            final newEntry = JournalEntry.fromJson(r.data);
            _entries.insert(0, newEntry);
            _selectedEntry = newEntry;
          } else {
            await _loadEntries();
          }
        }
      }
    } catch (e) {
      debugPrint('Error saving entry: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save entry.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteEntry(String id) async {
    try {
      final c = await ApiClient.getInstance();
      await c.delete('/api/journal/$id');
      setState(() {
        _entries.removeWhere((e) => e.id == id);
        if (_selectedEntry?.id == id) {
          _selectedEntry = null; // back to write mode
        }
      });
    } catch (e) {
      debugPrint('Error deleting entry: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'diary',
        child: SafeArea(
          child: Column(
            children: [
              // Navigation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/dashboard'),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            'Journal',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Header text when closed
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isOpen ? 0.0 : 1.0,
                child: IgnorePointer(
                  ignoring: _isOpen,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MY JOURNAL',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.0,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your private space',
                          style: GoogleFonts.lora(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Open the book. Write things down. You don\'t have to make them perfect.',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // The 3D Book Layout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: JournalSpread(
                  isOpen: _isOpen,
                  onOpen: () => setState(() => _isOpen = true),
                  onClose: () => setState(() => _isOpen = false),
                  leftPage: JournalContents(
                    entries: _entries,
                    isLoading: _isLoading,
                    selectedId: _selectedEntry?.id,
                    onSelect: (entry) {
                      setState(() {
                        _selectedEntry = entry;
                      });
                    },
                    onWrite: () {
                      setState(() {
                        _selectedEntry = null; // null means new entry
                      });
                    },
                  ),
                  rightPage: JournalWritePage(
                    entry: _selectedEntry,
                    isSaving: _isSaving,
                    onSave: _saveEntry,
                    onDelete: _deleteEntry,
                    onCancel: () {
                      if (_selectedEntry == null && _entries.isNotEmpty) {
                        setState(() {
                          _selectedEntry = _entries.first;
                        });
                      }
                    },
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
