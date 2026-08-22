import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JournalCover extends StatelessWidget {
  final bool isOpen;
  final VoidCallback? onOpen;

  const JournalCover({
    super.key,
    required this.isOpen,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    // We animate from 0 (closed) to -pi * 0.95 (open, swung to the left)
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: isOpen ? -math.pi * 0.95 : 0.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
      builder: (context, value, child) {
        // If the cover is open, we fade it out slightly so it doesn't distract,
        // or just let it sit there. The React version sets opacity to 0 when settled open,
        // but since we are pivoting it behind, we can just fade it out if value is close to end.
        final opacity = (1 - (value.abs() / (math.pi * 0.95))).clamp(0.0, 1.0);

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(value),
          alignment: Alignment.centerLeft, // Hinge on the left spine
          child: Opacity(
            opacity: opacity < 0.2 ? 0.0 : 1.0, // hide completely when fully open
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (!isOpen && onOpen != null) {
            onOpen!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(2),
              bottomLeft: Radius.circular(2),
            ),
            border: Border.all(
              color: const Color(0xFF8B5A2B).withValues(alpha: 0.35),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF805A40), // lighter leather
                Color(0xFF5C3F2B), // mid leather
                Color(0xFF452D1F), // dark leather
              ],
              stops: [0.0, 0.55, 1.0],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x59281C10),
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Spine shadow inside the cover
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 12,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3E2818), Color(0xFF6B4D36)],
                    ),
                  ),
                ),
              ),
              // Content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'MY JOURNAL',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                        color: const Color(0xFFEFE2C8).withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Private pages',
                      style: GoogleFonts.lora(
                        fontSize: 32,
                        color: const Color(0xFFF5EFE6),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to open',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFFEFE2C8).withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              // Top sheen
              Positioned(
                top: 0,
                left: 24,
                right: 24,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
