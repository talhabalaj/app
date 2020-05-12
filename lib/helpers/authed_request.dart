import 'package:Moody/services/auth_service.dart';
import 'package:dio/dio.dart';

import '../constants.dart';

class AuthenticatedRequest {
  AuthService authService;
  Map<String, String> _headers;
  Dio request;

  AuthenticatedRequest({this.authService, Map<String, String> headers}) {
    if (headers != null) {
      _headers = headers;
    } else {
      _headers = Map<String, String>();
    }

    bool isSecure = kApiUrl.split("://")[0] == 'https';

    _headers['Cookie'] =
        'access_token=${authService.auth.token}; HttpOnly; ${isSecure ? 'Secure' : ''}';
    request = Dio(
      BaseOptions(
        baseUrl: kApiUrl,
        headers: _headers,
        responseType: ResponseType.json,
      ),
    );
  }
}
