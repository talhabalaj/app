import 'package:Moody/models/api_response_model.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum HttpRequestMethod { GET, POST, DELETE, PUT }

final bool debugging = false;

final String baseUrl = (kDebugMode && debugging)
    ? (kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000")
    : "https://moody-backend.talhabalaj.com";
final String apiUrl = "$baseUrl/app/api/v1";

class ApiRequest {
  AuthService authService;
  Map<String, String> _headers;
  Dio _request;
  static ApiRequest instance;

  factory ApiRequest({AuthService authService, Map<String, String> headers}) {
    if (instance == null) {
      return ApiRequest.create(authService: authService, headers: headers);
    } else {
      return instance;
    }
  }

  ApiRequest.create({this.authService, Map<String, String> headers}) {
    if (headers != null) {
      _headers = headers;
    } else {
      _headers = Map<String, String>();
    }

    bool isSecure = apiUrl.split("://")[0] == 'https';

    if (this.authService != null && !kIsWeb)
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
          extra: {
            'withCredentials': true,
          },
        ),
        cancelToken: cancelToken,
        data: data,
        queryParameters: queryParameters,
      );
      return WebResponse<T>.fromJson(res.data);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.cancel:
          break;
        case DioErrorType.response:
          throw WebErrorResponse.fromJson(e.response.data);
          break;
        case DioErrorType.other:
        default:
          throw e;
      }
    }

    return null;
  }
}
