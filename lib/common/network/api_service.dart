import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sundaram_iot_app/common/config/config.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30), // or more
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        // 'Authorization': 'Basic ${AppConfig.basicAuth}',
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        log('➡️ Request [${options.method}] => PATH: ${options.path}');
        log('Headers: ${options.headers}');
        log('Body: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log('✅ Response [${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioError error, handler) {
        log('❌ Error [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
        log('Error Message: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  /// Generic GET
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    final url = AppConfig.getFormattedUrl(endpoint);
    return await dio.get(url, queryParameters: queryParameters);
  }

  /// Generic POST
  Future<Response> post(String endpoint, dynamic data) async {
    final url = AppConfig.getFormattedUrl(endpoint);
    return await dio.post(url, data: data);
  }

}
