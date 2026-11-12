import 'package:cnattendance/data/source/network/model/asssetlistresponse/assetlistresponse.dart';
import 'package:cnattendance/screen/assetscreen/assetscontroller.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AssetBottomSheet extends StatefulWidget {
  final AssetData asset;

  AssetBottomSheet(this.asset);

  @override
  State<StatefulWidget> createState() => AssetBottomSheetState();
}

class AssetBottomSheetState extends State<AssetBottomSheet> {
  final reason = TextEditingController();
  bool isWorking = true;

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
    final AssetController model = Get.find();
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                widget.asset.asset,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (widget.asset.notes == null)
              SizedBox(
                height: 10,
              ),
            if (widget.asset.notes == null)
              Row(
                spacing: 10,
                children: [
                  Text(
                    "Is Working",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Spacer(),
                  Switch(
                    activeColor: Colors.blue,
                    value: isWorking,
                    onChanged: (value) {
                      setState(() {
                        isWorking = !isWorking;
                      });
                    },
                  )
                ],
              ),
            if (widget.asset.notes == null)
              SizedBox(
                height: 5,
              ),
            if (widget.asset.notes == null)
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
            if (widget.asset.notes == null)
              SizedBox(
                height: 10,
              ),
            if (widget.asset.notes != null)
              Card(
                elevation: 0,
                color: Colors.white24,
                shape: ButtonBorder(),
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      widget.asset.notes ?? "",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (widget.asset.notes == null)
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: widget.asset.notes != null
                          ? HexColor("#036eb7").withValues(alpha: .5)
                          : HexColor("#036eb7"),
                      padding: EdgeInsets.zero,
                      shape: ButtonBorder(),
                    ),
                    onPressed: widget.asset.notes != null
                        ? null
                        : () {
                            sendResponse(model,isWorking);
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        widget.asset.notes == null
                            ? 'Response'
                            : "Already Responsed",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> sendResponse(AssetController model,bool isWorking) async {
    if (reason.text.isEmpty) {
      showToast("Response can't be empty");
      return;
    }
    try {
      showLoader();
      var (status, message) =
          await model.sendResponse(widget.asset.id, reason.text,isWorking);
      dismissLoader();
      model.getAssets();
      showToast(message);
      Get.back();
    } catch (e) {
      dismissLoader();
    }
  }
}
