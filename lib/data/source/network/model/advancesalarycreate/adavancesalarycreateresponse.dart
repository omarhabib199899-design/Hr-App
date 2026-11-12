
class AdavanceSalaryCreateResponse {
  String message;
  bool status;
  int status_code;

  AdavanceSalaryCreateResponse(
      {
      required this.message,
      required this.status,
      required this.status_code});

  factory AdavanceSalaryCreateResponse.fromJson(Map<String, dynamic> json) {
    return AdavanceSalaryCreateResponse(
      message: json['message'],
      status: json['status'],
      status_code: json['status_code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['status_code'] = this.status_code;
    return data;
  }
}
