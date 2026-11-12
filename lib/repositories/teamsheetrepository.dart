
import 'dart:convert';
import 'dart:developer';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/network/model/teamsheet/Teamsheetresponse.dart';
import 'package:cnattendance/utils/constant.dart';

class TeamSheetRepository{
  Future<Teamsheetresponse> getTeam() async {
    Preferences preferences = Preferences();

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(Constant.TEAM_SHEET_URL, headers);
      print(response.body);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        log(responseData.toString());

        final responseJson = Teamsheetresponse.fromJson(responseData);
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