import 'package:Moody/models/api_response_model.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum HttpRequestMethod { GET, POST, DELETE, PUT }

final String apiUrl = DotEnv().env['API_URL'];

class ApiRequest {
  AuthService authService;
  Map<String, String> _headers;
  Dio _request;

  ApiRequest({this.authService, Map<String, String> headers}) {
    if (headers != null) {
      _headers = headers;
    } else {
      _headers = Map<String, String>();
    }

    bool isSecure = apiUrl.split("://")[0] == 'https';

    if (this.authService != null)
      _headers['Cookie'] =
          'access_token=${authService.auth.token}; HttpOnly; ${isSecure ? 'Secure' : ''}';

    _request = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        headers: _headers,
        responseType: ResponseType.json,
      ),
    );
  }

  Future<WebResponse<T>> request<T>(
    String path, {
    HttpRequestMethod method = HttpRequestMethod.GET,
    CancelToken cancelToken,
    dynamic data,
    Map<String, dynamic> queryParameters,
  }) async {
    String methodString = 'GET';

    switch (method) {
      case HttpRequestMethod.GET:
        break;
      case HttpRequestMethod.POST:
        methodString = 'POST';
        break;
      case HttpRequestMethod.DELETE:
        methodString = 'DELETE';
        break;
      case HttpRequestMethod.PUT:
        methodString = 'PUT';
    }

    try {
      final res = await _request.request(
        path,
        options: Options(
          method: methodString,
        ),
        cancelToken: cancelToken,
        data: data,
        queryParameters: queryParameters,
      );

      return WebResponse<T>.fromJson(res.data);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.CANCEL:
          break;
        case DioErrorType.RESPONSE:
          throw WebErrorResponse.fromJson(e.response.data);
          break;
        case DioErrorType.DEFAULT:
        default:
          throw e;
      }
    }

    return null;
  }
}
