import 'package:cnattendance/data/source/network/model/attendancereport/AttendanceSummary.dart';
import 'package:cnattendance/data/source/network/model/attendancereport/EmployeeAttendance.dart';
import 'package:cnattendance/data/source/network/model/attendancereport/EmployeeTodayAttendance.dart';
import 'package:cnattendance/model/employeeattendancereport.dart';
import 'package:cnattendance/model/month.dart';
import 'package:cnattendance/repositories/attendancereportrepository.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class AttendanceReportProvider with ChangeNotifier {
  final List<EmployeeAttendanceReport> _attendanceReport = [];
  AttendanceReportRepository repository = AttendanceReportRepository();

  final Map<String, dynamic> _todayReport = {
    'check_in_at': '-',
    'check_out_at': '-',
    'production_hour': '0 hr 0 min',
    'production_percent': 0.0,
  };

  final Map<String, dynamic> _currentMonthReport = {
    'present_days': '0',
    'worked_hour': '0h 0m',
  };

  List<Month> month = [];

  var isLoading = false;

  int selectedMonth = DateTime.now().month - 1;

  List<EmployeeAttendanceReport> get attendanceReport {
    return [..._attendanceReport];
  }

  Map<String, dynamic> get todayReport {
    return _todayReport;
  }

  Map<String, dynamic> get currentMonthReport {
    return _currentMonthReport;
  }

  void getDate() async {
    final isAd = (await repository.getDateInAd());
    month = isAd ? engMonth : nepaliMonth;

    NepaliDateTime currentTime = NepaliDateTime.now();
    selectedMonth =
        await isAd ? DateTime.now().month - 1 : currentTime.month - 1;
    notifyListeners();
    getAttendanceReport();
  }

  Future<void> getAttendanceReport() async {
    isLoading = true;
    try {
      final responseJson = await repository.getAttendanceReport(selectedMonth);
      isLoading = false;
      makeTodayReport(responseJson.data.employeeTodayAttendance);
      makeMonthlyReport(responseJson.data.attendanceSummary);
      makeAttendanceReport(responseJson.data.employeeAttendance);
      getProdHour(
          int.parse(responseJson.data.employeeTodayAttendance.productiveTime));
    } catch (error) {
      isLoading = false;
      throw error;
    }
  }

  void makeAttendanceReport(List<EmployeeAttendance> employeeAttendance) {
    _attendanceReport.clear();
    for (var item in employeeAttendance) {
      _attendanceReport.add(EmployeeAttendanceReport(
        id: item.id,
        attendance_date: item.attendanceDate,
        week_day: item.weekDay,
        worked_hours: item.workedhrs ?? "-",
        working_hours: item.workingHour ?? "-",
        check_in: item.checkIn,
        check_out: item.checkOut,
        overTime: item.overTime,
        underTime: item.underTime,
        isOverTime: item.isOverTime,
        isUnderTime: item.isUnderTime,
        worked_hours_min: item.workedhrsMin,
        working_hours_min: item.workingHourMin,
      ));
    }

    notifyListeners();
  }

  void makeTodayReport(EmployeeTodayAttendance employeeTodayAttendance) {
    _todayReport['check_in_at'] = employeeTodayAttendance.checkInAt;
    _todayReport['check_out_at'] = employeeTodayAttendance.checkOutAt;

    print(_todayReport['check_in_at']);
    print(_todayReport['check_out_at']);

    notifyListeners();
  }

  void makeMonthlyReport(AttendanceSummary attendanceSummary) {
    _currentMonthReport['present_days'] = attendanceSummary.totalPresent;
    _currentMonthReport['worked_hour'] = attendanceSummary.totalWorkedHours;

    notifyListeners();
  }

  String getProdHour(int value) {
    double second = value * 60.toDouble();
    double min = second / 60;
    int minGone = (min % 60).toInt();
    int hour = min ~/ 60;

    print("$hour hr $minGone min");
    _todayReport['production_hour'] = "$hour hr $minGone min";

    double hours = value / 60;
    double hr = hours / Constant.TOTAL_WORKING_HOUR;

    _todayReport['production_percent'] = hr > 1.0 ? 1.0 : hr;

    notifyListeners();
    return "$hour hr $minGone min";
  }
}
