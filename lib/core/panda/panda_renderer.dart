import 'package:flutter/widgets.dart';

import 'panda_quality.dart';
import 'panda_state.dart';

/// Replaceable Panda rendering contract.
///
/// The rest of the app talks only to [PandaWidget] / [PandaController].
/// Platform Filament / SceneKit details stay inside native implementations.
abstract class PandaRenderer {
  /// Whether this renderer is a temporary development stand-in.
  bool get isTemporaryPlaceholder;

  /// Preferred asset path for a production GLB/glTF (when available).
  String get assetPath => 'assets/panda/zenu_panda.glb';

  Future<void> initialize();

  Future<void> dispose();

  Future<void> loadAsset(String path);

  void setState(PandaState state);

  void setQuality(PandaQuality quality);

  /// Pause animation / GPU work when not visible.
  void pause();

  /// Resume after [pause].
  void resume();

  /// Release GPU resources that are safe to drop while off-screen.
  void releaseResources();

  Widget build(BuildContext context, {required double size});
}
