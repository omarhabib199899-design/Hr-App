import '../payslipdetail/Data.dart';

class PayslipDetailResponse {
  Data data;
  String message;
  bool status;
  int status_code;

  PayslipDetailResponse(
      {required this.data,
      required this.message,
      required this.status,
      required this.status_code});

  factory PayslipDetailResponse.fromJson(Map<String, dynamic> json) {
    return PayslipDetailResponse(
      data: Data.fromJson(json['data']),
      message: json['message'],
      status: json['status'],
      status_code: json['status_code'],
    );
  }
}
