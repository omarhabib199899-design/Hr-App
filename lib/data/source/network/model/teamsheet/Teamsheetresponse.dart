import '../teamsheet/Data.dart';

class Teamsheetresponse {
  Teamsheetresponse({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory Teamsheetresponse.fromJson(dynamic json) {
    return Teamsheetresponse(
        status: json['status'],
        message: json['message'],
        statusCode: json['status_code'],
        data: Data.fromJson(json['data']));
  }

  bool status;
  String message;
  int statusCode;
  Data data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['status_code'] = statusCode;
    return map;
  }
}
