import 'package:firebase_messaging/firebase_messaging.dart';

class FCM {
  FirebaseMessaging fcm = FirebaseMessaging();
  String userId;

  FCM() {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called: $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called: $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called: $message');
      },
    );
  }

  Future<void> subscribeToNotifications(String userId) async {
    this.userId = userId;
    return fcm.subscribeToTopic(userId);
  }

  Future<void> unsubscribe() async {
    if (userId != null) return fcm.unsubscribeFromTopic(this.userId);
  }
}
