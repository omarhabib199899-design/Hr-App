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

class IssueResignationSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IssueResignationSheetState();
}

class IssueResignationSheetState extends State<IssueResignationSheet> {
  bool isLoading = false;

  bool canApply = true;
  String status = "";
  String adminRemark = "";

  TextEditingController reason = TextEditingController();
  TextEditingController startDate = TextEditingController();

  DateTime startNepaliDate = DateTime.now();
  DateTime endNepaliDate = DateTime.now();

  void issueResignation() async {
    if (startDate.text.isNotEmpty && reason.text.isNotEmpty) {
      try {
        final isAd =
            await Provider.of<LeaveProvider>(context, listen: false).isAd();

        final date = isAd
            ? startDate.text
            : DateFormat('yyyy-MM-dd').format(startNepaliDate);

        showLoader();
        isLoading = true;
        final response =
            await Provider.of<LeaveProvider>(context, listen: false)
                .issueResignation(date, reason.text.toString());

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
          .showSnackBar("Resignation Status", "Field must not be empty");
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final response =
            await Provider.of<LeaveProvider>(context, listen: false)
                .getResignation();

        if (response.data == null) {
          canApply = true;
          status = "";
          setState(() {});
        } else {
          if (response.data!.status == "rejected") {
            canApply = true;
          } else {
            canApply = false;
          }
          status = response.data!.status;
          adminRemark = response.data?.remark ?? "";
          setState(() {});
        }
      },
    );
    super.initState();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == "approved" || status == "onReview")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
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
              if (status != "approved" && status != "onReview")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Apply Resignation',
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
              if (status == "rejected" || status.isEmpty)
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
                        String formattedDate = NepaliDateFormat('yyyy-MM-dd')
                            .format((pickedDate as NepaliDateTime));
                        startNepaliDate = (pickedDate).toDateTime();
                        startDate.text = formattedDate;
                      } else {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          startDate.text =
                              formattedDate; //set output date to TextField value.
                        });
                      }
                    } else {}
                  },
                ),
              if (status == "rejected" || status.isEmpty) gaps(10),
              if (status == "rejected" || status.isEmpty)
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
              if (status.isNotEmpty && (!canApply || adminRemark.isNotEmpty))
                gaps(10),
              if (status.isNotEmpty && (!canApply || adminRemark.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "RESIGNATION REQUEST " + status.toUpperCase(),
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              if (adminRemark.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 5.0, right: 5, bottom: 10),
                  child: Text(
                    "Remark : " + adminRemark,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              gaps(10),
              if (status == "rejected" || status.isEmpty)
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 5),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: canApply
                            ? HexColor("#036eb7")
                            : HexColor("#036eb7").withOpacity(.2),
                        padding: EdgeInsets.zero,
                        shape: ButtonBorder(),
                      ),
                      onPressed: canApply
                          ? () {
                              issueResignation();
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Request Resignation',
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
