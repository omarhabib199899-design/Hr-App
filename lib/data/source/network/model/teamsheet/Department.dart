class Department {
  Department({
    required this.id,
    required this.name,
  });

  factory Department.fromJson(dynamic json) {
    return Department(
      id: json['id'],
      name: json['dept_name'].toString(),
    );
  }

  int id;
  String name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
