import 'package:flutter/foundation.dart';

import 'panda_state.dart';

/// Renderer-agnostic Panda presentation controller.
class PandaController extends ChangeNotifier {
  PandaState _state = PandaState.idle;
  bool _disposed = false;

  PandaState get state => _state;

  void setState(PandaState state) {
    if (_disposed || _state == state) return;
    _state = state;
    notifyListeners();
  }

  /// App-open sequence: greeting → idle.
  Future<void> playGreetingSequence({
    Duration greetingHold = const Duration(milliseconds: 1400),
  }) async {
    setState(PandaState.greeting);
    await Future<void>.delayed(greetingHold);
    if (_disposed) return;
    setState(PandaState.idle);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
