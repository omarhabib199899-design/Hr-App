import 'package:cnattendance/provider/leavecalendarcontroller.dart';
import 'package:cnattendance/widget/leavecalendar/leavelistcardview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LeaveListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LeaveCalendarController model = Get.find();
    return Obx(() => Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: model.employeeLeaveByDayList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {

                },
                child: LeaveListCardView(
                  model.employeeLeaveByDayList[index].id,
                  model.employeeLeaveByDayList[index].name,
                  model.employeeLeaveByDayList[index].avatar,
                  model.employeeLeaveByDayList[index].post,
                  model.employeeLeaveByDayList[index].days,
                ),
              );
            }),
      ),
    );
  }
}
