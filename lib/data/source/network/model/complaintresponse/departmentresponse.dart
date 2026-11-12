import 'dart:convert';

DepartmentRepsonse departmentRepsonseFromMap(String str) =>
    DepartmentRepsonse.fromMap(json.decode(str));

String departmentRepsonseToMap(DepartmentRepsonse data) =>
    json.encode(data.toMap());

class DepartmentRepsonse {
  final bool status;
  final String message;
  final int statusCode;
  final List<DepartmentApi> data;

  DepartmentRepsonse({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory DepartmentRepsonse.fromMap(Map<String, dynamic> json) =>
      DepartmentRepsonse(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        data: List<DepartmentApi>.from(
            json["data"].map((x) => DepartmentApi.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class DepartmentApi {
  final String id;
  final String name;
  final List<Employee> employee;

  DepartmentApi({
    required this.id,
    required this.name,
    required this.employee,
  });

  factory DepartmentApi.fromMap(Map<String, dynamic> json) => DepartmentApi(
        id: json["id"].toString(),
        name: json["name"].toString(),
        employee: List<Employee>.from(
            json["employee"].map((x) => Employee.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "employee": List<dynamic>.from(employee.map((x) => x.toMap())),
      };
}

class Employee {
  final int id;
  final String name;

  Employee({
    required this.id,
    required this.name,
  });

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
