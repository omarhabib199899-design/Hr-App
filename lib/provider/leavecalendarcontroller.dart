import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/employeeleavecalendar/Employeeleavecalendarresponse.dart';
import 'package:cnattendance/data/source/network/model/employeeleavecalendarbyday/Birthday.dart';
import 'package:cnattendance/data/source/network/model/employeeleavecalendarbyday/Holiday.dart'
    as holi;
import 'package:cnattendance/data/source/network/model/employeeleavecalendarbyday/EmployeeLeavesByDay.dart';
import 'package:cnattendance/data/source/network/model/employeeleavecalendarbyday/EmployeeLeavesByDayResponse.dart';
import 'package:cnattendance/model/LeaveByDay.dart';
import 'package:cnattendance/model/holiday.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../data/source/network/model/hollidays/Holidays.dart';

class LeaveCalendarController extends GetxController {
  var current = DateTime.now().obs;
  var selected = DateTime.now().obs;
  var currentMonth = DateTime.now().month.obs;
  var nextMonth = (DateTime.now().month + 1).obs;

  RxMap<String, List<dynamic>> _employeeLeaveList = <String, List<dynamic>>{}.obs;

  var _employeeLeaveByDayList = <LeaveByDay>[].obs;
  final Rxn<Holiday> _employeeHoliday = Rxn<Holiday>();
  var  _employeeBirthdayList = <Birthday>[].obs;

  var toggleValue = 0.obs;

  var isAd = true.obs;

  Map<String, List<dynamic>> get employeeLeaveList {
    return _employeeLeaveList.value;
  }

  List<LeaveByDay> get employeeLeaveByDayList {
    return _employeeLeaveByDayList.value;
  }

  Holiday? get employeeHoliday {
    return _employeeHoliday.value;
  }

  List<Birthday> get employeeBirthdayList {
    return _employeeBirthdayList;
  }

  void changeToggle(int value) {
    toggleValue.value = value;
  }

  Future<void> getIsAd() async {
    Preferences preferences = Preferences();

    isAd.value = await preferences.getEnglishDate();
  }

  Future<Employeeleavecalendarresponse> getLeaves() async {
    Preferences preferences = Preferences();
    var uri =
        Uri.parse(await preferences.getAppUrl() + Constant.LEAVE_CALENDAR_API);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        debugPrint(responseData.toString());

        final responseJson =
            Employeeleavecalendarresponse.fromJson(responseData);

        _employeeLeaveList.clear();

        for (var item in responseJson.data) {
          List<int> list = [];
          for (int i = 0; i < int.parse(item.leaveCount); i++) {
            list.add(i);
          }
          _employeeLeaveList.addAll({item.date: list});
        }

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<EmployeeLeavesByDayResponse> getLeavesByDay(String value) async {
    Preferences preferences = Preferences();
    print("Leave date for " + value.toString());
    var uri =
        Uri.parse(await preferences.getAppUrl() + Constant.OFFICE_CALENDAR_API)
            .replace(queryParameters: {'leave_date': value});

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        debugPrint(responseData.toString());

        final responseJson = EmployeeLeavesByDayResponse.fromJson(responseData);

        makeLeaveByDayList(responseJson.data.employeeLeaves);
        makeHolidayList(responseJson.data.holidays);
        _employeeBirthdayList.clear();
        _employeeBirthdayList.addAll(responseJson.data.birthdays);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  void makeLeaveByDayList(List<EmployeeLeavesByDay> data) {
    _employeeLeaveByDayList.clear();
    for (var item in data) {
      _employeeLeaveByDayList.add(LeaveByDay(
          id: item.leaveId,
          name: item.userName,
          post: item.post,
          days: item.leaveDays,
          avatar: item.userAvatar));
    }
  }

  Future<void> makeHolidayList(holi.Holiday? item) async {
    if (item != null) {
      Preferences preferences = Preferences();
      bool isAd = await preferences.getEnglishDate();

      DateTime tempDate = DateFormat("yyyy-MM-dd").parse(item.event_date);

      NepaliDateTime nepaliDate = tempDate.toNepaliDateTime();

      _employeeHoliday.value = Holiday(
          id: item.id,
          day: isAd
              ? DateFormat('dd').format(tempDate)
              : NepaliDateFormat('dd').format(nepaliDate),
          month: isAd
              ? DateFormat('MMM').format(tempDate)
              : NepaliDateFormat('MMMM').format(nepaliDate),
          title: item.event,
          description: item.description,
          dateTime: tempDate,
          isPublicHoliday: item.is_public_holiday);

    }else{
      _employeeHoliday.value = null;
    }
  }

  void getLeaveByDate(DateTime value) async {
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(value);
    getLeavesByDay(outputDate);
  }

  @override
  void onReady() {
    getIsAd();
    getLeaves();

    var inputDate = DateTime.now();
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    getLeavesByDay(outputDate);

    super.onReady();
  }
}
