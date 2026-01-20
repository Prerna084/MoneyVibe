import 'package:dio/dio.dart';

class NetworkClient {
  final Dio _dio;

  NetworkClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://localhost:5000/api/',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  Dio get dio => _dio;
}
