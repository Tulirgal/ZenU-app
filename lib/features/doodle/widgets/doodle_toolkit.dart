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
  bool _showStylePopup = true;

  @override
  void didUpdateWidget(DoodleToolkit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTool != oldWidget.currentTool) {
      if (widget.currentTool == DoodleToolType.draw || widget.currentTool == DoodleToolType.eraser) {
        _showStylePopup = true;
      } else {
        _showStylePopup = false;
      }
    }
  }

  void _handleToolTap(DoodleToolType tool) {
    setState(() => _confirmClear = false);
    if (widget.currentTool == tool && (tool == DoodleToolType.draw || tool == DoodleToolType.eraser)) {
      setState(() => _showStylePopup = !_showStylePopup);
    } else {
      widget.onToolChange(tool);
    }
  }

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                  onTap: () => _handleToolTap(DoodleToolType.draw),
                ),
                _buildBtn(
                  icon: Icons.rectangle_outlined,
                  isActive: widget.currentTool == DoodleToolType.eraser,
                  onTap: () => _handleToolTap(DoodleToolType.eraser),
                ),
                _buildBtn(
                  icon: Icons.format_color_fill_rounded,
                  isActive: widget.currentTool == DoodleToolType.fill,
                  onTap: () => _handleToolTap(DoodleToolType.fill),
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
        
        const SizedBox(width: 10),
        
        // Popover for Clear Confirm
        if (_confirmClear)
          Container(
            margin: const EdgeInsets.only(top: 250),
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
          )
        // Popover for Pen/Eraser Style
        else if (_showStylePopup)
          Container(
            margin: const EdgeInsets.only(top: 70),
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
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF0000), // Red
                          Color(0xFFFFFF00), // Yellow
                          Color(0xFF00FF00), // Green
                          Color(0xFF00FFFF), // Cyan
                          Color(0xFF0000FF), // Blue
                          Color(0xFFFF00FF), // Magenta
                          Color(0xFFFF0000), // Red
                        ],
                      ),
                    ),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 24,
                        activeTrackColor: Colors.transparent,
                        inactiveTrackColor: Colors.transparent,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 4),
                        thumbColor: Colors.white,
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                      ),
                      child: Slider(
                        min: 0,
                        max: 360,
                        value: HSVColor.fromColor(widget.currentColor).hue,
                        onChanged: (val) {
                          widget.onColorChange(HSVColor.fromAHSV(1.0, val, 1.0, 1.0).toColor());
                        },
                      ),
                    ),
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
      ],
    );
  }
}
