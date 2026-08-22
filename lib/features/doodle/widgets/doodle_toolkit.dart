import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/zen_tokens.dart';
import '../models/doodle_stroke.dart';

class DoodleSwatch {
  final String name;
  final Color color;
  const DoodleSwatch(this.name, this.color);
}

const List<DoodleSwatch> doodlePalette = [
  DoodleSwatch('Lavender', Color(0xFF9F85D8)),
  DoodleSwatch('Blue', Color(0xFF60A5FA)),
  DoodleSwatch('Teal', Color(0xFF2DD4BF)),
  DoodleSwatch('Mint', Color(0xFF86EFAC)),
  DoodleSwatch('Peach', Color(0xFFFDBA74)),
  DoodleSwatch('Orange', Color(0xFFFB923C)),
  DoodleSwatch('Yellow', Color(0xFFFCD34D)),
  DoodleSwatch('Purple', Color(0xFF818CF8)),
];

class DoodleToolkit extends StatefulWidget {
  final DoodleToolType currentTool;
  final Color currentColor;
  final double brushSize;
  final double eraserSize;
  final bool showGuides;
  final bool canUndo;
  final bool canRedo;
  
  final ValueChanged<DoodleToolType> onToolChange;
  final ValueChanged<Color> onColorChange;
  final ValueChanged<double> onBrushSizeChange;
  final ValueChanged<double> onEraserSizeChange;
  final VoidCallback onToggleGuides;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onClear;
  final VoidCallback onSave;

  const DoodleToolkit({
    super.key,
    required this.currentTool,
    required this.currentColor,
    required this.brushSize,
    required this.eraserSize,
    required this.showGuides,
    required this.canUndo,
    required this.canRedo,
    required this.onToolChange,
    required this.onColorChange,
    required this.onBrushSizeChange,
    required this.onEraserSizeChange,
    required this.onToggleGuides,
    required this.onUndo,
    required this.onRedo,
    required this.onClear,
    required this.onSave,
  });

  @override
  State<DoodleToolkit> createState() => _DoodleToolkitState();
}

class _DoodleToolkitState extends State<DoodleToolkit> {
  bool _confirmClear = false;

  Widget _buildBtn({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? ZenTokens.zenPrimary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: disabled
                ? ZenTokens.zenFgMuted.withValues(alpha: 0.3)
                : isActive
                    ? ZenTokens.zenPrimary
                    : ZenTokens.zenFgMuted,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSep() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 1,
      width: 32,
      color: ZenTokens.zenBorderSoft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showStyle = widget.currentTool == DoodleToolType.draw || 
                      widget.currentTool == DoodleToolType.eraser;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.7)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E295A).withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildBtn(
                  icon: Icons.arrow_back_rounded,
                  isActive: false,
                  onTap: () => context.go('/dashboard'),
                ),
                _buildSep(),
                _buildBtn(
                  icon: Icons.edit_rounded,
                  isActive: widget.currentTool == DoodleToolType.draw,
                  onTap: () {
                    setState(() => _confirmClear = false);
                    widget.onToolChange(DoodleToolType.draw);
                  },
                ),
                _buildBtn(
                  icon: Icons.rectangle_outlined, // Closer to eraser
                  isActive: widget.currentTool == DoodleToolType.eraser,
                  onTap: () {
                    setState(() => _confirmClear = false);
                    widget.onToolChange(DoodleToolType.eraser);
                  },
                ),
                _buildBtn(
                  icon: Icons.format_color_fill_rounded,
                  isActive: widget.currentTool == DoodleToolType.fill,
                  onTap: () {
                    setState(() => _confirmClear = false);
                    widget.onToolChange(DoodleToolType.fill);
                  },
                ),
                _buildBtn(
                  icon: Icons.grid_3x3_rounded,
                  isActive: widget.showGuides,
                  onTap: widget.onToggleGuides,
                ),
                _buildSep(),
                _buildBtn(
                  icon: Icons.undo_rounded,
                  isActive: false,
                  disabled: !widget.canUndo,
                  onTap: widget.onUndo,
                ),
                _buildBtn(
                  icon: Icons.redo_rounded,
                  isActive: false,
                  disabled: !widget.canRedo,
                  onTap: widget.onRedo,
                ),
                _buildBtn(
                  icon: Icons.delete_outline_rounded,
                  isActive: _confirmClear,
                  onTap: () => setState(() => _confirmClear = !_confirmClear),
                ),
                _buildBtn(
                  icon: Icons.download_rounded,
                  isActive: false,
                  onTap: widget.onSave,
                ),
              ],
            ),
          ),
        ),
        
        // Popover for Clear Confirm
        if (_confirmClear)
          Positioned(
            left: 70,
            bottom: 40,
            child: Container(
              width: 180,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ZenTokens.zenBorderSoft),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clear this pattern?',
                    style: GoogleFonts.inter(fontSize: 12, color: ZenTokens.zenFg),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => setState(() => _confirmClear = false),
                          child: Text('Cancel', style: GoogleFonts.inter(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ZenTokens.zenDanger.withValues(alpha: 0.1),
                            foregroundColor: ZenTokens.zenDanger,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            setState(() => _confirmClear = false);
                            widget.onClear();
                          },
                          child: Text('Clear', style: GoogleFonts.inter(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        // Popover for Pen/Eraser Style
        if (showStyle && !_confirmClear)
          Positioned(
            left: 70,
            top: 70,
            child: Container(
              width: 192,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: ZenTokens.zenBorderSoft.withValues(alpha: 0.7)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E295A).withValues(alpha: 0.18),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.currentTool == DoodleToolType.draw ? 'PEN' : 'ERASER',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      color: ZenTokens.zenFgMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.currentTool == DoodleToolType.draw) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Color', style: GoogleFonts.inter(fontSize: 12, color: ZenTokens.zenFgMuted)),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: widget.currentColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: ZenTokens.zenBorderSoft),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: doodlePalette.map((swatch) {
                        final isActive = widget.currentColor == swatch.color;
                        return GestureDetector(
                          onTap: () => widget.onColorChange(swatch.color),
                          child: Container(
                            width: 34,
                            height: 32,
                            decoration: BoxDecoration(
                              color: swatch.color,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isActive ? ZenTokens.zenSecondary : ZenTokens.zenBorderSoft.withValues(alpha: 0.8),
                                width: isActive ? 2 : 1,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Size', style: GoogleFonts.inter(fontSize: 12, color: ZenTokens.zenFgMuted)),
                      Text(
                        '${(widget.currentTool == DoodleToolType.draw ? widget.brushSize : widget.eraserSize).toInt()}px',
                        style: GoogleFonts.inter(fontSize: 12, color: ZenTokens.zenFg),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: ZenTokens.zenSecondary,
                      activeTrackColor: ZenTokens.zenSecondary,
                      inactiveTrackColor: ZenTokens.zenBorderSoft,
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    ),
                    child: Slider(
                      min: widget.currentTool == DoodleToolType.draw ? 1 : 4,
                      max: widget.currentTool == DoodleToolType.draw ? 40 : 120,
                      value: widget.currentTool == DoodleToolType.draw ? widget.brushSize : widget.eraserSize,
                      onChanged: (val) {
                        if (widget.currentTool == DoodleToolType.draw) {
                          widget.onBrushSizeChange(val);
                        } else {
                          widget.onEraserSizeChange(val);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
