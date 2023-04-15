import 'package:dio/dio.dart';
import 'package:flutter_application_1/data/config.dart';

RequestClient requestClient = RequestClient();

class RequestClient {
  late Dio _dio;

  RequestClient() {
    _dio = Dio(BaseOptions(
        baseUrl: RequestConfig.baseUrl,
        connectTimeout: RequestConfig.connectTimeout,
        contentType: RequestConfig.contentType,
        responseType: RequestConfig.responseType));
  }
}

Future<T?> request<T>(String url,
    {String method = "GET",
    Map<String, dynamic>? queryParameters,
    data,
    Map<String, dynamic>? headers}) async {
  Options options = Options()
    ..method = method
    ..headers = headers;

  Response response = await requestClient._dio.request(url,
      queryParameters: queryParameters, data: data, options: options);
  return _handleRequestResponse<T>(response);
}

///请求响应内容处理
T? _handleRequestResponse<T>(Response response) {
  if (response.statusCode == 200) {
    return response.data;
  } else {
    return null;
  }
}

getdata() async {
  // var url = Uri.https('api.apiopen.top', '/api/getHaoKanVideo');
  // var response = await http.get(url).then((response) {
  //   // print('Response status: ${response.statusCode}');
  //   // print('Response body: ${response.body}');
  // });
  // print('output: $url');
  // print('Response res : $response');
  // print(await http.read(Uri.https('api.apiopen.top', '/api/getHaoKanVideo')));
}
