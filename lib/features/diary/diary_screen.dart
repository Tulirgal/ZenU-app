import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/auth/auth_service.dart';
import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';

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
  bool _isWriting = false;
  
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().trackEngagement('diary', 'opened');
      _loadEntries();
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    try {
      setState(() => _isLoading = true);
      final c = await ApiClient.getInstance();
      final r = await c.get('/api/journal?limit=100');
      if (r.statusCode == 200) {
        // Backend could return an array directly or { entries: [...] }
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

  Future<void> _saveEntry() async {
    if (_contentController.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    
    try {
      final c = await ApiClient.getInstance();
      final r = await c.post('/api/journal', data: {
        'content': _contentController.text.trim(),
        'title': _titleController.text.trim().isNotEmpty ? _titleController.text.trim() : null,
      });
      if (r.statusCode == 200 || r.statusCode == 201) {
        if (r.data != null && r.data['id'] != null) {
          _entries.insert(0, JournalEntry.fromJson(r.data));
        } else {
          // reload if response format is unclear
          await _loadEntries();
        }
        _isWriting = false;
        _contentController.clear();
        _titleController.clear();
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
      });
    } catch (e) {
      debugPrint('Error deleting entry: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ZenTokens.zenFg),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text('Diary', style: GoogleFonts.inter(color: ZenTokens.zenFg, fontSize: 16)),
        actions: [
          if (!_isWriting)
            IconButton(
              icon: const Icon(Icons.add_rounded, color: ZenTokens.zenPrimary),
              onPressed: () => setState(() => _isWriting = true),
            ),
        ],
      ),
      body: ModuleBackground(
        moduleKey: 'diary',
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: ZenTokens.zenPrimary))
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isWriting ? _buildWriteView() : _buildListView(),
              ),
      ),
    );
  }

  Widget _buildListView() {
    if (_entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.book_rounded, size: 64, color: ZenTokens.zenBorderSoft),
            const SizedBox(height: 16),
            Text(
              'No reflections yet.',
              style: GoogleFonts.inter(fontSize: 16, color: ZenTokens.zenFgMuted),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() => _isWriting = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: ZenTokens.zenPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTokens.radiusZenXl)),
              ),
              child: Text('Write your first entry', style: GoogleFonts.inter(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final entry = _entries[index];
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ZenTokens.zenSurface,
            borderRadius: BorderRadius.circular(ZenTokens.radiusZen2xl),
            border: Border.all(color: ZenTokens.zenBorderSoft),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year}',
                    style: GoogleFonts.inter(fontSize: 12, color: ZenTokens.zenFgMuted),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: ZenTokens.zenDanger),
                    onPressed: () => _deleteEntry(entry.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              if (entry.title != null && entry.title!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  entry.title!,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: ZenTokens.zenFg),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                entry.content,
                style: GoogleFonts.inter(fontSize: 14, color: ZenTokens.zenFg, height: 1.5),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWriteView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ZenTokens.zenSurface,
          borderRadius: BorderRadius.circular(ZenTokens.radiusZen2xl),
          border: Border.all(color: ZenTokens.zenBorderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: ZenTokens.zenFg),
              decoration: InputDecoration(
                hintText: 'Title (Optional)',
                hintStyle: GoogleFonts.inter(color: ZenTokens.zenFgMuted.withValues(alpha: 0.5)),
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            TextField(
              controller: _contentController,
              maxLines: 12,
              style: GoogleFonts.inter(fontSize: 15, color: ZenTokens.zenFg, height: 1.6),
              decoration: InputDecoration(
                hintText: 'What is on your mind?',
                hintStyle: GoogleFonts.inter(color: ZenTokens.zenFgMuted.withValues(alpha: 0.5)),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() => _isWriting = false);
                    _contentController.clear();
                    _titleController.clear();
                  },
                  child: const Text('Cancel', style: TextStyle(color: ZenTokens.zenFgMuted)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ZenTokens.zenPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTokens.radiusZenLg)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: _isSaving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Keep Safely', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
