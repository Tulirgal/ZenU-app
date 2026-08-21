import 'package:flutter/foundation.dart'; 
import 'package:dio/dio.dart'; 
import '../api/api_client.dart'; 
import '../models/user_model.dart'; 
 
class AuthService extends ChangeNotifier { 
  UserModel? _user; 
  bool _loading  = false; 
  bool _initialized = false; 
 
  UserModel? get currentUser  => _user; 
  bool get isLoading          => _loading; 
  bool get isAuthenticated    => _user != null; 
  bool get initialized        => _initialized; 
 
  Future<void> initialize() async { 
    _loading = true; 
    notifyListeners(); 
    try { 
      final client = await ApiClient.getInstance(); 
      final res    = await client.get('/api/me'); 
      if (res.statusCode == 200 && res.data?['user'] != null) { 
        _user = UserModel.fromJson(res.data['user'] as Map<String, dynamic>); 
      } 
    } catch (_) { 
      _user = null; 
    } 
    _loading      = false; 
    _initialized  = true; 
    notifyListeners(); 
  } 
 
  Future<bool> signIn(String email, String password) async { 
    _loading = true; 
    notifyListeners(); 
    try { 
      final client = await ApiClient.getInstance(); 
      final res    = await client.post('/api/auth/sign-in', 
          data: {'email': email, 'password': password}); 
      if (res.statusCode == 200 && res.data?['user'] != null) { 
        // Small delay so cookies are committed before navigating 
        await Future.delayed(const Duration(milliseconds: 150)); 
        _user    = UserModel.fromJson(res.data['user'] as Map<String, dynamic>); 
        _loading = false; 
        notifyListeners(); 
        return true; 
      } 
    } on DioException catch (e) { 
      debugPrint('signIn error: ${e.message}'); 
    } 
    _loading = false; 
    notifyListeners(); 
    return false; 
  } 
 
  Future<bool> signUp(String email, String password, String name, [String? username]) async { 
    _loading = true; 
    notifyListeners(); 
    try { 
      final client = await ApiClient.getInstance(); 
      final res    = await client.post('/api/auth/sign-up', 
          data: {
            'email': email, 
            'password': password, 
            'name': name,
            if (username != null && username.isNotEmpty) 'username': username,
          }); 
      if ((res.statusCode == 200 || res.statusCode == 201) && 
          res.data?['user'] != null) { 
        await Future.delayed(const Duration(milliseconds: 150)); 
        _user    = UserModel.fromJson(res.data['user'] as Map<String, dynamic>); 
        _loading = false; 
        notifyListeners(); 
        return true; 
      } 
    } on DioException catch (e) { 
      debugPrint('signUp error: ${e.message}'); 
    } 
    _loading = false; 
    notifyListeners(); 
    return false; 
  } 
 
  Future<void> signOut() async { 
    try { 
      final client = await ApiClient.getInstance(); 
      await client.post('/api/logout'); 
      await client.clearCookies(); 
    } catch (_) {} 
    _user = null; 
    notifyListeners(); 
  } 
}
