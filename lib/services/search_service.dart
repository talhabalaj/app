import 'dart:developer';

import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class SearchService extends ChangeNotifier {
  AuthService authService;

  String searchTerm = '';
  List<UserModel> list = new List<UserModel>();
  bool loading = false;
  CancelToken cancelToken;
  String error;

  SearchService();

  SearchService update(AuthService authService) {
    print(
        '[SearchService] updated! ${authService.user != null ? authService.user.userName : ''}');
    if (authService.user == null) this.reset();
    this.authService = authService;
    return this;
  }

  void reset() {
    searchTerm = '';
    list = new List<UserModel>();
    loading = false;
    error = '';
    cancelToken = null;
    notifyListeners();
  }

  Future<void> search(String query) async {
    error = '';
    searchTerm = query;
    this.loading = true;
    notifyListeners();

    if (cancelToken != null) {
      try {
        cancelToken.cancel();
      } catch (e) {
        print(e);
      }
    }

    if (query == '') {
      list.removeRange(0, list.length);
      this.loading = false;
      notifyListeners();
      return;
    }

    cancelToken = new CancelToken();

    try {
      final res = await ApiRequest(
        authService: authService,
      ).request<List<UserModel>>(
        '/user/search?q=$query',
        method: HttpRequestMethod.GET,
        cancelToken: cancelToken,
      );

      if (res != null) {
        list = res.data;
        this.loading = false;
      }
    } catch (e) {
      this.loading = false;
      this.error = e.toString();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    log('The search_service has been disposed');
    super.dispose();
  }
}
