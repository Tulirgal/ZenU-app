import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../diary_screen.dart'; // For JournalEntry model

class JournalWritePage extends StatefulWidget {
  final JournalEntry? entry; // if null, we are writing a new one. If non-null, reading/editing.
  final bool isSaving;
  final Function(String title, String content)? onSave;
  final Function(String id)? onDelete;
  final VoidCallback onCancel;

  const JournalWritePage({
    super.key,
    this.entry,
    this.isSaving = false,
    this.onSave,
    this.onDelete,
    required this.onCancel,
  });

  @override
  State<JournalWritePage> createState() => _JournalWritePageState();
}

class _JournalWritePageState extends State<JournalWritePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.entry == null; // if new, start editing
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
  }

  @override
  void didUpdateWidget(covariant JournalWritePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entry?.id != oldWidget.entry?.id) {
      _isEditing = widget.entry == null;
      _titleController.text = widget.entry?.title ?? '';
      _contentController.text = widget.entry?.content ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (widget.onSave != null) {
      widget.onSave!(_titleController.text, _contentController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing && widget.entry != null) {
      return _buildReadView();
    }
    return _buildWriteView();
  }

  Widget _buildReadView() {
    final entry = widget.entry!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year}',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8B5A2B),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit_rounded, size: 18, color: Color(0xFF5A4A42)),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () {
                    if (widget.onDelete != null) widget.onDelete!(entry.id);
                  },
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (entry.title != null && entry.title!.isNotEmpty)
          Text(
            entry.title!,
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C1E16),
            ),
          ),
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              entry.content,
              style: GoogleFonts.lora(
                fontSize: 16,
                color: const Color(0xFF2C1E16),
                height: 1.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWriteView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _titleController,
          style: GoogleFonts.lora(fontSize: 28, fontWeight: FontWeight.w600, color: const Color(0xFF2C1E16)),
          decoration: InputDecoration(
            hintText: 'Title (Optional)',
            hintStyle: GoogleFonts.lora(color: const Color(0xFF2C1E16).withValues(alpha: 0.3)),
            border: InputBorder.none,
          ),
        ),
        const Divider(color: Color(0x338B5A2B)),
        Expanded(
          child: TextField(
            controller: _contentController,
            maxLines: null,
            expands: true,
            style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF2C1E16), height: 1.8),
            decoration: InputDecoration(
              hintText: 'What is on your mind?',
              hintStyle: GoogleFonts.lora(color: const Color(0xFF2C1E16).withValues(alpha: 0.3)),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                if (widget.entry != null) {
                  setState(() => _isEditing = false); // revert to read view
                  _titleController.text = widget.entry!.title ?? '';
                  _contentController.text = widget.entry!.content;
                } else {
                  widget.onCancel();
                }
              },
              child: Text(
                'Cancel', 
                style: GoogleFonts.inter(color: const Color(0xFF5A4A42)),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: widget.isSaving ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5A2B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: widget.isSaving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('Keep Safely', style: GoogleFonts.inter(fontWeight: FontWeight.w500)),
            ),
          ],
        )
      ],
    );
  }
}
