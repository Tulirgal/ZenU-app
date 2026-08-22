import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _user;
  bool _loading = false;
  bool _initialized = false;

  UserModel? get currentUser => _user;
  bool get isLoading => _loading;
  bool get isAuthenticated => _user != null;
  bool get initialized => _initialized;

  Future<void> initialize() async {
    _loading = true; notifyListeners();
    try {
      final c = await ApiClient.getInstance();
      final r = await c.get('/api/me');
      if (r.statusCode == 200 && r.data?['user'] != null) {
        _user = UserModel.fromJson(r.data['user'] as Map<String, dynamic>);
      }
    } catch (_) { _user = null; }
    _loading = false; _initialized = true; notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true; notifyListeners();
    try {
      final c = await ApiClient.getInstance();
      final r = await c.post('/api/auth/sign-in',
          data: {'email': email, 'password': password});
      if (r.statusCode == 200 && r.data?['user'] != null) {
        await Future.delayed(const Duration(milliseconds: 150));
        _user = UserModel.fromJson(r.data['user'] as Map<String, dynamic>);
        _loading = false; notifyListeners(); return true;
      }
    } on DioException catch (e) { debugPrint('signIn: ${e.message}'); }
    _loading = false; notifyListeners(); return false;
  }

  Future<bool> signUp(String email, String password, String name) async {
    _loading = true; notifyListeners();
    try {
      final c = await ApiClient.getInstance();
      final r = await c.post('/api/auth/sign-up',
          data: {'email': email, 'password': password, 'name': name});
      if ((r.statusCode == 200 || r.statusCode == 201) && r.data?['user'] != null) {
        await Future.delayed(const Duration(milliseconds: 150));
        _user = UserModel.fromJson(r.data['user'] as Map<String, dynamic>);
        _loading = false; notifyListeners(); return true;
      }
    } on DioException catch (e) { debugPrint('signUp: ${e.message}'); }
    _loading = false; notifyListeners(); return false;
  }

  Future<void> signOut() async {
    try {
      final c = await ApiClient.getInstance();
      await c.post('/api/logout');
      await c.clearCookies();
    } catch (_) {}
    _user = null; notifyListeners();
  }

  // Signal tracking — mirrors src/lib/signals.ts
  Future<void> trackEngagement(String moduleId, String eventType, {int? durationSec}) async {
    try {
      final c = await ApiClient.getInstance();
      final data = <String, dynamic>{
        'module_id': moduleId,
        'event_type': eventType,
      };
      if (durationSec != null) data['duration_sec'] = durationSec;
      await c.post('/api/signals/engagement', data: data);
    } catch (_) {}
  }

  Future<void> logMood(int score) async {
    try {
      final c = await ApiClient.getInstance();
      await c.post('/api/signals/mood', data: {'mood_score': score});
    } catch (_) {}
  }

  Future<List<Map<String, dynamic>>> getRecommendations() async {
    try {
      final c = await ApiClient.getInstance();
      final r = await c.get('/api/recommendations/today');
      if (r.statusCode == 200) {
        return List<Map<String, dynamic>>.from(r.data['recommendations'] ?? []);
      }
    } catch (_) {}
    return [];
  }
}
