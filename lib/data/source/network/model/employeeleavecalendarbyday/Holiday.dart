class Holiday {
  Holiday({
    required this.id,
    required this.event,
    required this.event_date,
    required this.nepali_date,
    required this.description,
    required this.is_public_holiday,
  });

  factory Holiday.fromJson(dynamic json) {
    return Holiday(
      id: json['id'],
      event: json['event'].toString() ?? "",
      event_date: json['event_date'].toString() ?? "",
      nepali_date: json['nepali_date'].toString() ?? "",
      description: json['description'].toString() ?? "",
      is_public_holiday: json['is_public_holiday'] ?? false,
    );
  }

  int id;
  String event;
  String event_date;
  String nepali_date;
  String description;
  bool is_public_holiday;
}
