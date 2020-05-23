import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/m_notification_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class NotificationService extends ChangeNotifier {
  List<MNotification> notifications = List<MNotification>();
  bool hasNewUnreadNotification = false;
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

    final newNotifications = (await ApiRequest(authService: authService)
            .request<List<MNotification>>('/user/notifications'))
        .data;

    if (newNotifications.any((element) => !element.softRead)) {
      hasNewUnreadNotification = true;
    }

    notifications = newNotifications;
    this.loading = false;

    notifyListeners();
  }

  Future<void> markNotificationAsRead(String id) async {
    final notification =
        notifications.firstWhere((element) => element.sId == id);
    if (notification.read) return;

    await ApiRequest(authService: authService)
        .request<List<MNotification>>('/user/notification/$id/read');
    notification.read = true;
    notifyListeners();
  }

  void markNewUnreadNotificationRead() {
    hasNewUnreadNotification = false;
    notifyListeners();
  }
}
