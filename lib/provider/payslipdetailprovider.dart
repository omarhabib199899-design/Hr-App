import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/payslipdetail/Deduction.dart';
import 'package:cnattendance/data/source/network/model/payslipdetail/Earning.dart';
import 'package:cnattendance/data/source/network/model/payslipdetail/payslipdetailresponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PaySlipDetailProvider with ChangeNotifier {
  String currency = "";

  List<Earning> _earningList = [];

  List<Earning> get earningList {
    return [..._earningList];
  }

  final Map<String, String> payslipDetail = {
    "company_name": "",
    "company_address": "",
    "company_image": "",
    "salary_title": "",
    "payslip_slug": "",
    "employee_name": "",
    "employee_designation": "",
    "employee_id": "",
    "employee_join_date": "",
    "net_salary": "",
    "net_salary_in_words": "",
    "pdf_raw": "",
    "absent_deduction": "",
    "tada": "",
    "advance_salary": "",
    "overtime": "",
    "undertime": "",
    "employee_code": "",
  };

  double getTotalEarning() {
    var value = 0.0;

    for (var item in _earningList) {
      value += double.parse(item.amount);
    }

    return value;
  }

  List<Deduction> _deductionList = [];

  List<Deduction> get deductionList {
    return [..._deductionList];
  }

  double getTotalDeduction() {
    var value = 0.0;

    for (var item in _deductionList) {
      value += double.parse(item.amount);
    }

    return value;
  }

  Future<void> getPaySlipData(String id) async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl()+Constant.PAYSLIP_DETAIL_URL + id);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData.toString());

        final responseJson = PayslipDetailResponse.fromJson(responseData);
        currency = responseJson.data.currency;

        _earningList.clear();
        _deductionList.clear();

        _earningList.add(Earning(
            amount: responseJson.data.payslipData.basic_salary,
            name: "Basic Salary"));
        _earningList.add(Earning(
            amount: responseJson.data.payslipData.fixed_allowance,
            name: "Fixed Allowance"));
        _deductionList.add(
            Deduction(amount: responseJson.data.payslipData.tds, name: "TDS"));
        _earningList.addAll(responseJson.data.earnings);
        _deductionList.addAll(responseJson.data.deductions);

        payslipDetail["company_name"] =
            responseJson.data.payslipData.company_name;
        payslipDetail["company_address"] =
            responseJson.data.payslipData.company_address;
        payslipDetail["company_image"] =
            responseJson.data.payslipData.company_logo;

        payslipDetail["employee_name"] =
            responseJson.data.payslipData.employee_name;
        payslipDetail["employee_designation"] =
            responseJson.data.payslipData.designation;
        payslipDetail["employee_id"] =
            responseJson.data.payslipData.employee_id;
        payslipDetail["employee_join_date"] =
            responseJson.data.payslipData.joining_date;

        payslipDetail["net_salary"] = responseJson.data.payslipData.net_salary;
        payslipDetail["net_salary_in_words"] =
            responseJson.data.payslipData.net_salary_figure;
        payslipDetail["pdf_raw"] = responseJson.data.file;
        payslipDetail["salary_title"] =
            responseJson.data.payslipData.payslip_title;
        payslipDetail["payslip_slug"] =
            responseJson.data.payslipData.payslip_title;
        payslipDetail["absent_deduction"] =
            responseJson.data.payslipData.absent_deduction;
        payslipDetail["tada"] = responseJson.data.payslipData.tada;
        payslipDetail["advance_salary"] =
            responseJson.data.payslipData.advance_salary;
        payslipDetail["overtime"] = responseJson.data.payslipData.overtime;
        payslipDetail["undertime"] = responseJson.data.payslipData.undertime;
        payslipDetail["employee_code"] = responseJson.data.payslipData.employee_code;

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
