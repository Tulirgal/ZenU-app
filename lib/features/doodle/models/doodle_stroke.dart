import 'package:flutter/material.dart';

enum DoodleToolType { draw, eraser, fill }

class DoodleStroke {
  final List<Offset> points;
  final Color color;
  final double size;
  final DoodleToolType toolType;

  DoodleStroke({
    required this.points,
    required this.color,
    required this.size,
    required this.toolType,
  });

  DoodleStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    DoodleToolType? toolType,
  }) {
    return DoodleStroke(
      points: points ?? List.from(this.points),
      color: color ?? this.color,
      size: size ?? this.size,
      toolType: toolType ?? this.toolType,
    );
  }
}
