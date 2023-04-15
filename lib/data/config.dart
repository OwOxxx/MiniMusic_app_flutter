import 'package:dio/dio.dart';

class RequestConfig {
  static const baseUrl = "http://10.0.2.2:3000";
  // static const baseUrl = "http://192.168.10.29:3000";
  static const connectTimeout = Duration(minutes: 1);
  static const successCode = 200;
  static const contentType = 'application/json';
  static const responseType = ResponseType.plain;
}
