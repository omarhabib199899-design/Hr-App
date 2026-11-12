import 'dart:convert';
import 'dart:io';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/network/model/about/Aboutresponse.dart';
import 'package:cnattendance/data/source/network/model/complaintresponse/complaintresponse.dart';
import 'package:cnattendance/data/source/network/model/complaintresponse/departmentresponse.dart';
import 'package:cnattendance/data/source/network/model/warningresponse/warningresponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class ComplaintRepository {
  Future<DepartmentRepsonse> getDepartments() async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect()
          .getResponse("${Constant.EMPLOYEE_DEPARTMENT_URL}", headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final dashboardResponse = DepartmentRepsonse.fromMap(responseData);
        return dashboardResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw unknownError(e);
    }
  }

  Future<ComplaintRepsonse> getComplaints(int page) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(
          "${Constant.COMPLAINT_LIST_URL}?page=$page&per_page=10", headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final dashboardResponse = ComplaintRepsonse.fromMap(responseData);
        return dashboardResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw unknownError(e);
    }
  }

  Future<(bool, String)> writeComplaintResponse(
      String userResponse, String id) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      print(userResponse);
      print(id);
      final response = await Connect().postResponse(
          "${Constant.COMPLAINT_RESPONSE_URL}$id",
          headers,
          {"message": userResponse});
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return (true, responseData["message"].toString());
      } else {
        var errorMessage = responseData['message'];
        return (false, responseData["message"].toString());
      }
    } catch (e) {
      return (false, unknownError(e));
    }
  }

  Future<(bool, String)> applyComplaint(List<int> departmentId,
      List<int> employeeId, String subject, String message) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      HttpHeaders.contentTypeHeader: "application/json"
    };

    try {
      final response = await Connect()
          .postResponseRaw("${Constant.COMPLAINT_APPLY_URL}", headers, {
        "department_id": departmentId,
        "employee_id": employeeId,
        "subject": subject,
        "message": message
      });
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return (true, responseData["message"].toString());
      } else {
        var errorMessage = responseData['message'];
        return (false, responseData["message"].toString());
      }
    } catch (e) {
      return (false, unknownError(e));
    }
  }
}
