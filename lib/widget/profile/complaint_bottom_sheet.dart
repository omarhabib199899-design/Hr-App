import 'package:cnattendance/data/source/network/model/complaintresponse/complaintresponse.dart';
import 'package:cnattendance/screen/complainscreen/complaincontroller.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ComplaintBottomSheet extends StatefulWidget {
  final Complaint complaint;

  ComplaintBottomSheet(this.complaint);

  @override
  State<StatefulWidget> createState() => ComplaintBottomSheetState();
}

class ComplaintBottomSheetState extends State<ComplaintBottomSheet> {
  final reason = TextEditingController();

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
    final ComplainController model = Get.find();
    return Container(
      decoration: RadialDecoration(),
      padding: EdgeInsets.only(
          top: 20,
          right: 20,
          left: 20,
          bottom: (MediaQuery.of(context).viewInsets.bottom) + 10),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.complaint.subject,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.complaint.message,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
            if (widget.complaint.response.isEmpty)
              SizedBox(
                height: 10,
              ),
            if (widget.complaint.response.isEmpty)
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
                  hintText: 'Write a response..',
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
            if (widget.complaint.response.isEmpty)
              SizedBox(
                height: 10,
              ),
            if(widget.complaint.response.isEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: widget.complaint.response.isNotEmpty
                        ? HexColor("#036eb7").withValues(alpha: .5)
                        : HexColor("#036eb7"),
                    padding: EdgeInsets.zero,
                    shape: ButtonBorder(),
                  ),
                  onPressed: widget.complaint.response.isNotEmpty
                      ? null
                      : () {
                          sendResponse(model);
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      widget.complaint.response.isEmpty
                          ? 'Response'
                          : "Already Responsed",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ),
            if (widget.complaint.response.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: Colors.white24,
                shape: ButtonBorder(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.complaint.response,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendResponse(ComplainController model) async {
    if (reason.text.isEmpty) {
      showToast("Response can't be empty");
      return;
    }
    try {
      showLoader();
      var (status, message) =
          await model.saveResponseComplaint(reason.text, widget.complaint.id);
      dismissLoader();
      model.page = 1;
      model.getCompaints();
      showToast(message);
      Get.back();
    } catch (e) {
      dismissLoader();
    }
  }
}
