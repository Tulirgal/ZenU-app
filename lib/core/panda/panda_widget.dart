import 'package:flutter/widgets.dart';

import 'panda_controller.dart';
import 'panda_quality.dart';
import 'panda_renderer.dart';
import 'placeholder_panda_renderer.dart';

/// Shared Panda companion widget — renderer-agnostic.
class PandaWidget extends StatefulWidget {
  const PandaWidget({
    super.key,
    required this.controller,
    this.size = 160,
    this.renderer,
    this.quality = PandaQuality.medium,
    this.manageLifecycle = true,
  });

  final PandaController controller;
  final double size;
  final PandaRenderer? renderer;
  final PandaQuality quality;

  /// When true, pauses / releases on app background via lifecycle observer.
  final bool manageLifecycle;

  @override
  State<PandaWidget> createState() => _PandaWidgetState();
}

class _PandaWidgetState extends State<PandaWidget> {
  late PandaRenderer _renderer;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _renderer = widget.renderer ?? PlaceholderPandaRenderer();
    _listener = _onControllerChanged;
    widget.controller.addListener(_listener);
    _renderer.setQuality(widget.quality);
    _renderer.setState(widget.controller.state);
    _renderer.initialize();
  }

  void _onControllerChanged() {
    _renderer.setState(widget.controller.state);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant PandaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_listener);
      widget.controller.addListener(_listener);
      _renderer.setState(widget.controller.state);
    }
    if (oldWidget.quality != widget.quality) {
      _renderer.setQuality(widget.quality);
    }
    if (widget.renderer != null && oldWidget.renderer != widget.renderer) {
      _renderer.dispose();
      _renderer = widget.renderer!;
      _renderer.setQuality(widget.quality);
      _renderer.setState(widget.controller.state);
      _renderer.initialize();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    _renderer.pause();
    _renderer.releaseResources();
    _renderer.dispose();
    super.dispose();
  }

  void _onVisibility(bool visible) {
    if (!widget.manageLifecycle) return;
    if (visible) {
      _renderer.resume();
    } else {
      _renderer.pause();
      _renderer.releaseResources();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _LifecycleHost(
      onVisibilityChanged: _onVisibility,
      child: _renderer.build(context, size: widget.size),
    );
  }
}

class _LifecycleHost extends StatefulWidget {
  const _LifecycleHost({
    required this.child,
    required this.onVisibilityChanged,
  });

  final Widget child;
  final ValueChanged<bool> onVisibilityChanged;

  @override
  State<_LifecycleHost> createState() => _LifecycleHostState();
}

class _LifecycleHostState extends State<_LifecycleHost>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onVisibilityChanged(true);
    });
  }

  @override
  void dispose() {
    widget.onVisibilityChanged(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.onVisibilityChanged(state == AppLifecycleState.resumed);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
