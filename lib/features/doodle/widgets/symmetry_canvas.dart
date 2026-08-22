import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/doodle_stroke.dart';
import '../utils/flood_fill.dart';

class SymmetryCanvas extends StatefulWidget {
  final DoodleToolType currentTool;
  final Color currentColor;
  final double brushSize;
  final double eraserSize;
  final bool showGuides;
  final void Function(int strokeCount)? onStrokeCommit;
  final void Function()? onFirstStroke;
  
  // Expose methods to parent via GlobalKey or Controller.
  // We'll use a controller pattern.
  final SymmetryCanvasController controller;

  const SymmetryCanvas({
    super.key,
    required this.currentTool,
    required this.currentColor,
    required this.brushSize,
    required this.eraserSize,
    required this.showGuides,
    required this.controller,
    this.onStrokeCommit,
    this.onFirstStroke,
  });

  @override
  State<SymmetryCanvas> createState() => SymmetryCanvasState();
}

class SymmetryCanvasController extends ChangeNotifier {
  SymmetryCanvasState? _state;

  void _attach(SymmetryCanvasState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  bool get canUndo => _state?.canUndo ?? false;
  bool get canRedo => _state?.canRedo ?? false;
  bool get isEmpty => _state?.strokes.isEmpty ?? true;
  int get strokeCount => _state?.strokes.length ?? 0;

  void undo() => _state?.undo();
  void redo() => _state?.redo();
  void clear() => _state?.clear();
  Future<ui.Image?> getRenderedImage() async => _state?.getRenderedImage();
}

class SymmetryCanvasState extends State<SymmetryCanvas> {
  final List<DoodleStroke> strokes = [];
  final List<DoodleStroke> _redoStack = [];
  
  DoodleStroke? _activeStroke;
  bool _hasDrawn = false;

  bool get canUndo => strokes.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
  }

  @override
  void dispose() {
    widget.controller._detach();
    super.dispose();
  }

  void undo() {
    if (strokes.isEmpty) return;
    setState(() {
      _redoStack.add(strokes.removeLast());
      widget.controller.notifyListeners();
    });
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      strokes.add(_redoStack.removeLast());
      widget.controller.notifyListeners();
    });
  }

  void clear() {
    setState(() {
      strokes.clear();
      _redoStack.clear();
      _hasDrawn = false;
      widget.controller.notifyListeners();
    });
  }

  bool _isFilling = false;

  Future<void> _handleFloodFill(Offset touchPoint) async {
    if (_isFilling) return;
    setState(() => _isFilling = true);

    try {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final size = box.size;
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.width, size.height));
      
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFFCFCFC));
      
      final painter = SymmetryPainter(
        strokes: strokes,
        activeStroke: null,
        showGuides: false,
      );
      painter.paint(canvas, size);
      
      final picture = recorder.endRecording();

      final ui.Image? fillImage = await FloodFillUtils.computeSymmetricFloodFill(
        picture: picture,
        size: size,
        touchPoint: touchPoint,
        fillColor: widget.currentColor,
      );

      if (fillImage != null && mounted) {
        setState(() {
          strokes.add(DoodleStroke(
            points: [touchPoint],
            color: widget.currentColor,
            size: 0,
            toolType: DoodleToolType.fill,
            image: fillImage,
          ));
          _redoStack.clear();
          _markDrawn();
          widget.onStrokeCommit?.call(strokes.length);
          widget.controller.notifyListeners();
        });
      }
    } finally {
      if (mounted) setState(() => _isFilling = false);
    }
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);

    if (widget.currentTool == DoodleToolType.fill) {
      _handleFloodFill(localPosition);
      return;
    }

    setState(() {
      _activeStroke = DoodleStroke(
        points: [localPosition],
        color: widget.currentColor,
        size: widget.currentTool == DoodleToolType.eraser ? widget.eraserSize : widget.brushSize,
        toolType: widget.currentTool,
      );
      _markDrawn();
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_activeStroke == null || widget.currentTool == DoodleToolType.fill) return;
    RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);

    setState(() {
      _activeStroke!.points.add(localPosition);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_activeStroke != null) {
      setState(() {
        strokes.add(_activeStroke!);
        _redoStack.clear();
        _activeStroke = null;
        widget.controller.notifyListeners();
        widget.onStrokeCommit?.call(strokes.length);
      });
    } else if (widget.currentTool == DoodleToolType.fill) {
      widget.onStrokeCommit?.call(strokes.length);
      widget.controller.notifyListeners();
    }
  }

  void _markDrawn() {
    if (!_hasDrawn) {
      _hasDrawn = true;
      widget.onFirstStroke?.call();
    }
  }

  Future<ui.Image?> getRenderedImage() async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Draw background (white)
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFFCFCFC)); // hsl(40,40%,99%)
    
    final painter = SymmetryPainter(
      strokes: strokes,
      activeStroke: null,
      showGuides: false,
    );
    painter.paint(canvas, size);
    
    final picture = recorder.endRecording();
    return await picture.toImage(size.width.toInt(), size.height.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: const Color(0xFFFCFCFC), // hsl(40, 40%, 99%)
          child: Stack(
            children: [
              Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: SymmetryPainter(
                      strokes: strokes,
                      activeStroke: _activeStroke,
                      showGuides: widget.showGuides,
                    ),
                  ),
                  if (_isFilling)
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCBD5E1)),
                      ),
                    ),
                ],
              ),
              if (!_hasDrawn && strokes.isEmpty)
                const Center(
                  child: IgnorePointer(
                    child: Text(
                      'Start anywhere. Watch it multiply.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: Color(0xFF6B7280), // zen-fg-subtle
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

class SymmetryPainter extends CustomPainter {
  final List<DoodleStroke> strokes;
  final DoodleStroke? activeStroke;
  final bool showGuides;

  SymmetryPainter({
    required this.strokes,
    this.activeStroke,
    this.showGuides = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // If using eraser, we need to draw on a separate layer so clear operations
    // only affect the drawing and not the canvas background.
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    final cx = size.width / 2;
    final cy = size.height / 2;
    const symmetry = 12;
    const angleStep = (2 * math.pi) / symmetry;

    void drawStroke(DoodleStroke stroke) {
      if (stroke.toolType == DoodleToolType.fill) {
        if (stroke.image != null) {
          canvas.drawImage(stroke.image!, Offset.zero, Paint());
        } else {
          // Fallback if image generation failed (or old strokes)
          final paint = Paint()
            ..color = stroke.color
            ..style = PaintingStyle.fill;
          canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
        }
        return;
      }

      if (stroke.points.isEmpty) return;

      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.size
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (stroke.toolType == DoodleToolType.eraser) {
        paint.blendMode = BlendMode.clear;
      }

      final path = Path();
      path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      
      // Draw 12 times radially
      for (int i = 0; i < symmetry; i++) {
        canvas.save();
        canvas.translate(cx, cy);
        canvas.rotate(i * angleStep);
        canvas.translate(-cx, -cy);
        canvas.drawPath(path, paint);
        canvas.restore();
      }
    }

    for (final stroke in strokes) {
      drawStroke(stroke);
    }
    if (activeStroke != null) {
      drawStroke(activeStroke!);
    }

    canvas.restore(); // Restore from saveLayer

    if (showGuides) {
      final guidePaint = Paint()
        ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.4) // zen-secondary roughly
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(cx, cy), 3, guidePaint);
    }
  }

  @override
  bool shouldRepaint(covariant SymmetryPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
           oldDelegate.activeStroke != activeStroke ||
           oldDelegate.showGuides != showGuides;
  }
}
