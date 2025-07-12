import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  Future<Response<dynamic>> get(String url) {
    return _dio.get(url);
  }

  Future<Response<dynamic>> post(String url, Map<String, dynamic> data) {
    return _dio.post(url, data: data);
  }
}
