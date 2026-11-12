class Data {
  String description;
  int id;
  bool is_settled;
  String released_amount;
  String released_date;
  String remark;
  String requested_amount;
  String requested_date;
  String status;
  String verified_by;

  Data(
      {required this.description,
      required this.id,
      required this.is_settled,
      required this.released_amount,
      required this.released_date,
      required this.remark,
      required this.requested_amount,
      required this.requested_date,
      required this.status,
      required this.verified_by});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      description: json['description'].toString(),
      id: json['id'],
      is_settled: json['is_settled'],
      released_amount: json['released_amount'].toString()??"0",
      released_date: json['released_date'].toString(),
      remark: json['remark'].toString(),
      requested_amount: json['requested_amount'].toString()??"0",
      requested_date: json['requested_date'].toString(),
      status: json['status'].toString(),
      verified_by: json['verified_by'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['is_settled'] = this.is_settled;
    data['released_amount'] = this.released_amount;
    data['released_date'] = this.released_date;
    data['remark'] = this.remark;
    data['requested_amount'] = this.requested_amount;
    data['requested_date'] = this.requested_date;
    data['status'] = this.status;
    return data;
  }
}
