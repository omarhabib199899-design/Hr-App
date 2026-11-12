import 'package:cnattendance/model/leave.dart';
import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:cnattendance/utils/navigationservice.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';

class IssueLeaveSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IssueLeaveSheetState();
}

class IssueLeaveSheetState extends State<IssueLeaveSheet> {
  Leave? selectedValue;

  bool isLoading = false;

  TextEditingController endDate = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController startDate = TextEditingController();

  DateTime startNepaliDate = DateTime.now();
  DateTime endNepaliDate = DateTime.now();

  void issueLeave() async {
    if (endDate.text.isNotEmpty &&
        startDate.text.isNotEmpty &&
        reason.text.isNotEmpty &&
        selectedValue != null) {
      try {
        final isAd =
            await Provider.of<LeaveProvider>(context, listen: false).isAd();
        showLoader();
        isLoading = true;
        final response =
            await Provider.of<LeaveProvider>(context, listen: false).issueLeave(
                isAd
                    ? startDate.text
                    : DateFormat('yyyy-MM-dd hh:mm:ss').format(startNepaliDate),
                isAd
                    ? startDate.text
                    : DateFormat('yyyy-MM-dd hh:mm:ss').format(startNepaliDate),
                isAd
                    ? endDate.text
                    : DateFormat('yyyy-MM-dd hh:mm:ss').format(endNepaliDate),
                reason.text,
                selectedValue!.id,
                0);

        if (!mounted) {
          return;
        }
        dismissLoader();
        Navigator.pop(context);
        isLoading = false;
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(response.message),
            );
          },
        );
      } catch (e) {
        dismissLoader();
        isLoading = false;
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(e.toString()),
            );
          },
        );
      }
    } else {
      NavigationService()
          .showSnackBar("Leave Status", "Field must not be empty");
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
                  const Text(
                    'Apply Leave',
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
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Select Leave Type',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: provider.leaveList
                          .where((element) => element.status)
                          .map((item) => DropdownMenuItem<Leave>(
                                value: item,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        selectedValue = value as Leave?;
                        if (selectedValue != null) {
                          setState(() {});
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
                        padding: const EdgeInsets.only(left: 14, right: 14),
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
                        padding: const EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  )),
              gaps(10),
              TextField(
                controller: startDate,
                style: TextStyle(color: Colors.white),
                //editing controller of this TextField
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Select Start Date',
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
                      String formattedDate =
                          NepaliDateFormat('yyyy-MM-dd hh:mm:ss')
                              .format((pickedDate as NepaliDateTime));
                      startNepaliDate = (pickedDate).toDateTime();
                      startDate.text = formattedDate;
                    } else {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd hh:mm:ss').format(pickedDate);
                      setState(() {
                        startDate.text =
                            formattedDate; //set output date to TextField value.
                      });
                    }

                    if (endDate.text.isNotEmpty && startDate.text.isNotEmpty) {
                      setState(() {});
                    }
                  } else {}
                },
              ),
              gaps(10),
              TextField(
                controller: endDate,
                style: TextStyle(color: Colors.white),
                //editing controller of this TextField
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Select End Date',
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
                  final pickedDate = await provider.isAd()
                      ? await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateFormat("yyyy-MM-dd hh:mm:ss")
                                  .tryParse(startDate.text) ??
                              DateTime(1950),
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
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                    if (!(await provider.isAd())) {
                      String formattedDate =
                          NepaliDateFormat('yyyy-MM-dd hh:mm:ss')
                              .format((pickedDate as NepaliDateTime));
                      endNepaliDate = (pickedDate).toDateTime();
                      endDate.text = formattedDate;
                    } else {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd hh:mm:ss').format(pickedDate);
                      setState(() {
                        endDate.text =
                            formattedDate; //set output date to TextField value.
                      });
                    }

                    if (endDate.text.isNotEmpty && startDate.text.isNotEmpty) {
                      setState(() {});
                    }
                  } else {}
                },
              ),
              if (endDate.text.isNotEmpty && startDate.text.isNotEmpty)
                gaps(10),
              if (endDate.text.isNotEmpty && startDate.text.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Leave Days: ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        (DateFormat("yyyy-MM-dd hh:mm:ss")
                                    .parse(endDate.text)
                                    .difference(
                                        DateFormat("yyyy-MM-dd hh:mm:ss")
                                            .parse(startDate.text))
                                    .inDays +
                                1)
                            .toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
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
                  hintText: 'Reason',
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
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Request Leave',
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
