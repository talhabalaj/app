import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCM {
  FirebaseMessaging fcm = FirebaseMessaging();
  String userId;

  Future<void> subscribeToNotifications(String userId) async {
    this.userId = userId;
    return fcm.subscribeToTopic(userId);
  }

  Future<void> unsubscribe() async {
    if (userId != null) return fcm.unsubscribeFromTopic(this.userId);
  }
}
