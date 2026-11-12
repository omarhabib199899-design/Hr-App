import 'dart:convert';

ResignationRepsonse resignationRepsonseFromMap(String str) =>
    ResignationRepsonse.fromMap(json.decode(str));

class ResignationRepsonse {
  final bool status;
  final String message;
  final int statusCode;
  final Data? data;

  ResignationRepsonse({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory ResignationRepsonse.fromMap(Map<String, dynamic> json) =>
      ResignationRepsonse(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        data: Data.fromMap(json["data"]),
      );
}

class Data {
  final int id;
  final String employeeId;
  final String resignationDate;
  final String lastWorkingDay;
  final String reason;
  final String status;
  final String remark;
  final DateTime createdAt;
  final DateTime updatedAt;

  Data({
    required this.id,
    required this.employeeId,
    required this.resignationDate,
    required this.lastWorkingDay,
    required this.reason,
    required this.status,
    required this.remark,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        employeeId: json["employee_id"].toString(),
        resignationDate: json["resignation_date"].toString()??"",
        lastWorkingDay: json["last_working_day"].toString()??"",
        reason: json["reason"],
        status: json["status"],
        remark: json["admin_remark"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}
