import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/m_notification_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class NotificationService extends ChangeNotifier {
  List<M_Notification> notifications = List<M_Notification>();
  bool loading = false;
  AuthService authService;

  NotificationService update(AuthService authService) {
    this.authService = authService;
    if (this.authService.user != null) {
      refreshNotifications();
    }
    return this;
  }

  Future<void> refreshNotifications() async {
    this.loading = true;
    notifyListeners();

    notifications = (await ApiRequest(authService: authService)
            .request<List<M_Notification>>('/user/notifications'))
        .data;

    notifyListeners();
  }
}
