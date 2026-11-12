import 'dart:convert';

TrainingResponse trainingRepsonseFromMap(String str) =>
    TrainingResponse.fromMap(json.decode(str));

class TrainingResponse {
  final List<Training> data;
  final bool status;
  final int statusCode;

  TrainingResponse({
    required this.data,
    required this.status,
    required this.statusCode,
  });

  factory TrainingResponse.fromMap(Map<String, dynamic> json) =>
      TrainingResponse(
        data: List<Training>.from(json["data"].map((x) => Training.fromMap(x))),
        status: json["status"],
        statusCode: json["status_code"],
      );
}

class Training {
  final int id;
  final String trainingType;
  final List<Employee> employees;
  final List<Department> departments;
  final String description;
  final String cost;
  final String venue;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String certificate;
  final List<Trainer> trainer;

  Training({
    required this.id,
    required this.trainingType,
    required this.employees,
    required this.departments,
    required this.description,
    required this.cost,
    required this.venue,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.certificate,
    required this.trainer,
  });

  factory Training.fromMap(Map<String, dynamic> json) => Training(
        id: json["id"],
        trainingType: json["training_type"],
        employees:
            (json['employee'] as List).map((i) => Employee.fromMap(i)).toList(),
        departments: (json['department'] as List)
            .map((i) => Department.fromMap(i))
            .toList(),
        description: json["description"],
        cost: json["cost"],
        venue: json["venue"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        certificate: json["certificate"],
        trainer:
            (json['trainer'] as List).map((i) => Trainer.fromMap(i)).toList(),
      );
}

class Trainer {
  final String id;
  final String trainerType;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String expertise;
  final String user_id;
  final bool is_trainer;

  Trainer({
    required this.id,
    required this.trainerType,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.expertise,
    required this.user_id,
    required this.is_trainer,
  });

  factory Trainer.fromMap(Map<String, dynamic> json) => Trainer(
        id: json["id"].toString(),
        trainerType: json["trainer_type"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        expertise: json["expertise"],
        user_id: json["user_id"].toString(),
        is_trainer: json["is_trainer"] ?? false,
      );
}

class Employee {
  final String id;
  final String name;

  Employee({
    required this.id,
    required this.name,
  });

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        id: json["id"].toString(),
        name: json["name"],
      );
}

class Department {
  final String id;
  final String name;

  Department({
    required this.id,
    required this.name,
  });

  factory Department.fromMap(Map<String, dynamic> json) => Department(
        id: json["id"].toString(),
        name: json["name"],
      );
}
