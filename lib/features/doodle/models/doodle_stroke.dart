import 'dart:ui' as ui;
import 'package:flutter/material.dart';

enum DoodleToolType { draw, eraser, fill }

class DoodleStroke {
  final List<Offset> points;
  final Color color;
  final double size;
  final DoodleToolType toolType;
  final ui.Image? image;

  DoodleStroke({
    required this.points,
    required this.color,
    required this.size,
    required this.toolType,
    this.image,
  });

  DoodleStroke copyWith({
    List<Offset>? points,
    Color? color,
    double? size,
    DoodleToolType? toolType,
    ui.Image? image,
  }) {
    return DoodleStroke(
      points: points ?? List.from(this.points),
      color: color ?? this.color,
      size: size ?? this.size,
      toolType: toolType ?? this.toolType,
      image: image ?? this.image,
    );
  }
}
