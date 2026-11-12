import 'package:cnattendance/data/source/network/model/employeeleavecalendarbyday/Birthday.dart';
import 'package:cnattendance/data/source/network/model/employeeleavecalendarbyday/EmployeeLeavesByDay.dart';
import 'package:cnattendance/data/source/network/model/employeeleavecalendarbyday/Holiday.dart';

class Data {
  Data({
    required this.employeeLeaves,
    required this.holidays,
    required this.birthdays,
  });

  factory Data.fromJson(dynamic json) {
    return Data(
      employeeLeaves: List<EmployeeLeavesByDay>.from(
          json['leaves'].map((x) => EmployeeLeavesByDay.fromJson(x))),
      holidays:
          json["holiday"] != null ? Holiday.fromJson(json['holiday']) : null,
      birthdays: List<Birthday>.from(
          json['birthdays'].map((x) => Birthday.fromJson(x))),
    );
  }

  List<Birthday> birthdays;
  Holiday? holidays;
  List<EmployeeLeavesByDay> employeeLeaves;
}
