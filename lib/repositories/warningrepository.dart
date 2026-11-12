import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/network/model/about/Aboutresponse.dart';
import 'package:cnattendance/data/source/network/model/warningresponse/warningresponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class WarningRepository {
  Future<WarningRepsonse> getWarnings(int page) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(
          "${Constant.WARNING_LIST_URL}?page=$page&per_page=10", headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final dashboardResponse = WarningRepsonse.fromMap(responseData);
        return dashboardResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw unknownError(e);
    }
  }

  Future<(bool, String)> writeResponse(String userResponse, String id) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Authorization': 'Bearer $token'
    };

    try {
      print(userResponse);
      print(id);
      final response = await Connect().postResponse(
          "${Constant.WARNING_RESPONSE_URL}$id",
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
}
