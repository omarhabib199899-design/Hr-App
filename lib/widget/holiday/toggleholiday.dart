import 'package:cnattendance/provider/holidaycontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ToggleHoliday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HolidayController model = Get.find();
    return Obx(
      () => Center(
        child: ToggleSwitch(
          activeBgColor: [Colors.white12],
          activeFgColor: Colors.white,
          inactiveFgColor: Colors.white,
          inactiveBgColor: Colors.transparent,
          minWidth: 100,
          minHeight: 45,
          initialLabelIndex: model.toggleValue.value,
          totalSwitches: 2,
          onToggle: (index) {
            model.toggleValue.value = index!;
            model.holidayListFilter();
          },
          labels: [
            translate('holiday_screen.upcoming'),
            translate('holiday_screen.past')
          ],
        ),
      ),
    );
  }
}
