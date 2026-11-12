class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.avatar,
    required this.onlineStatus,
    required this.department,
    required this.branch,
    required this.dob,
    required this.gender,
    required this.workspace_type,
  });

  factory User.fromJson(dynamic json) {
    return User(
        id: json['id'],
        name: json['name'].toString() ?? "",
        email: json['email'].toString() ?? "",
        username: json['username'].toString() ?? "",
        avatar: json['avatar'].toString() ?? "",
        onlineStatus: json['online_status'] ?? false,
        department: json['department'] ?? "",
        branch: json['branch'] ?? "",
        dob: json['dob'] ?? "",
        gender: json['gender'] ?? "",
        workspace_type: json['workspace_type'].toString() ?? "");
  }

  int id;
  String name;
  String email;
  String username;
  String avatar;
  bool onlineStatus;
  String workspace_type;
  String department;
  String branch;
  String dob;
  String gender;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['username'] = username;
    map['avatar'] = avatar;
    map['online_status'] = onlineStatus;
    return map;
  }
}
