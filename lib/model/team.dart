import 'package:flutter/material.dart';

class Team with ChangeNotifier {
  int id;
  String username;
  String name;
  String post;
  String avatar;
  String phone;
  String email;
  String active;
  String department;
  String branch;

  Team(
      {required this.id,
      required this.username,
      required this.name,
      required this.post,
      required this.avatar,
      required this.phone,
      required this.email,
      required this.active,
      required this.department,
      required this.branch,
      });
}
