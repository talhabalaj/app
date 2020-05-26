import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/m_notification_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class NotificationService extends ChangeNotifier {
  List<MNotification> notifications = List<MNotification>();
  int newUnreadNotificationCount = 0;
  bool loading = false;
  AuthService authService;

  NotificationService update(AuthService authService) {
    this.authService = authService;
    if (this.authService.user != null) {
      refreshNotifications();
    } else {
      notifications = null;
    }
    return this;
  }

  Future<void> refreshNotifications() async {
    this.loading = true;
    notifyListeners();

    final newNotifications = (await ApiRequest(authService: authService)
            .request<List<MNotification>>('/user/notifications'))
        .data;

    newUnreadNotificationCount =
        newNotifications.where((element) => !element.softRead).length;

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

  Future<void> markNewUnreadNotificationRead() async {
    if (newUnreadNotificationCount > 0) {
      newUnreadNotificationCount = 0;
      notifyListeners();

      final notificationIdsToMarkSeen = notifications
          .where((element) => !element.softRead)
          .map((e) => e.sId)
          .toList();

      final formData = {
        "ids": notificationIdsToMarkSeen,
      };

      await ApiRequest(authService: authService).request(
        '/user/notifications/seen',
        method: HttpRequestMethod.POST,
        data: formData,
      );
    }
  }
}
