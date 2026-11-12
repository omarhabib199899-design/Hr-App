class Holidays {
  Holidays({
    required this.id,
    required this.event,
    required this.eventDate,
    required this.description,
    required this.isPublicHoliday,
  });

  factory Holidays.fromJson(dynamic json) {
    return Holidays(
      id: json['id'],
      event: json['event'].toString() ?? "",
      eventDate: json['event_date'].toString() ?? "",
      description: json['description'].toString() ?? "",
      isPublicHoliday: json['is_public_holiday'] ?? false,
    );
  }

  int id;
  String event;
  String eventDate;
  String description;
  bool isPublicHoliday;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['event'] = event;
    map['event_date'] = eventDate;
    map['description'] = description;
    return map;
  }
}
