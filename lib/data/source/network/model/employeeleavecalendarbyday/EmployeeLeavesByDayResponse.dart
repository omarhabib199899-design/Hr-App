import '../employeeleavecalendarbyday/Data.dart';
import 'EmployeeLeavesByDay.dart';

class EmployeeLeavesByDayResponse {
  EmployeeLeavesByDayResponse({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory EmployeeLeavesByDayResponse.fromJson(dynamic json) {
    return EmployeeLeavesByDayResponse(
        status: json['status'],
        message: json['message'],
        statusCode: json['status_code'],
        data: Data.fromJson(json["data"]));
  }

  bool status;
  String message;
  int statusCode;
  Data data;
}
