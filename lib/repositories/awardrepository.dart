import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/network/model/awardlist/awardlistresponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class AwardRepository {
  Future<AwardListResponse> getAwards() async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response =
          await Connect().getResponse(Constant.AWARDS_URL, headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = AwardListResponse.fromJson(responseData);
        return jsonResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw unknownError(e);
    }
  }
}
