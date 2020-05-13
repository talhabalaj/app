import 'package:Moody/models/m_notification_model.dart';
import 'package:Moody/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Text('--- Underconstruction! --- (Not accurate data)'),
          Consumer<NotificationService>(
            builder: (context, notificationService, _) {
              return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  for (M_Notification m_notification
                      in notificationService.notifications)
                    Text(m_notification.message),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
