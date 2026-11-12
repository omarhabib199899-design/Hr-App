import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/network/model/eventdetailresponse/eventlistresponse.dart';
import 'package:cnattendance/data/source/network/model/eventlistresponse/eventdetailresponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class EventsRepository {
  Future<EventListRepsonse> getEvents(int page, int isUpcoming) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect().getResponse(
          "${Constant.EVENT_LIST_URL}?page=$page&per_page=60&is_upcoming_event=$isUpcoming",
          headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = EventListRepsonse.fromMap(responseData);
        return jsonResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw unknownError(e);
    }
  }

  Future<EventDetailRepsonse> getEvent(String id) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response =
          await Connect().getResponse(Constant.EVENT_DETAIL_URL + id, headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = EventDetailRepsonse.fromMap(responseData);
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
