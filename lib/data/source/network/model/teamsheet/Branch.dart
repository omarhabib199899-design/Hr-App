import 'package:cnattendance/data/source/network/model/teamsheet/Department.dart';

class Branch {
  Branch({
    required this.id,
    required this.name,
    required this.department,
  });

  factory Branch.fromJson(dynamic json) {
    return Branch(
        id: json['id'],
        name: json['name'].toString(),
        department: List<Department>.from(
            json['departments'].map((x) => Department.fromJson(x))));
  }

  int id;
  String name;
  List<Department> department;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
