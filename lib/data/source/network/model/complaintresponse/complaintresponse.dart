import 'dart:convert';

ComplaintRepsonse complaintRepsonseFromMap(String str) => ComplaintRepsonse.fromMap(json.decode(str));

String complaintRepsonseToMap(ComplaintRepsonse data) => json.encode(data.toMap());

class ComplaintRepsonse {
  final bool status;
  final String message;
  final int statusCode;
  final List<Complaint> data;

  ComplaintRepsonse({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory ComplaintRepsonse.fromMap(Map<String, dynamic> json) => ComplaintRepsonse(
    status: json["status"],
    message: json["message"],
    statusCode: json["status_code"],
    data: List<Complaint>.from(json["data"].map((x) => Complaint.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    "status_code": statusCode,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class Complaint {
  final int id;
  final String subject;
  final String message;
  final String complaintDate;
  final String response;

  Complaint({
    required this.id,
    required this.subject,
    required this.message,
    required this.complaintDate,
    required this.response,
  });

  factory Complaint.fromMap(Map<String, dynamic> json) => Complaint(
    id: json["id"],
    subject: json["subject"],
    message: json["message"],
    complaintDate: json["complaint_date"],
    response: json["response"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "subject": subject,
    "message": message,
    "complaint_date": complaintDate,
    "response": response,
  };
}