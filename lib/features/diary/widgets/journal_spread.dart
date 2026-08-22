import 'package:flutter/material.dart';
import 'journal_cover.dart';

class JournalSpread extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onOpen;
  final Widget leftPage;
  final Widget rightPage;
  final VoidCallback onClose;

  const JournalSpread({
    super.key,
    required this.isOpen,
    required this.onOpen,
    required this.leftPage,
    required this.rightPage,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        final closedWidth = 300.0;
        final openWidth = isDesktop ? 920.0 : constraints.maxWidth;
        final targetWidth = isOpen ? openWidth : closedWidth;

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOutCubic,
                width: targetWidth,
                height: isDesktop ? 600 : constraints.maxHeight * 0.7, // Responsive height
                constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.8),
                child: Stack(
                  children: [
                    // The inner book shell and pages
                    Positioned.fill(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: isOpen ? 1.0 : 0.0,
                        curve: const Interval(0.2, 1.0),
                        child: IgnorePointer(
                          ignoring: !isOpen,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F6F0),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFDCD3C6)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33281C10),
                                  blurRadius: 40,
                                  offset: Offset(0, 20),
                                ),
                              ],
                            ),
                            child: isDesktop
                                ? Row(
                                    children: [
                                      // Left Page (Contents)
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(32),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                color: Color(0xFFDCD3C6),
                                              ),
                                            ),
                                          ),
                                          child: leftPage,
                                        ),
                                      ),
                                      // Spine line
                                      Container(
                                        width: 1,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withValues(alpha: 0.1),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Right Page (Editor)
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(32),
                                          child: rightPage,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      // Mobile layout stacks them or just shows right page if editing
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(24),
                                          child: rightPage,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    // The 3D Cover (hinged at the center if open on desktop, left if closed)
                    // We need it to be centered when closed, and attached to the left spine when open.
                    // On desktop, the book is width: 920 when open. The spine is at width: 460.
                    // So the cover should be positioned at the spine.
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOutCubic,
                      top: 0,
                      bottom: 0,
                      left: isOpen && isDesktop ? (targetWidth / 2) : 0,
                      right: isOpen && isDesktop ? 0 : 0,
                      child: JournalCover(
                        isOpen: isOpen,
                        onOpen: onOpen,
                      ),
                    ),
                  ],
                ),
              ),
              // Close button when open
              if (isOpen)
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: TextButton(
                    onPressed: onClose,
                    child: const Text(
                      'Close journal',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
