

class GeneralResponse {
  GeneralResponse({
    required this.status,
    required this.message,
    required this.statusCode,
  });

  factory GeneralResponse.fromJson(dynamic json) {
    return GeneralResponse(
        status: json['status'] ?? false,
        message: json['message'] ?? "",
        statusCode: json['status_code'] ?? 400);
  }

  bool status;
  String message;
  int statusCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['status_code'] = statusCode;
    return map;
  }
}
