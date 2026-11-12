import 'package:cnattendance/provider/holidaycontroller.dart';
import 'package:cnattendance/widget/holiday/holidaycard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HolidayCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HolidayController model = Get.find();
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: model.holidayList.length,
            itemBuilder: (ctx, i) {
              return Holidaycard(
                id: model.holidayList[i].id,
                name: model.holidayList[i].title,
                month: model.holidayList[i].month,
                day: model.holidayList[i].day,
                desc: model.holidayList[i].description,
                isPublicHoliday: model.holidayList[i].isPublicHoliday,
              );
            }),
      ),
    );
  }
}
