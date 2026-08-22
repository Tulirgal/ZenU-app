import 'package:flutter/material.dart';

class PatternMotifVisual extends StatelessWidget {
  final double size;
  final bool isActive;

  const PatternMotifVisual({
    super.key,
    this.size = 64,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    // Generate some elegant concentric rings
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6B93F7).withValues(alpha: 0.15),
                width: size * 0.05,
              ),
              color: const Color(0xFFF0F4FF).withValues(alpha: 0.5),
            ),
          ),
          // Middle ring (thicker)
          Container(
            width: size * 0.75,
            height: size * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF5B71D0).withValues(alpha: isActive ? 0.6 : 0.4),
                width: size * 0.08,
              ),
            ),
          ),
          // Inner dot
          Container(
            width: size * 0.35,
            height: size * 0.35,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFF86A8FB),
                  Color(0xFF5B71D0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x605B71D0),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
