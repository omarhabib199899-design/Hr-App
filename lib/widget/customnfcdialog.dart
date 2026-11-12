import 'dart:convert';

import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/provider/morescreenprovider.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:cnattendance/widget/profile/note_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';

enum NFCMODE { scan, add }

class CustomNfcDialog extends StatefulWidget {
  final NFCMODE mode;

  CustomNfcDialog(this.mode);

  @override
  State<StatefulWidget> createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomNfcDialog> {
  @override
  void initState() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        NfcManager.instance.stopSession();
        if (widget.mode == NFCMODE.add) {
          onAddNfc(base64.encode(utf8.encode(findKey(tag.data))));
        }

        if (widget.mode == NFCMODE.scan) {
          final provider = context.read<DashboardProvider>();
          if(provider.isNoteEnabled){

            Get.back();
            showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                builder: (context) {
                  return NoteBottomSheet(base64.encode(utf8.encode(findKey(tag.data))), "nfc");
                });
          }else{
            onAttendanceVerify(
                "nfc", base64.encode(utf8.encode(findKey(tag.data))));
          }
        }
      },
    );
    super.initState();
  }

  void onAttendanceVerify(String type, String identifier) async {
    final provider = context.read<DashboardProvider>();
    try {
      setState(() {
        EasyLoading.show(
            status: translate('loader.requesting'), maskType: EasyLoadingMaskType.black);
      });
      final response =
          await provider.verifyAttendanceApi(type,"", identifier: identifier);
      if (!mounted) {
        return;
      }
      setState(() {
        EasyLoading.dismiss(animation: true);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(response.message),
            );
          },
        );
      });
    } catch (e) {
      setState(() {
        EasyLoading.dismiss(animation: true);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(e.toString()),
            );
          },
        );
      });
    }
  }

  void onAddNfc(String identifier) async {
    final provider = context.read<DashboardProvider>();
    try {
      setState(() {
        EasyLoading.show(
            status: translate('loader.requesting'), maskType: EasyLoadingMaskType.black);
      });
      final response =
          await context.read<MoreScreenProvider>().addNfcApi("nfc", identifier);
      if (!mounted) {
        return;
      }
      setState(() {
        EasyLoading.dismiss(animation: true);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog("Nfc Added Successfully"),
            );
          },
        );
      });
    } catch (e) {
      setState(() {
        EasyLoading.dismiss(animation: true);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(e.toString()),
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset("assets/raw/scanner.json",
                width: 150, height: 150),
          ),
          Text(
            textAlign: TextAlign.center,
            translate('common.scan_nfc'),
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                style: TextButton.styleFrom(
                    backgroundColor: HexColor("#036eb7"),
                    shape: ButtonBorder()),
                onPressed: () {
                  Navigator.pop(context);
                  NfcManager.instance.stopSession();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(translate('common.close'), style: TextStyle(color: Colors.white)),
                )),
          )
        ],
      ),
    );
  }
}
