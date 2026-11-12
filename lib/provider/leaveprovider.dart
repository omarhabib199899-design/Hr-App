import 'dart:convert';

import 'package:cnattendance/data/source/network/model/generalresponse.dart';
import 'package:cnattendance/data/source/network/model/leaveissue/IssueLeaveResponse.dart';
import 'package:cnattendance/data/source/network/model/leavetype/LeaveType.dart';
import 'package:cnattendance/data/source/network/model/leavetype/Leavetyperesponse.dart';
import 'package:cnattendance/data/source/network/model/leavetypedetail/LeaveTypeDetail.dart';
import 'package:cnattendance/data/source/network/model/leavetypedetail/Leavetypedetailreponse.dart';
import 'package:cnattendance/data/source/network/model/resignationresponse/resignationresponse.dart';
import 'package:cnattendance/model/LeaveDetail.dart';
import 'package:cnattendance/model/leave.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cnattendance/data/source/datastore/preferences.dart';

class LeaveProvider with ChangeNotifier {
  final List<Leave> _leaveList = [];
  final List<Leave> filterLeaveList = [];
  final List<LeaveDetail> _leaveDetailList = [];

  var _selectedMonth = 0;
  var _selectedType = -1;

  int get selectedMonth {
    return _selectedMonth;
  }

  void setMonth(int value) {
    _selectedMonth = value;
  }

  int get selectedType {
    return _selectedType;
  }

  void setType(int value) {
    _selectedType = value;
  }

  List<Leave> get leaveList {
    return [..._leaveList];
  }

  List<LeaveDetail> get leaveDetailList {
    return [..._leaveDetailList];
  }

  Future<bool> isAd() async {
    Preferences preferences = Preferences();
    final value = await preferences.getEnglishDate();

    return value;
  }

  Future<Leavetyperesponse> getLeaveType() async {
    Preferences preferences = Preferences();
    var uri =
        Uri.parse(await preferences.getAppUrl() + Constant.LEAVE_TYPE_URL);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final response = await http.get(uri, headers: headers);

    final responseData = json.decode(response.body);
    debugPrint(responseData.toString());

    final responseJson = Leavetyperesponse.fromJson(responseData);
    makeLeaveList(responseJson.data);

    return responseJson;
  }

  void makeLeaveList(List<LeaveType> leaveList) {
    _leaveList.clear();
    filterLeaveList.clear();

    for (var leave in leaveList) {
      _leaveList.add(Leave(
          id: int.parse(leave.leaveTypeId),
          name: leave.leaveTypeName,
          allocated: leave.leaveTaken,
          total: int.parse(leave.totalLeaveAllocated),
          status: leave.leaveTypeStatus,
          isEarlyLeave: leave.earlyExit));
    }

    filterLeaveList.add(Leave(
        id: -1,
        name: "All",
        allocated: "0",
        total: 0,
        status: true,
        isEarlyLeave: false));
    filterLeaveList.add(Leave(
        id: 0,
        name: "Time Leave",
        allocated: "0",
        total: 0,
        status: true,
        isEarlyLeave: false));
    filterLeaveList.addAll(_leaveList.where((element) => element.id != 0));

    notifyListeners();
  }

  Future<Leavetypedetailreponse> getLeaveTypeDetail() async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(
            await preferences.getAppUrl() + Constant.LEAVE_TYPE_DETAIL_URL)
        .replace(queryParameters: {
      'month': _selectedMonth != 0 ? _selectedMonth.toString() : '',
      'leave_type': _selectedType != -1 ? _selectedType.toString() : '',
    });

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

        final responseJson = Leavetypedetailreponse.fromJson(responseData);

        makeLeaveTypeList(responseJson.data);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage.toString());
        throw errorMessage;
      }
    } catch (error) {
      print(error.toString());
      throw unknownError(error);
    }
  }

  void makeLeaveTypeList(List<LeaveTypeDetail> leaveList) {
    _leaveDetailList.clear();

    for (var leave in leaveList) {
      _leaveDetailList.add(LeaveDetail(
          id: leave.id,
          leavetypeId: leave.leaveTypeId,
          name: leave.leaveTypeName,
          leave_from: leave.leaveFrom,
          leave_to: leave.leaveTo,
          requested_date: leave.leaveRequestedDate,
          authorization: leave.statusUpdatedBy,
          status: leave.status));
    }

    notifyListeners();
  }

  Future<IssueLeaveResponse> issueLeave(String date, String from, String to,
      String reason, int leaveId, int earlyLeave) async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl() + Constant.ISSUE_LEAVE);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'issue_date': date,
        'leave_from': from,
        'leave_to': to,
        'leave_type_id': leaveId.toString(),
        'reasons': reason,
        'early_exit': earlyLeave.toString(),
      });

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final responseJson = IssueLeaveResponse.fromJson(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw unknownError(error);
    }
  }

  Future<IssueLeaveResponse> issueTimeLeave(
      String date, String from, String to, String reason) async {
    Preferences preferences = Preferences();
    var uri =
        Uri.parse(await preferences.getAppUrl() + Constant.ISSUE_TIME_LEAVE);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'issue_date': date,
        'leave_from': from,
        'leave_to': to,
        'reasons': reason,
      });

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final responseJson = IssueLeaveResponse.fromJson(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        debugPrint(errorMessage.toString());
        throw errorMessage;
      }
    } catch (error) {
      debugPrint(error.toString());
      throw unknownError(error);
    }
  }

  Future<GeneralResponse> issueResignation(String from,
      String reason) async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl() + Constant.APPLY_RESIGNATION_URL);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'last_working_day': from,
        'reason': reason,
      });

      print(response.body);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final responseJson = GeneralResponse.fromJson(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw unknownError(error);
    }
  }

  Future<ResignationRepsonse> getResignation() async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl() + Constant.RESIGNATION_URL);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);

      print(response.body);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final responseJson = ResignationRepsonse.fromMap(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw unknownError(error);
    }
  }

  Future<IssueLeaveResponse> cancelLeave(
      int leaveId, String leaveTypeId) async {
    Preferences preferences = Preferences();
    late Uri uri;

    if (leaveTypeId == "0") {
      uri = Uri.parse(await preferences.getAppUrl() +
          Constant.CANCEL_TIME_LEAVE +
          "/$leaveId");
    } else {
      uri = Uri.parse(
          await preferences.getAppUrl() + Constant.CANCEL_LEAVE + "/$leaveId");
    }

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final responseJson = IssueLeaveResponse.fromJson(responseData);

        debugPrint(responseJson.toString());
        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw unknownError(error);
    }
  }
}
