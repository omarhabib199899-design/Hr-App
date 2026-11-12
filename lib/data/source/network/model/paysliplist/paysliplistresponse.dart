import '../paysliplist/Data.dart';

class PaySlipListResponse {
  Data data;
  String message;
  bool status;
  int status_code;

  PaySlipListResponse(
      {required this.data,
      required this.message,
      required this.status,
      required this.status_code});

  factory PaySlipListResponse.fromJson(Map<String, dynamic> json) {
    return PaySlipListResponse(
      data: Data.fromJson(json['data']),
      message: json['message'],
      status: json['status'],
      status_code: json['status_code'],
    );
  }
}
