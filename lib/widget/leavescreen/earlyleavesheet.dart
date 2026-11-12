import 'package:cnattendance/model/leave.dart';
import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:cnattendance/utils/navigationservice.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

class EarlyLeaveSheet extends StatefulWidget {
  bool isEarlyLeave;

  EarlyLeaveSheet(this.isEarlyLeave);

  @override
  State<StatefulWidget> createState() => EarlyLeaveSheetState();
}

class EarlyLeaveSheetState extends State<EarlyLeaveSheet> {
  Leave? selectedValue;

  TextEditingController reason = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController issueDate = TextEditingController();

  bool isLoading = false;

  DateTime startDate = DateTime.now();

  void issueLeave() async {
    if (reason.text.isEmpty) {
      NavigationService()
          .showSnackBar("Leave Status", "Reason Time must not be empty");
      return;
    }

    if (startTime.text.isEmpty) {
      NavigationService()
          .showSnackBar("Leave Status", "Start Time must not be empty");
      return;
    }

    if (issueDate.text.isEmpty) {
      NavigationService()
          .showSnackBar("Leave Status", "Date must not be empty");
      return;
    }

    showLoader();
    try {
      isLoading = true;
      final response = await Provider.of<LeaveProvider>(context, listen: false)
          .issueTimeLeave(
        issueDate.text,
        startTime.text,
        endTime.text,
        reason.text,
      );

      if (!mounted) {
        return;
      }
      isLoading = false;
      dismissLoader();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: CustomAlertDialog(response.message),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: CustomAlertDialog(e.toString()),
          );
        },
      );
      isLoading = false;
      dismissLoader();
    }
  }

  void dismissLoader() {
    setState(() {
      EasyLoading.dismiss(animation: true);
    });
  }

  void showLoader() {
    setState(() {
      EasyLoading.show(
          status: "Requesting...", maskType: EasyLoadingMaskType.black);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Container(
        decoration: RadialDecoration(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate('leave_screen.time_leave'),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.white,
                      )),
                ],
              ),
              Column(
                children: [
                  gaps(10),
                  TextField(
                    controller: issueDate,
                    style: TextStyle(color: Colors.white),
                    //editing controller of this TextField
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: translate('leave_screen.select_date'),
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon:
                          Icon(Icons.calendar_month, color: Colors.white),
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
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      final pickedDate = await provider.isAd()
                          ? await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100))
                          : await picker.showNepaliDatePicker(
                              context: context,
                              initialDate: NepaliDateTime.now(),
                              firstDate: NepaliDateTime(2000),
                              lastDate: NepaliDateTime(2090),
                              initialDatePickerMode: DatePickerMode.day,
                            );

                      if (pickedDate != null) {
                        if (!(await provider.isAd())) {
                          String formattedDate = NepaliDateFormat('yyyy-MM-dd')
                              .format((pickedDate as NepaliDateTime));
                          startDate = (pickedDate).toDateTime();
                          issueDate.text = formattedDate;
                        } else {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            issueDate.text =
                                formattedDate; //set output date to TextField value.
                          });
                        }
                      } else {}
                    },
                  ),
                  gaps(10),
                  TextField(
                    controller: startTime,
                    style: TextStyle(color: Colors.white),
                    //editing controller of this TextField
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: translate('leave_screen.select_start_time'),
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon:
                          Icon(Icons.calendar_month, color: Colors.white),
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
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      var current = DateTime.now();
                      current = DateTime.utc(current.year, current.month,
                          current.day, timeOfDay!.hour, timeOfDay.minute);
                      startTime.text = DateFormat('HH:mm:ss').format(current);
                    },
                  ),
                ],
              ),
              gaps(10),
              TextField(
                controller: endTime,
                style: TextStyle(color: Colors.white),
                //editing controller of this TextField
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: translate('leave_screen.select_end_time'),
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.calendar_month, color: Colors.white),
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
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  final TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.dial,
                  );
                  var current = DateTime.now();
                  current = DateTime.utc(current.year, current.month,
                      current.day, timeOfDay!.hour, timeOfDay.minute);
                  endTime.text = DateFormat('HH:mm:ss').format(current);
                },
              ),
              gaps(10),
              TextField(
                textAlignVertical: TextAlignVertical.top,
                controller: reason,
                maxLines: 3,
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
                  hintText: translate('leave_screen.reason'),
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.edit_note, color: Colors.white),
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
              gaps(20),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5),
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: HexColor("#036eb7"),
                      padding: EdgeInsets.zero,
                      shape: ButtonBorder(),
                    ),
                    onPressed: () {
                      issueLeave();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        translate('leave_screen.request_leave'),
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget gaps(double value) {
    return SizedBox(
      height: value,
    );
  }
}
