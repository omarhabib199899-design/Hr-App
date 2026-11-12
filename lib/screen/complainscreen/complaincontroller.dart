import 'package:cnattendance/data/source/network/model/complaintresponse/complaintresponse.dart';
import 'package:cnattendance/data/source/network/model/complaintresponse/departmentresponse.dart';
import 'package:cnattendance/repositories/complaintrepository.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:get/get.dart';

class ComplainController extends GetxController {
  var complaintList = <Complaint>[].obs;
  var departments = <DepartmentApi>[].obs;

  var selectedEmployees = <Employee>[].obs;
  var selectedDepartments = <DepartmentApi>[].obs;

  int page = 1;
  final repository = ComplaintRepository();

  @override
  void onReady() {
    page = 1;
    getCompaints();
    getDepartments();
    clearAll();
    super.onReady();
  }

  Future<void> getCompaints() async {
    try {
      final response = await repository.getComplaints(page);

      if (page == 1) {
        complaintList.value = response.data;
      } else {
        complaintList.addAll(response.data);
      }

      if (complaintList.isNotEmpty) {
        page++;
      }
    } catch (e) {
      print(e.toString());
      showToast(e.toString());
    }
  }

  Future<void> getDepartments() async {
    try {
      final response = await repository.getDepartments();

      departments.value = response.data;
    } catch (e) {
      print(e.toString());
      showToast(e.toString());
    }
  }

  Future<(bool, String)> saveResponseComplaint(
      String userResponse, int id) async {
    try {
      var (status, message) =
          await repository.writeComplaintResponse(userResponse, id.toString());
      return (status, message);
    } catch (e) {
      return (false, e.toString());
    }
  }

  Future<(bool, String)> applyComplaint(String subject, String body) async {
    try {
      List<int> employeeIds =
          selectedEmployees.map((employee) => employee.id).toList();
      List<int> departmentIds = [];

      for (var department in departments) {
        for (var emp in employeeIds) {
          if (department.employee.any(
            (element) => element.id == emp,
          )) {
            departmentIds.add(int.parse(department.id));
          }
        }
      }

      departmentIds = departmentIds.toSet().toList();

      var (status, message) = await repository.applyComplaint(
          departmentIds, employeeIds, subject, body);
      return (status, message);
    } catch (e) {
      return (false, e.toString());
    }
  }

  void addEmployee(Employee employee) {
    if (!selectedEmployees.any(
      (element) => element.id == employee.id,
    )) {
      selectedEmployees.add(employee);
    }
  }

  void addDepatment(DepartmentApi department) {
    if (!selectedDepartments.any(
      (element) => element.id == department.id,
    )) {
      selectedDepartments.add(department);
    }
  }

  void removeEmployee(Employee employee) {
    selectedEmployees.removeWhere(
      (element) => element.id == employee.id,
    );
  }

  void removeDepartment(DepartmentApi department) {
    // Remove department by matching the id
    selectedDepartments.removeWhere(
          (element) => element.id == department.id,
    );

    // Create a copy of selectedEmployees to avoid concurrent modification
    var employeesToRemove = <Employee>[];

    for (var empl in selectedEmployees) {
      if (department.employee.any((element) => element.id == empl.id)) {
        employeesToRemove.add(empl);
      }
    }

    // Remove employees found in the department
    selectedEmployees.removeWhere((element) => employeesToRemove.contains(element));
  }

  void clearAll() {
    selectedEmployees.clear();
    selectedDepartments.clear();
  }

  List<Employee> getEmployees(){
    final List<Employee> employees = [];

    for(var dep in selectedDepartments){
      employees.addAll(dep.employee);
    }

    return employees;
  }
}
