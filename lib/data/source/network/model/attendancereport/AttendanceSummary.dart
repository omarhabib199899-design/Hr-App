class AttendanceSummary {
  AttendanceSummary({
      required this.totalPresent,
      required this.totalWorkedHours,});

  factory AttendanceSummary.fromJson(dynamic json) {
    return AttendanceSummary(
        totalPresent : json['totalPresent'].toString() ?? "-",
        totalWorkedHours : json['totalWorkedHours'].toString() ?? "-"
    );
  }
  String totalPresent;
  String totalWorkedHours;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalPresent'] = totalPresent;
    map['totalWorkedHours'] = totalWorkedHours;
    return map;
  }

}