import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'panda_quality.dart';
import 'panda_renderer.dart';
import 'panda_state.dart';
import 'placeholder_panda_renderer.dart';

/// Scaffold for the future native Panda renderer.
///
/// Target backends (not wired in this phase):
/// - Android → Filament
/// - iOS → SceneKit
///
/// No 3D package is linked yet. Until a production GLB exists and a native
/// bridge is validated, this falls back to [PlaceholderPandaRenderer].
class NativePandaRenderer implements PandaRenderer {
  NativePandaRenderer({PandaRenderer? fallback})
      : _fallback = fallback ?? PlaceholderPandaRenderer();

  final PandaRenderer _fallback;

  PandaState _state = PandaState.idle;
  PandaQuality _quality = PandaQuality.medium;
  bool _initialized = false;
  bool _paused = true;
  String? _loadedAsset;

  /// True when a production native backend is actually available.
  bool get isNativeBackendReady => false;

  PandaState get currentState => _state;
  PandaQuality get currentQuality => _quality;
  bool get isInitialized => _initialized;
  bool get isPaused => _paused;
  String? get loadedAssetPath => _loadedAsset;

  @override
  bool get isTemporaryPlaceholder => !isNativeBackendReady;

  @override
  String get assetPath => 'assets/panda/zenu_panda.glb';

  @override
  Future<void> initialize() async {
    _initialized = true;
    await _fallback.initialize();
    if (kDebugMode && !isNativeBackendReady) {
      debugPrint(
        'NativePandaRenderer: native Filament/SceneKit backend not linked yet; '
        'using temporary placeholder.',
      );
    }
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
    _loadedAsset = null;
    await _fallback.dispose();
  }

  @override
  Future<void> loadAsset(String path) async {
    _loadedAsset = path;
    // Production: load optimized GLB via platform channel / native view.
    await _fallback.loadAsset(path);
  }

  @override
  void setState(PandaState state) {
    _state = state;
    _fallback.setState(state);
  }

  @override
  void setQuality(PandaQuality quality) {
    _quality = quality;
    _fallback.setQuality(quality);
  }

  @override
  void pause() {
    _paused = true;
    _fallback.pause();
  }

  @override
  void resume() {
    if (!_initialized) return;
    _paused = false;
    _fallback.resume();
  }

  @override
  void releaseResources() {
    _paused = true;
    _loadedAsset = null;
    _fallback.releaseResources();
  }

  @override
  Widget build(BuildContext context, {required double size}) {
    return _fallback.build(context, size: size);
  }
}
