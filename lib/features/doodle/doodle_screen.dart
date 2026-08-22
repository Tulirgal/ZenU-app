import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/zen_tokens.dart';
import '../../shared/widgets/module_background.dart';
import 'models/doodle_stroke.dart';
import 'widgets/doodle_toolkit.dart';
import 'widgets/symmetry_canvas.dart';

class DoodleScreen extends StatefulWidget {
  const DoodleScreen({super.key});

  @override
  State<DoodleScreen> createState() => _DoodleScreenState();
}

class _DoodleScreenState extends State<DoodleScreen> {
  DoodleToolType _tool = DoodleToolType.draw;
  Color _color = const Color(0xFF818CF8);
  double _brushSize = 5;
  double _eraserSize = 30;
  bool _showGuides = false;
  double _zoom = 1.0;

  final SymmetryCanvasController _controller = SymmetryCanvasController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() async {
    final image = await _controller.getRenderedImage();
    if (image != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doodle saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZenTokens.zenBg,
      body: ModuleBackground(
        moduleKey: 'doodle',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'Doodle Dreams',
                      style: GoogleFonts.lora(fontSize: 24, color: ZenTokens.zenFg),
                    ),
                  ],
                ),
                Text(
                  'Let one small stroke become something beautiful.',
                  style: GoogleFonts.inter(fontSize: 14, color: ZenTokens.zenFgMuted),
                ),
                const SizedBox(height: 24),
                
                // Main Workspace
                Expanded(
                  child: Stack(
                    children: [
                      // Canvas Area (Base)
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 84), // 60 sidebar + 24 spacing
                          child: Column(
                            children: [
                              Expanded(
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Transform.scale(
                                      scale: _zoom,
                                      child: SymmetryCanvas(
                                        controller: _controller,
                                        currentTool: _tool,
                                        currentColor: _color,
                                        brushSize: _brushSize,
                                        eraserSize: _eraserSize,
                                        showGuides: _showGuides,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Zoom Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: ZenTokens.zenSurface,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: ZenTokens.zenBorderSoft),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 16),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() {
                                          _zoom = (_zoom - 0.1).clamp(0.5, 2.0);
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      '${(_zoom * 100).toInt()}%',
                                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 16),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() {
                                          _zoom = (_zoom + 0.1).clamp(0.5, 2.0);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      
                      // Sidebar (Top)
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        child: DoodleToolkit(
                          currentTool: _tool,
                          currentColor: _color,
                          brushSize: _brushSize,
                          eraserSize: _eraserSize,
                          showGuides: _showGuides,
                          canUndo: _controller.canUndo,
                          canRedo: _controller.canRedo,
                          onToolChange: (t) => setState(() => _tool = t),
                          onColorChange: (c) => setState(() => _color = c),
                          onBrushSizeChange: (s) => setState(() => _brushSize = s),
                          onEraserSizeChange: (s) => setState(() => _eraserSize = s),
                          onToggleGuides: () => setState(() => _showGuides = !_showGuides),
                          onUndo: () => _controller.undo(),
                          onRedo: () => _controller.redo(),
                          onClear: () => _controller.clear(),
                          onSave: _handleSave,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
