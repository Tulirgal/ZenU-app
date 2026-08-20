/// Future native capability boundaries — stubs only in this phase.
///
/// Do not wire plugins until a feature genuinely needs them.
library;

abstract class CameraService {
  Future<void> openCamera();
}

abstract class GalleryService {
  Future<void> pickImage();
}

abstract class MicrophoneService {
  Future<void> startListening();
  Future<void> stopListening();
}

abstract class AudioService {
  Future<void> play(String assetPath);
  Future<void> stop();
}

abstract class NotificationService {
  Future<void> requestPermission();
  Future<void> showLocal({required String title, required String body});
}

abstract class BiometricService {
  Future<bool> authenticate();
}

abstract class SecureStorageService {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

abstract class DeepLinkService {
  Stream<Uri> get links;
}

abstract class ShareService {
  Future<void> shareText(String text);
}

abstract class ClipboardService {
  Future<void> copy(String text);
  Future<String?> paste();
}

abstract class DeviceMotionService {
  Stream<Object> get events;
}

abstract class ConnectivityService {
  Stream<bool> get onConnectivityChanged;
  Future<bool> get isOnline;
}

abstract class AppLifecycleService {
  Stream<Object> get states;
}

/// No-op stubs so call sites can depend on interfaces early.
class StubCameraService implements CameraService {
  @override
  Future<void> openCamera() async {}
}

class StubGalleryService implements GalleryService {
  @override
  Future<void> pickImage() async {}
}

class StubMicrophoneService implements MicrophoneService {
  @override
  Future<void> startListening() async {}

  @override
  Future<void> stopListening() async {}
}

class StubAudioService implements AudioService {
  @override
  Future<void> play(String assetPath) async {}

  @override
  Future<void> stop() async {}
}

class StubNotificationService implements NotificationService {
  @override
  Future<void> requestPermission() async {}

  @override
  Future<void> showLocal({required String title, required String body}) async {}
}

class StubBiometricService implements BiometricService {
  @override
  Future<bool> authenticate() async => false;
}

class StubSecureStorageService implements SecureStorageService {
  final Map<String, String> _store = {};

  @override
  Future<void> write(String key, String value) async => _store[key] = value;

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> delete(String key) async => _store.remove(key);
}

class StubShareService implements ShareService {
  @override
  Future<void> shareText(String text) async {}
}

class StubClipboardService implements ClipboardService {
  String? _value;

  @override
  Future<void> copy(String text) async => _value = text;

  @override
  Future<String?> paste() async => _value;
}
