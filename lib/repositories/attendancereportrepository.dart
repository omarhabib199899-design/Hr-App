import 'dart:convert';
import 'dart:developer';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/network/model/attendancereport/AttendanceReportResponse.dart';
import 'package:cnattendance/utils/constant.dart';

class AttendanceReportRepository {
  Future<AttendanceReportResponse> getAttendanceReport(
      int selectedMonth) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    try {
      final response = await Connect().getResponse(
          Constant.ATTENDANCE_REPORT_URL + "?month=${selectedMonth + 1}",
          headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        log(responseData.toString());

        final responseJson = AttendanceReportResponse.fromJson(responseData);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw unknownError(error);
    }
  }

  Future<bool> getDateInAd() async {
    Preferences preferences = Preferences();
    bool value = await preferences.getEnglishDate();

    return value;
  }
}
