import 'package:cnattendance/data/source/network/model/dashboard/Feature.dart';
import 'package:cnattendance/data/source/network/model/dashboard/RecentAward.dart';
import 'package:cnattendance/data/source/network/model/eventlistresponse/eventdetailresponse.dart';
import 'package:cnattendance/data/source/network/model/hollidays/Holidays.dart';
import 'package:cnattendance/data/source/network/model/teamsheet/Employee.dart'
    as employees;
import 'package:cnattendance/data/source/network/model/trainingresponse/trainingresponse.dart';
import 'package:cnattendance/model/award.dart';

import 'User.dart';
import 'EmployeeTodayAttendance.dart';
import 'Overview.dart';
import 'OfficeTime.dart';
import 'Company.dart';

class Dashboard {
  Dashboard({
    required this.user,
    required this.employeeTodayAttendance,
    required this.overview,
    required this.officeTime,
    required this.company,
    required this.employeeWeeklyReport,
    required this.shift_dates,
    required this.attedanceMethod,
    required this.dateInAd,
    required this.addNfc,
    required this.attendance_note,
    required this.employee_location,
    required this.employee,
    required this.features,
    required this.holiday,
    required this.recentAward,
    required this.recentTraining,
    required this.recentEvent,
  });

  factory Dashboard.fromJson(dynamic json) {
    return Dashboard(
      user: User.fromJson(json['user']),
      employeeTodayAttendance:
          EmployeeTodayAttendance.fromJson(json['employee_today_attendance']),
      overview: Overview.fromJson(json['overview']),
      officeTime: OfficeTime.fromJson(json['office_time']),
      company: Company.fromJson(json['company']),
      employeeWeeklyReport: json['employee_weekly_report'],
      shift_dates: List.from(json['shift_dates']),
      attedanceMethod: List.from(json['attendance_method']),
      dateInAd: json['date_in_ad'],
      addNfc: json['add_nfc'] ?? true,
      attendance_note: json['attendance_note'] ?? false,
      employee: json["teamMembers"] != null
          ? List<employees.Employee>.from(
              json['teamMembers'].map((x) => employees.Employee.fromJson(x)))
          : [],
      features:
          (json['features'] as List).map((i) => Feature.fromJson(i)).toList(),
      holiday: json["recent_holiday"] != null
          ? Holidays.fromJson(json["recent_holiday"])
          : null,
      employee_location: json["employee_location"] != null
          ? json["employee_location"]
          : false,
      recentAward: json["recent_award"] != null
          ? RecentAward.fromJson(json['recent_award'])
          : null,
      recentTraining: json["recent_training"] != null
          ? Training.fromMap(json['recent_training'])
          : null,
      recentEvent: json["recent_event"] != null
          ? EventApi.fromMap(json['recent_event'])
          : null,
    );
  }

  User user;
  List<Feature> features;
  EmployeeTodayAttendance employeeTodayAttendance;
  Overview overview;
  OfficeTime officeTime;
  Company company;
  List<dynamic> employeeWeeklyReport;
  List<String> shift_dates;
  List<String> attedanceMethod;
  bool dateInAd;
  bool addNfc;
  bool attendance_note;
  bool employee_location;
  List<employees.Employee> employee;
  Holidays? holiday;
  RecentAward? recentAward;
  Training? recentTraining;
  EventApi? recentEvent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user'] = user.toJson();
    map['employee_today_attendance'] = employeeTodayAttendance.toJson();
    map['overview'] = overview.toJson();
    map['office_time'] = officeTime.toJson();
    map['company'] = company.toJson();
    map['employee_weekly_report'] =
        employeeWeeklyReport.map((v) => v.toJson()).toList();
    return map;
  }
}
