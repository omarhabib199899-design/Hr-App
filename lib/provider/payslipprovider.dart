import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/paysliplist/Payslip.dart';
import 'package:cnattendance/data/source/network/model/paysliplist/paysliplistresponse.dart';
import 'package:cnattendance/model/month.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:http/http.dart' as http;

class PaySlipProvider with ChangeNotifier {
  bool isAD = true;
  List<Month> month = [];
  List<int> year = [];

  int selectedMonth = DateTime.now().month - 1;
  int selectedYear = DateTime.now().year;

  List<Payslip> payslips = [];
  String currency = "";

  Future<void> getBS() async {
    Preferences preferences = Preferences();
    isAD = (await preferences.getEnglishDate()) ? true : false;

    month = isAD ? engMonth : nepaliMonth;
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

      selectedMonth = DateTime.now().month - 1;
      selectedYear = DateTime.now().year;
    } else {
      year.add(NepaliDateTime.now().year);
      year.add((NepaliDateTime.now().year) - 1);
      year.add((NepaliDateTime.now().year) - 2);
      year.add((NepaliDateTime.now().year) - 3);

      selectedMonth = NepaliDateTime.now().month - 1;
      selectedYear = NepaliDateTime.now().year;
    }
    notifyListeners();
  }

  void clearPaySlip(){
    payslips.clear();
    notifyListeners();
  }

  Future<void> getPaySlipData(int? year, int? month) async {
    payslips.clear();
    notifyListeners();

    Preferences preferences = Preferences();
    var uri =
        Uri.parse(await preferences.getAppUrl() + Constant.PAYSLIP_LIST_URL);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        "year": year == null ? "" : year.toString(),
        "month": month == null ? "" : month.toString()
      });

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData.toString());

        final responseJson = PaySlipListResponse.fromJson(responseData);
        currency = responseJson.data.currency;
        payslips = responseJson.data.payslip;
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
