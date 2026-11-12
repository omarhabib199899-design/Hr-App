import 'package:cnattendance/data/source/network/model/paysliplist/Payslip.dart';

class Data {
    String currency;
    List<Payslip> payslip;

    Data({required this.currency,required this.payslip});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            currency: json['currency'], 
            payslip: (json['payslip'] as List).map((i) => Payslip.fromJson(i)).toList(),
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['currency'] = this.currency;
        if (this.payslip != null) {
            data['payslip'] = this.payslip.map((v) => v.toJson()).toList();
        }
        return data;
    }
}