// To parse this JSON data, do
//
//     final ssfListResponse = ssfListResponseFromJson(jsonString);

import 'dart:convert';

SsfListResponse ssfListResponseFromJson(String str) =>
    SsfListResponse.fromJson(json.decode(str));

String ssfListResponseToJson(SsfListResponse data) =>
    json.encode(data.toJson());

class SsfListResponse {
  bool status;
  String message;
  int statusCode;
  Data data;

  SsfListResponse({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory SsfListResponse.fromJson(Map<String, dynamic> json) =>
      SsfListResponse(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "status_code": statusCode,
        "data": data.toJson(),
      };
}

class Data {
  String currency;
  List<History> history;

  Data({
    required this.currency,
    required this.history,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currency: json["currency"],
        history:
            List<History>.from(json["history"].map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "history": List<dynamic>.from(history.map((x) => x.toJson())),
      };
}

class History {
  String month;
  int officeContribution;
  int salaryContribution;

  History({
    required this.month,
    required this.officeContribution,
    required this.salaryContribution,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        month: json["month"],
        officeContribution: json["office_contribution"],
        salaryContribution: json["salary_contribution"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "office_contribution": officeContribution,
        "salary_contribution": salaryContribution,
      };
}
