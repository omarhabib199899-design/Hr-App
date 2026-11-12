import 'package:cnattendance/provider/holidaycontroller.dart';
import 'package:cnattendance/widget/holiday/holidaycardview.dart';
import 'package:cnattendance/widget/holiday/toggleholiday.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class HolidayScreen extends StatelessWidget {
  static const routeName = '/holidays';

  @override
  Widget build(BuildContext context) {
    final model = Get.put(HolidayController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(translate('holiday_screen.holidays'), style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return model.getHolidays();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              child: Column(
                children: [ToggleHoliday(), HolidayCardView()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
