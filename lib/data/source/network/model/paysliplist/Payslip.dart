class Payslip {
  String absent_days;
  String duration;
  String holidays;
  int id;
  String leave_days;
  String net_salary;
  String payslip_id;
  String present_days;
  String salary_cycle;
  String salary_from;
  String salary_to;
  String total_days;
  String weekends;

  Payslip(
      {required this.absent_days,
      required this.duration,
      required this.holidays,
      required this.id,
      required this.leave_days,
      required this.net_salary,
      required this.payslip_id,
      required this.present_days,
      required this.salary_cycle,
      required this.salary_from,
      required this.salary_to,
      required this.total_days,
      required this.weekends});

  factory Payslip.fromJson(Map<String, dynamic> json) {
    return Payslip(
      absent_days: json['absent_days'].toString(),
      duration: json['duration'].toString(),
      holidays: json['holidays'].toString(),
      id: json['id'],
      leave_days: json['leave_days'].toString(),
      net_salary: json['net_salary'].toString(),
      payslip_id: json['payslip_id'].toString(),
      present_days: json['present_days'].toString(),
      salary_cycle: json['salary_cycle'].toString(),
      salary_from: json['salary_from'].toString(),
      salary_to: json['salary_to'].toString(),
      total_days: json['total_days'].toString(),
      weekends: json['weekends'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['absent_days'] = this.absent_days;
    data['duration'] = this.duration;
    data['holidays'] = this.holidays;
    data['id'] = this.id;
    data['leave_days'] = this.leave_days;
    data['net_salary'] = this.net_salary;
    data['payslip_id'] = this.payslip_id;
    data['present_days'] = this.present_days;
    data['salary_cycle'] = this.salary_cycle;
    data['salary_from'] = this.salary_from;
    data['salary_to'] = this.salary_to;
    data['total_days'] = this.total_days;
    data['weekends'] = this.weekends;
    return data;
  }
}
