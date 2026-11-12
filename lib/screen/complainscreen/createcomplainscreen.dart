import 'package:cnattendance/data/source/network/model/complaintresponse/departmentresponse.dart';
import 'package:cnattendance/screen/complainscreen/complaincontroller.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CreateComplainScreen extends StatelessWidget {
  final subject = TextEditingController();
  final message = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ComplainController model = Get.find();
    model.getDepartments();

    Future<void> onComplainSubmitted() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      if (model.selectedEmployees.isEmpty) {
        showToast("Please select an employee");
        return;
      }

      try {
        EasyLoading.show(
            status: translate('loader.loading'),
            maskType: EasyLoadingMaskType.black);
        var (status, body) =
            await model.applyComplaint(subject.text, message.text);
        EasyLoading.dismiss(animation: true);
        if (status) {
          model.clearAll();
          Get.back();
        }
        showToast(body);
      } catch (e) {
        EasyLoading.dismiss(animation: true);
        showToast(e.toString());
      }
    }

    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Create Complaint"),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10)))),
                  onPressed: () {
                    onComplainSubmitted();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(translate('create_salary_screen.submit')),
                  )),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Department",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: Obx(
                          () => DropdownButton2(
                            isExpanded: true,
                            hint: Text(
                              translate(
                                  'support_screen.select_department_type'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items:
                                model.departments.value.map((DepartmentApi e) {
                              return DropdownMenuItem(
                                value: e.name,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    e.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }).toList(),
                            value: null,
                            onChanged: (value) {
                              final result = model.departments
                                  .where((dep) => dep.name == value)
                                  .toList();

                              if (result.isNotEmpty) {
                                model.addDepatment(result[0]);
                              }
                            },
                            iconStyleData: IconStyleData(
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                            ),
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 160,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(10)),
                                color: HexColor("#FFFFFF"),
                              ),
                              elevation: 0,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              padding: null,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: HexColor("#FFFFFF"),
                              ),
                              elevation: 8,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: 40,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => model.selectedDepartments.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Selected Department",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    Obx(
                      () => Wrap(
                        spacing: 10,
                        children: model.selectedDepartments.map(
                          (element) {
                            return Card(
                              shape: ButtonBorder(),
                              margin: EdgeInsets.only(bottom: 10),
                              elevation: 0,
                              color: Colors.white24,
                              child: GestureDetector(
                                onTap: () {
                                  model.removeDepartment(element);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        element.name,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Employee",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: Obx(
                          () => DropdownButton2(
                            isExpanded: true,
                            hint: Text(
                              "Select Employee",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: model.getEmployees().map((Employee e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    e.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }).toList(),
                            value: null,
                            onChanged: (value) {
                              if (value != null) model.addEmployee(value);
                            },
                            iconStyleData: IconStyleData(
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                            ),
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 160,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(0),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(10)),
                                color: HexColor("#FFFFFF"),
                              ),
                              elevation: 0,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              padding: null,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: HexColor("#FFFFFF"),
                              ),
                              elevation: 8,
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: 40,
                              padding:
                                  const EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => model.selectedEmployees.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Selected Employee",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    Obx(
                      () => Wrap(
                        spacing: 10,
                        children: model.selectedEmployees.map(
                          (element) {
                            return Card(
                              shape: ButtonBorder(),
                              margin: EdgeInsets.only(bottom: 10),
                              elevation: 0,
                              color: Colors.white24,
                              child: GestureDetector(
                                onTap: () {
                                  model.removeEmployee(element);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        element.name,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Subject",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    TextFormField(
                      controller: subject,
                      textAlignVertical: TextAlignVertical.top,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Subject can't be empty";
                        }

                        return null;
                      },
                      maxLines: 1,
                      onTapOutside: (event) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      //editing controller of this TextField
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Subject',
                        hintStyle: TextStyle(color: Colors.white70),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Message",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    TextFormField(
                      controller: message,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: 5,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Message can't be empty";
                        }

                        return null;
                      },
                      onTapOutside: (event) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      //editing controller of this TextField
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.white70),
                        labelStyle: TextStyle(color: Colors.white),
                        fillColor: Colors.white24,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
