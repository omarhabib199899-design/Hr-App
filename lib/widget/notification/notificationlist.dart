import 'package:cnattendance/provider/notificationcontroller.dart';
import 'package:cnattendance/widget/notification/notificationcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NotificationController model = Get.find();
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView.builder(
            primary: false,
            controller: model.controller,
            itemCount: model.notificationList.length,
            itemBuilder: (ctx, index) {
              return NotificationCard(
                  id: model.notificationList[index].id,
                  name: model.notificationList[index].title,
                  month: model.notificationList[index].month,
                  day: model.notificationList[index].day.toString(),
                  desc: model.notificationList[index].description,
                  date: model.notificationList[index].date.toString());
            }),
      ),
    );
  }
}
