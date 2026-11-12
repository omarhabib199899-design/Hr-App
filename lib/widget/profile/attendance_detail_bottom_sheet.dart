import 'package:cnattendance/provider/attendancereportprovider.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../model/employeeattendancereport.dart';

class AttendanceDetailBottomSheet extends StatefulWidget {
  final String date;
  List<EmployeeAttendanceReport> attendances;

  AttendanceDetailBottomSheet(this.date, this.attendances);

  @override
  State<StatefulWidget> createState() => AttendanceDetailBottomSheetState();
}

class AttendanceDetailBottomSheetState
    extends State<AttendanceDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    double workedHr = 0;
    double workingHr = widget.attendances.first.working_hours_min;

    for(var att in widget.attendances){
      workedHr = workedHr + att.worked_hours_min;
    }

    double extraTime = workingHr - workedHr;

    return Container(
      decoration: RadialDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${translate('attendance_screen.attendance_summary')}",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  translate('attendance_screen.start_time'),
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  translate('attendance_screen.end_time'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  translate('attendance_screen.worked_hours'),
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
          ListView.builder(
            itemCount: widget.attendances.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              final attendance = widget.attendances[index];
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      attendance.check_in,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      attendance.check_out,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      attendance.worked_hours,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: Colors.white38,
              height: 5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate('attendance_screen.worked_hours'),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                convertMinutesToFormattedString(workedHr),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          if (extraTime.isNegative)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate('attendance_screen.overtime'),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  "+${convertMinutesToFormattedString(extraTime)}",
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
              ],
            ),
          if (!extraTime.isNegative)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate('attendance_screen.undertime'),
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  "-${convertMinutesToFormattedString(extraTime)}",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
        ],
      )),
    );
  }
}

String convertMinutesToFormattedString(double minutes) {
  int hours = (minutes / 60).floor();
  int remainingMinutes = (minutes % 60).round();
  return '${hours}h ${remainingMinutes}m';
}
