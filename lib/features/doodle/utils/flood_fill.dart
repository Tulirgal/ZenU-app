import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class FloodFillUtils {
  /// Computes a flood fill overlay image.
  /// [picture] is the current canvas state.
  /// [size] is the logical size of the canvas.
  /// [touchPoint] is the local coordinate where the user tapped.
  /// [fillColor] is the color to fill with.
  /// Returns a ui.Image that contains ONLY the filled pixels, with a transparent background.
  static Future<ui.Image?> computeSymmetricFloodFill({
    required ui.Picture picture,
    required Size size,
    required Offset touchPoint,
    required Color fillColor,
  }) async {
    final int width = size.width.toInt();
    final int height = size.height.toInt();
    if (width <= 0 || height <= 0) return null;

    // 1. Rasterize the current picture to an image
    final ui.Image image = await picture.toImage(width, height);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return null;

    final Uint8List originalBytes = byteData.buffer.asUint8List();
    
    // 2. Prepare the new overlay image bytes (initialized to 0 -> transparent black)
    final Uint8List fillBytes = Uint8List(width * height * 4);

    // 3. Compute 12 symmetric start points
    final double cx = width / 2;
    final double cy = height / 2;
    final List<Offset> startPoints = [];
    const int symmetry = 12;
    const double angleStep = (2 * math.pi) / symmetry;

    for (int i = 0; i < symmetry; i++) {
      // Translate to origin, rotate, translate back
      final double dx = touchPoint.dx - cx;
      final double dy = touchPoint.dy - cy;
      final double angle = i * angleStep;
      
      final double rx = dx * math.cos(angle) - dy * math.sin(angle);
      final double ry = dx * math.sin(angle) + dy * math.cos(angle);
      
      final int px = (rx + cx).round();
      final int py = (ry + cy).round();
      
      if (px >= 0 && px < width && py >= 0 && py < height) {
        startPoints.add(Offset(px.toDouble(), py.toDouble()));
      }
    }

    // 4. Extract RGBA components of fillColor to write directly to buffer
    final int fr = fillColor.red;
    final int fg = fillColor.green;
    final int fb = fillColor.blue;
    final int fa = fillColor.alpha;

    const int tolerance = 32; // Allow some anti-aliasing blending

    bool isSimilar(int offset, int tr, int tg, int tb) {
      final int r = originalBytes[offset];
      final int g = originalBytes[offset + 1];
      final int b = originalBytes[offset + 2];
      return (r - tr).abs() <= tolerance &&
             (g - tg).abs() <= tolerance &&
             (b - tb).abs() <= tolerance;
    }

    // 5. Run BFS for each symmetric point
    for (final startPoint in startPoints) {
      final int sx = startPoint.dx.toInt();
      final int sy = startPoint.dy.toInt();
      final int startOffset = (sy * width + sx) * 4;
      
      // Target color to replace
      final int tr = originalBytes[startOffset];
      final int tg = originalBytes[startOffset + 1];
      final int tb = originalBytes[startOffset + 2];
      // We ignore alpha for similarity

      // If we clicked on the fill color itself, skip to avoid infinite loop
      if ((tr - fr).abs() <= tolerance && (tg - fg).abs() <= tolerance && (tb - fb).abs() <= tolerance) {
        continue;
      }

      final Queue<int> queue = Queue<int>();
      queue.add(sy * width + sx);

      // We use the alpha channel of fillBytes to track visited pixels (if > 0, it's visited)
      // Since it's initialized to 0, anything > 0 is visited.

      while (queue.isNotEmpty) {
        final int index = queue.removeFirst();
        final int x = index % width;
        final int y = index ~/ width;
        final int byteOffset = index * 4;

        if (fillBytes[byteOffset + 3] > 0) continue; // Already visited/filled

        if (isSimilar(byteOffset, tr, tg, tb)) {
          // Fill it
          fillBytes[byteOffset] = fr;
          fillBytes[byteOffset + 1] = fg;
          fillBytes[byteOffset + 2] = fb;
          fillBytes[byteOffset + 3] = fa;

          // Enqueue neighbors
          if (x > 0) queue.add(index - 1);
          if (x < width - 1) queue.add(index + 1);
          if (y > 0) queue.add(index - width);
          if (y < height - 1) queue.add(index + width);
        }
      }
    }

    // 6. Generate the new image from fillBytes
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromPixels(
      fillBytes,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (ui.Image img) => completer.complete(img),
    );

    return await completer.future;
  }
}
