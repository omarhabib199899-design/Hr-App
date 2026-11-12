import 'package:flutter/material.dart';

class EmployeeAttendanceReport with ChangeNotifier {
  int id;
  String attendance_date;
  String week_day;
  String worked_hours;
  String working_hours;
  String check_in;
  String check_out;
  bool isOverTime;
  bool isUnderTime;
  String overTime;
  String underTime;
  double worked_hours_min;
  double working_hours_min;

  EmployeeAttendanceReport({
    required this.id,
    required this.attendance_date,
    required this.week_day,
    required this.worked_hours,
    required this.working_hours,
    required this.check_in,
    required this.check_out,
    required this.isOverTime,
    required this.isUnderTime,
    required this.overTime,
    required this.underTime,
    required this.worked_hours_min,
    required this.working_hours_min,
  });

  static Map<String, List<EmployeeAttendanceReport>> groupAttendanceByDate(
      List<EmployeeAttendanceReport> attendanceList) {
    Map<String, List<EmployeeAttendanceReport>> groupedAttendance = {};

    for (var attendance in attendanceList) {
      // Get the attendance date as the key
      String date = attendance.attendance_date;

      // If the date is not yet a key in the map, initialize an empty list
      if (!groupedAttendance.containsKey(date)) {
        groupedAttendance[date] = [];
      }

      // Add the attendance record to the list for that date
      groupedAttendance[date]!.add(attendance);
    }

    return groupedAttendance;
  }
}
