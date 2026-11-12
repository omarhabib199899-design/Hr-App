import 'package:cnattendance/provider/leavecalendarcontroller.dart';
import 'package:cnattendance/widget/holiday/holidaycard.dart';
import 'package:cnattendance/widget/holiday/holidaycardview.dart';
import 'package:cnattendance/widget/leavecalendar/leavelistcardview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HolidayListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LeaveCalendarController model = Get.find();
    return Obx(
      () => model.employeeHoliday != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Holidaycard(
                  id: model.employeeHoliday!.id,
                  name: model.employeeHoliday!.title,
                  month:
                      DateFormat("MMM").format(model.employeeHoliday!.dateTime),
                  day: DateFormat("dd").format(model.employeeHoliday!.dateTime),
                  desc: model.employeeHoliday!.description,
                  isPublicHoliday: model.employeeHoliday!.isPublicHoliday),
            )
          : SizedBox.shrink(),
    );
  }
}
