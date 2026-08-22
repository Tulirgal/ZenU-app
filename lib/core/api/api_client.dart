import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static const String _base = 'https://zenu-backend-5dgz.onrender.com';
  static ApiClient? _instance;
  late final Dio _dio;
  late final PersistCookieJar _jar;

  ApiClient._();

  static Future<ApiClient> getInstance() async {
    _instance ??= ApiClient._().._dio = Dio(); // placeholder
    if (!_instance!._initialized) await _instance!._init();
    return _instance!;
  }

  bool _initialized = false;

  Future<void> _init() async {
    final dir = await getApplicationDocumentsDirectory();
    _jar = PersistCookieJar(
      ignoreExpires: false,
      storage: FileStorage('${dir.path}/.zenu_cookies/'),
    );
    _dio = Dio(BaseOptions(
      baseUrl:        _base,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));
    _dio.interceptors.add(CookieManager(_jar));
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, error: true));
    }
    _initialized = true;
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? params}) =>
      _dio.get<T>(path, queryParameters: params);
  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _dio.post<T>(path, data: data);
  Future<Response<T>> patch<T>(String path, {dynamic data}) =>
      _dio.patch<T>(path, data: data);
  Future<Response<T>> delete<T>(String path) => _dio.delete<T>(path);
  Future<void> clearCookies() => _jar.deleteAll();
}
