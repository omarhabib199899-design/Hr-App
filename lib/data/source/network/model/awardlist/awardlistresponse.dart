import '../awardlist/Data.dart';

class AwardListResponse {
  Data data;
  String message;
  bool status;
  int status_code;

  AwardListResponse({required
  this.data, required
  this.message, required
  this.status, required
  this.status_code});

  factory AwardListResponse.fromJson(Map<String, dynamic> json) {
    return AwardListResponse(
      data: Data.fromJson(json['data']),
      message: json['message'],
      status: json['status'],
      status_code: json['status_code'],
    );
  }
}