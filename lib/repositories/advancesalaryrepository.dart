import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/connect.dart';
import 'package:cnattendance/data/source/network/model/advancesalarycreate/adavancesalarycreateresponse.dart';
import 'package:cnattendance/data/source/network/model/advancesalarylist/adavancesalaryresponse.dart';
import 'package:cnattendance/data/source/network/model/advanceslarydetail/advancesalarydetailresponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';

class AdvanceSalaryRepository {
  Future<AdavanceSalaryResponse> getAdvanceList() async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect()
          .getResponse(Constant.ADVANCE_SALARY_LIST_URL, headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final adavanceSalary = AdavanceSalaryResponse.fromJson(responseData);

        return adavanceSalary;
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<AdavanceSalaryCreateResponse> createAdvanceSalary(
      String reqAmt, String desc) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect()
          .postResponse(Constant.ADVANCE_SALARY_CREATE_URL, headers, {
        "requested_amount": reqAmt,
        "description": desc,
      });
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {

        return AdavanceSalaryCreateResponse.fromJson(responseData);
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<AdavanceSalaryCreateResponse> updateAdvanceSalary(
      String id,String reqAmt, String desc) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect()
          .postResponse(Constant.ADVANCE_SALARY_UPDATE_URL, headers, {
        "advance_salary_id": id,
        "requested_amount": reqAmt,
        "description": desc,
      });
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {

        return AdavanceSalaryCreateResponse.fromJson(responseData);
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      throw unknownError(e);
    }
  }

  Future<advancesalarydetailresponse> getAdvanceSalaryDetail(
      String id) async {
    Preferences preferences = Preferences();
    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await Connect()
          .getResponse(Constant.ADVANCE_SALARY_DETAIL_URL+"/"+id, headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {

        return advancesalarydetailresponse.fromJson(responseData);
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      throw unknownError(e);
    }
  }

  Future<bool> getIsAd() async {
    Preferences preferences = Preferences();
    return await preferences.getEnglishDate();
  }
}
