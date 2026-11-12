class Birthday {
  Birthday({
    required this.id,
    required this.name,
    required this.dob,
    required this.role,
    required this.avatar,
  });

  factory Birthday.fromJson(dynamic json) {
    return Birthday(
      id: json['id'],
      name: json['name'].toString() ?? "",
      dob: json['dob'].toString() ?? "",
      role: json['post'].toString() ?? "",
      avatar: json['avatar'].toString() ?? "",
    );
  }

  int id;
  String name;
  String dob;
  String role;
  String avatar;
}
