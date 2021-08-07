import 'package:dio/dio.dart';

class DioHelper {
  static late Dio _instance;

  static void init() {
    _instance = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        headers: {
          'lang': 'en',
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> getData({
    required String path,
    String? token,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onReceiveProgress,
  }) async {
    addToken(token);
    return await _instance.get(
      path,
      queryParameters: queryParameters,
      onReceiveProgress: onReceiveProgress,
    );
  }

  static Future<Response> postData({
    required String path,
    String? token,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    addToken(token);
    return await _instance.post(
      path,
      queryParameters: queryParameters,
      data: data,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
  }

  static Future<Response> putData({
    required String path,
    String? token,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) async {
    addToken(token);
    return await _instance.put(
      path,
      queryParameters: queryParameters,
      data: data,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
    );
  }

  static void addToken(String? token) {
    if (token != null) {
      _instance.options.headers['Authorization'] = token;
    }
  }
}
