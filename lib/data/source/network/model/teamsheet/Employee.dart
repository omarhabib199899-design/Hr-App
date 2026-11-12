class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.branch,
    required this.department,
    required this.post,
    required this.avatar,
    required this.onlineStatus,
  });

  factory Employee.fromJson(dynamic json) {
    return Employee(
        id: json['id'],
        name: json['name'].toString() ?? "",
        email: json['email'].toString() ?? "",
        username: json['username'].toString() ?? "",
        phone: json['phone'].toString() ?? "",
        dob: json['dob'].toString() ?? "",
        gender: json['gender'].toString() ?? "",
        branch: json['branch'].toString() ?? "",
        department: json['department'].toString() ?? "",
        post: json['post'].toString() ?? "",
        avatar: json['avatar'].toString() ?? "",
        onlineStatus: json['online_status'].toString() ?? "0");
  }

  int id;
  String name;
  String email;
  String phone;
  String username;
  String dob;
  String gender;
  String branch;
  String department;
  String post;
  String avatar;
  String onlineStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['dob'] = dob;
    map['gender'] = gender;
    map['department'] = department;
    map['post'] = post;
    map['avatar'] = avatar;
    map['online_status'] = onlineStatus;
    return map;
  }
}
