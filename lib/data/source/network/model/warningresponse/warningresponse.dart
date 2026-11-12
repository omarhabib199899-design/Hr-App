import 'dart:convert';

WarningRepsonse warningRepsonseFromMap(String str) =>
    WarningRepsonse.fromMap(json.decode(str));

String warningRepsonseToMap(WarningRepsonse data) => json.encode(data.toMap());

class WarningRepsonse {
  final List<Warning> data;
  final String message;
  final bool status;
  final int statusCode;

  WarningRepsonse({
    required this.data,
    required this.message,
    required this.status,
    required this.statusCode,
  });

  factory WarningRepsonse.fromMap(Map<String, dynamic> json) => WarningRepsonse(
        data: List<Warning>.from(json["data"].map((x) => Warning.fromMap(x))),
        message: json["message"]??"",
        status: json["status"],
        statusCode: json["status_code"],
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "message": message,
        "status": status,
        "status_code": statusCode,
      };
}

class Warning {
  final int id;
  final String subject;
  final String message;
  final String warningDate;
  final String response;

  Warning({
    required this.id,
    required this.subject,
    required this.message,
    required this.warningDate,
    required this.response,
  });

  factory Warning.fromMap(Map<String, dynamic> json) => Warning(
        id: json["id"],
        subject: json["subject"].toString(),
        message: json["message"],
        warningDate: json["warning_date"].toString(),
        response: json["response"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "subject": subject,
        "message": message,
        "warning_date": warningDate,
        "response": response,
      };
}
