import 'package:cnattendance/provider/notificationcontroller.dart';
import 'package:cnattendance/widget/notification/notificationlist.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(NotificationController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            title: Text(translate('notification_screen.notifications'),
                style: TextStyle(color: Colors.white)),
          ),
          body: RefreshIndicator(
              onRefresh: () {
                model
                    .page = 1;
                return model.getNotification();
              },
              child: NotificationList())),
    );
  }
}
