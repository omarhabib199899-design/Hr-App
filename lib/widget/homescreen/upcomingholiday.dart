import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/screen/profile/holidayscreen.dart';
import 'package:cnattendance/widget/holiday/holidaycard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UpcomingHoliday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final holiday = context.watch<DashboardProvider>().holiday;
    return Visibility(
      visible: holiday != null ? true : false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  translate('home_screen.upcoming_holiday'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(HolidayScreen());
                  },
                  child: Text(
                    translate('home_screen.view_all'),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            holiday != null
                ? Holidaycard(
                    id: holiday.id,
                    name: holiday.title,
                    month: holiday.month,
                    day: holiday.day,
                    desc: holiday.description,
                    isPublicHoliday: holiday.isPublicHoliday)
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
