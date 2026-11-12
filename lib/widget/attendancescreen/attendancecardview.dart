import 'package:cnattendance/model/employeeattendancereport.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/profile/attendance_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';

class AttendanceCardView extends StatelessWidget {
  final int index;
  final String grouped;
  final List<EmployeeAttendanceReport> attendances;

  AttendanceCardView(
    this.index,
    this.grouped,
    this.attendances,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white12,
      shape: ButtonBorder(),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              constraints: BoxConstraints(maxHeight: 300),
              builder: (context) {
                return AttendanceDetailBottomSheet(grouped, attendances);
              });
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Row(
              crossAxisAlignment: attendances.length == 1
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(grouped,
                        style: TextStyle(fontSize: 15, color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(attendances.first.week_day,
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                        textAlign: TextAlign.center),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    itemCount: attendances.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Container(
                                  child: Text(attendances[index].check_in,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                      textAlign: TextAlign.center),
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  child: Text(attendances[index].check_out,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                      textAlign: TextAlign.center),
                                )),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                      size: 20,
                    )),
              ],
            )),
      ),
    );
  }
}
