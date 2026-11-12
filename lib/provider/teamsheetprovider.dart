import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnattendance/data/source/network/model/teamsheet/Branch.dart';
import 'package:cnattendance/data/source/network/model/teamsheet/Department.dart';
import 'package:cnattendance/data/source/network/model/teamsheet/Employee.dart';
import 'package:cnattendance/model/team.dart';
import 'package:cnattendance/repositories/teamsheetrepository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamSheetProvider with ChangeNotifier {
  TeamSheetRepository repository = TeamSheetRepository();
  final List<Team> _teamList = [];

  final List<Team> mainTeamList = [];

  final List<Branch> _branches = [];
  final List<Department> _department = [];

  int selectedBranch = 0;
  int selectedDepartment = 0;

  List<Team> get teamList {
    return [..._teamList];
  }

  List<Branch> get branches {
    return [..._branches];
  }

  List<Department> get department {
    return [..._department];
  }

  void setDepartment(List<Department> department) {
    _department.clear();
    _department.add(Department(id: 0, name: "All"));
    _department.addAll(department);
  }

  void createTeam(List<Employee> employees) {
    for (var employee in employees) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(employee.username.toString())
          .set({
        'name': employee.name,
        'phone': employee.phone,
        'email': employee.email,
        'username': employee.username,
        'id': employee.id,
        'avatar': employee.avatar,
        'department': employee.department,
        'post': employee.post,
        'gender': employee.gender,
      });
    }
  }

  Future<void> getTeam() async {
    try {
      final response = await repository.getTeam();
      makeTeamSheet(response.data.companyDetail.employee);
      createTeam(response.data.companyDetail.employee);

      _branches.clear();
      _branches.addAll(response.data.branch);

      setDepartment(_branches.first.department);

      if (Get.arguments != null) {
        if (Get.arguments["department"] != "" &&
            Get.arguments["branch"] != "") {
          selectedDepartment = _department
              .where((element) => element.name == Get.arguments["department"])
              .first
              .id;
          selectedBranch = _branches
              .where((element) => element.name == Get.arguments["branch"])
              .first
              .id;
        }else{
          selectedDepartment = _department.first.id;
          selectedBranch = _branches.first.id;
        }
      } else {
        selectedDepartment = _department.first.id;
        selectedBranch = _branches.first.id;
      }
      makeTeamList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void makeTeamList() {
    _teamList.clear();
    if (selectedDepartment == 0) {
      _teamList.addAll(mainTeamList.where((element) =>
          element.branch.toLowerCase() ==
          _branches
              .where((element) => element.id == selectedBranch)
              .first
              .name
              .toLowerCase()));
    } else {
      _teamList.addAll(mainTeamList.where((element) =>
          element.department.toLowerCase() ==
          _department
              .where((element) => element.id == selectedDepartment)
              .first
              .name
              .toLowerCase()));
    }
    notifyListeners();
  }

  void makeTeamSheet(List<Employee> employee) {
    mainTeamList.clear();
    for (var value in employee) {
      mainTeamList.add(Team(
          id: value.id,
          username: value.username,
          name: value.name,
          post: value.post,
          avatar: value.avatar,
          phone: value.phone,
          email: value.email,
          active: value.onlineStatus,
          department: value.department,
          branch: value.branch));
    }
    notifyListeners();
  }
}
