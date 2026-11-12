import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/paysliplist/Payslip.dart';
import 'package:cnattendance/data/source/network/model/paysliplist/paysliplistresponse.dart';
import 'package:cnattendance/data/source/network/model/ssflistresponse/ssflistresponse.dart';
import 'package:cnattendance/model/month.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:http/http.dart' as http;

class SSFProvider with ChangeNotifier {
  bool isAD = true;
  List<int> year = [];
  int selectedYear = DateTime.now().year;

  List<History> ssfList = [];
  String currency = "";

  Future<void> getBS() async {
    Preferences preferences = Preferences();
    isAD = (await preferences.getEnglishDate()) ? true : false;

    makeYear();
    notifyListeners();
  }

  void makeYear() {
    year.clear();
    if (isAD) {
      year.add(DateTime.now().year);
      year.add((DateTime.now().year) - 1);
      year.add((DateTime.now().year) - 2);
      year.add((DateTime.now().year) - 3);

      selectedYear = DateTime.now().year;
    } else {
      year.add(NepaliDateTime.now().year);
      year.add((NepaliDateTime.now().year) - 1);
      year.add((NepaliDateTime.now().year) - 2);
      year.add((NepaliDateTime.now().year) - 3);

      selectedYear = NepaliDateTime.now().year;
    }

    getSSFHistory(selectedYear);
    notifyListeners();
  }

  Future<void> getSSFHistory(int? year) async {
    ssfList.clear();
    notifyListeners();

    Preferences preferences = Preferences();
    var uri =
        Uri.parse(await preferences.getAppUrl() + Constant.SSF_HISTORY_URL +"?year=$year");

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers,);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData.toString());

        final responseJson = SsfListResponse.fromJson(responseData);
        currency = responseJson.data.currency;
        ssfList = responseJson.data.history;
        notifyListeners();
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      print(error.toString());
      throw unknownError(error);
    }
  }
}
