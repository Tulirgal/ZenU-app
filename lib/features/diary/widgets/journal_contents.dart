import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../diary_screen.dart'; // For JournalEntry model

class JournalContents extends StatelessWidget {
  final List<JournalEntry> entries;
  final bool isLoading;
  final String? selectedId;
  final Function(JournalEntry) onSelect;
  final VoidCallback onWrite;

  const JournalContents({
    super.key,
    required this.entries,
    required this.isLoading,
    this.selectedId,
    required this.onSelect,
    required this.onWrite,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5A2B)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contents',
                style: GoogleFonts.lora(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C1E16),
                ),
              ),
              IconButton(
                onPressed: onWrite,
                icon: const Icon(Icons.add_rounded, color: Color(0xFF8B5A2B)),
                tooltip: 'Write new entry',
              ),
            ],
          ),
        ),
        
        // List
        Expanded(
          child: entries.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  itemCount: entries.length,
                  separatorBuilder: (context, index) => const Divider(color: Color(0x338B5A2B), height: 1),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final isSelected = entry.id == selectedId;
                    return InkWell(
                      onTap: () => onSelect(entry),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF8B5A2B).withValues(alpha: 0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.createdAt.day}/${entry.createdAt.month}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8B5A2B),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (entry.title != null && entry.title!.isNotEmpty)
                                    Text(
                                      entry.title!,
                                      style: GoogleFonts.lora(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2C1E16),
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: const Color(0xFF5A4A42),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_rounded, size: 48, color: Color(0x668B5A2B)),
          const SizedBox(height: 16),
          Text(
            'The pages are blank.',
            style: GoogleFonts.lora(
              fontSize: 18,
              color: const Color(0xFF5A4A42),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start writing your first reflection.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF8B5A2B),
            ),
          ),
        ],
      ),
    );
  }
}
