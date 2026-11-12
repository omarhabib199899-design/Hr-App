import 'package:cnattendance/data/source/network/model/payslipdetail/Deduction.dart';
import 'package:cnattendance/data/source/network/model/payslipdetail/Earning.dart';
import 'package:cnattendance/data/source/network/model/payslipdetail/PayslipData.dart';

class Data {
  String currency;
  String file;
  List<Deduction> deductions;
  List<Earning> earnings;
  PayslipData payslipData;

  Data(
      {required this.currency,
      required this.deductions,
      required this.earnings,
      required this.payslipData,required this.file});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      currency: json['currency'],
      deductions: (json['deductions'] as List)
          .map((i) => Deduction.fromJson(i))
          .toList(),
      earnings:
          (json['earnings'] as List).map((i) => Earning.fromJson(i)).toList(),
      payslipData: PayslipData.fromJson(json['payslipData']),
      file: json['file'].toString(),
    );
  }
}
