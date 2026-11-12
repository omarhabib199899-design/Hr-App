import 'dart:convert';
import 'dart:io';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/utils/locationstatus.dart';
import 'package:cnattendance/widget/attendance_bottom_sheet.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:cnattendance/widget/customnfcdialog.dart';
import 'package:cnattendance/widget/profile/note_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:one_clock/one_clock.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

// import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:ripple_wave/ripple_wave.dart';

import '../buttonborder.dart';
import '../customqrscanner.dart';

class CheckAttendance extends StatefulWidget {
  String formattedDate =
      DateFormat('EEEE , MMMM d , yyyy').format(DateTime.now());

  String nepaliFormattedDate =
      NepaliDateFormat('EEE , MMMM d , yyyy').format(NepaliDateTime.now());

  @override
  State<StatefulWidget> createState() => CheckAttendanceState();
}

class CheckAttendanceState extends State<CheckAttendance> {

  void showNFCScanner() {
    if (Platform.isAndroid) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: CustomNfcDialog(NFCMODE.scan),
          );
        },
      );
    }

    if (Platform.isIOS) {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          onAttendanceVerify(
              "nfc", base64.encode(utf8.encode(findKey(tag.data))));
          NfcManager.instance.stopSession();
        },
      );
    }
  }

  Future<void> scanQr() async {
    final result = await showCustomQrScanner(context);
    if (result != null && result.trim().isNotEmpty) {
      final provider = context.read<DashboardProvider>();
      if (provider.isNoteEnabled) {
        showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (context) {
              return NoteBottomSheet(result ?? "", "qr");
            });
      } else {
        onAttendanceVerify("qr", result ?? "");
      }
    }
  }

  bool isWithinRadius(double lat1, double lon1, double lat2, double lon2,
      double radiusInMeters) {
    double distance = Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return distance <= radiusInMeters;
  }

  void onAttendanceVerify(String type, String identifier) async {
    final provider = context.read<DashboardProvider>();
    ;
    try {
      setState(() {
        EasyLoading.show(
            status: translate('loader.requesting'),
            maskType: EasyLoadingMaskType.black);
      });
      final response =
          await provider.verifyAttendanceApi(type, "", identifier: identifier);
      setState(() {
        EasyLoading.dismiss(animation: true);
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
    final attendanceList =
        Provider.of<DashboardProvider>(context).attendanceList;
    final attandanceType = context.watch<PrefProvider>().attendanceType;
    final isAD = context.watch<DashboardProvider>().isAD;
    final attendanceMethod = context.watch<DashboardProvider>().attendanceMethods;
    final animated = context.watch<DashboardProvider>().animated;
    context.read<PrefProvider>().getAttendanceType(attendanceMethod);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: double.infinity,
              child: Center(
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 0,
                      child: DigitalClock(
                          showSeconds: true,
                          isLive: false,
                          textScaleFactor: .9,
                          format: "a",
                          padding: EdgeInsets.symmetric(vertical: 10),
                          digitalClockTextColor: Colors.white,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          datetime: DateTime.now()),
                    ),
                    DigitalClock(
                        showSeconds: true,
                        isLive: false,
                        textScaleFactor: 2.2,
                        format: "HH:mm",
                        padding: EdgeInsets.symmetric(vertical: 10),
                        digitalClockTextColor: Colors.white,
                        decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        datetime: DateTime.now()),
                    Positioned(
                      top: 15,
                      right: 0,
                      child: DigitalClock(
                          showSeconds: true,
                          isLive: false,
                          textScaleFactor: .9,
                          format: "ss",
                          padding: EdgeInsets.zero,
                          digitalClockTextColor: Colors.white,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          datetime: DateTime.now()),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
              child: Text(
            isAD ? widget.formattedDate : widget.nepaliFormattedDate,
            style: TextStyle(color: Colors.white),
          )),
          if (animated && attendanceMethod.isNotEmpty)
            Center(
              child: Container(
                width: 280,
                child: RippleWave(
                  color: attendanceList['check-in'] != "-" &&
                          attendanceList['check-out'] == "-"
                      ? HexColor("#762150")
                      : HexColor("#225788"),
                  repeat: animated,
                  waveCount: 5,
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(90)),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          color: attendanceList['check-in'] != "-" &&
                                  attendanceList['check-out'] == "-"
                              ? HexColor("#762150")
                              : HexColor("#225788"),
                          child: IconButton(
                              iconSize: 70,
                              onPressed: () async {
                                /*Preferences preferences = Preferences();
                            final position = await LocationStatus()
                                .determinePosition(await preferences.getWorkSpace());
                            final value = isWithinRadius(position.latitude, position.longitude, 27.6810411, 85.3340921, 1000);

                            if(value){
                              print("inside");
                            }else{
                              print("outisde");
                            }*/
                                if (attandanceType == "QR") {
                                  scanQr();
                                } else if (attandanceType == "NFC") {
                                  bool isAvailable =
                                      await NfcManager.instance.isAvailable();
                                  if (!isAvailable) {
                                    showToast(
                                        "NFC is not present. Please enable NFC or try different method");
                                    return;
                                  }
                                  showNFCScanner();
                                } else {
                                  showModalBottomSheet(
                                      context: context,
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return AttedanceBottomSheet();
                                      });
                                }
                              },
                              icon: Lottie.asset(
                                  attandanceType == "QR"
                                      ? 'assets/raw/qr.json'
                                      : attandanceType == "NFC"
                                          ? 'assets/raw/nfc.json'
                                          : 'assets/raw/fingerprint.json',
                                  width: 60,
                                  height: 60,
                                  repeat: animated)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!animated && attendanceMethod.isNotEmpty)
            Center(
              child: SizedBox(
                height: 180,
                width: 180,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(90)),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: attendanceList['check-in'] != "-" &&
                              attendanceList['check-out'] == "-"
                          ? HexColor("#762150")
                          : HexColor("#225788"),
                      child: IconButton(
                          iconSize: 70,
                          onPressed: () async {
                            /*Preferences preferences = Preferences();
                        final position = await LocationStatus()
                            .determinePosition(await preferences.getWorkSpace());
                        final value = isWithinRadius(position.latitude, position.longitude, 27.6810411, 85.3340921, 1000);

                        if(value){
                          print("inside");
                        }else{
                          print("outisde");
                        }*/
                            if (attandanceType == "QR") {
                              scanQr();
                            } else if (attandanceType == "NFC") {
                              bool isAvailable =
                                  await NfcManager.instance.isAvailable();
                              if (!isAvailable) {
                                showToast(
                                    "NFC is not present. Please enable NFC or try different method");
                                return;
                              }
                              showNFCScanner();
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return AttedanceBottomSheet();
                                  });
                            }
                          },
                          icon: Lottie.asset(
                              attandanceType == "QR"
                                  ? 'assets/raw/qr.json'
                                  : attandanceType == "NFC"
                                      ? 'assets/raw/nfc.json'
                                      : 'assets/raw/fingerprint.json',
                              width: 60,
                              height: 60,
                              repeat: animated)),
                    ),
                  ),
                ),
              ),
            ),
          if (attendanceMethod.isNotEmpty)
          Center(
              child: Text(
            "${translate('home_screen.check_in')} | ${translate('home_screen.check_out')}",
            style: TextStyle(color: Colors.white, fontSize: 15),
          )),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            child: LinearPercentIndicator(
              animation: true,
              animationDuration: 1000,
              lineHeight: 30.0,
              padding: EdgeInsets.all(0),
              percent: attendanceList['production-time']!,
              center: Text(
                attendanceList['production_hour'],
                style: TextStyle(color: Colors.white),
              ),
              barRadius: const Radius.circular(20),
              backgroundColor: HexColor("#3dFFFFFF"),
              progressColor: attendanceList['check-in'] != "-" &&
                      attendanceList['check-out'] == "-"
                  ? HexColor("#e82e5f")
                  : HexColor("#3b98cc"),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    attendanceList['check-in']!,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    attendanceList['check-out']!,
                    style: TextStyle(color: Colors.white),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  Future<void> checkAd() async {
    final pref = Provider.of<PrefProvider>(context);
    if (await pref.getIsAd()) {
      widget.formattedDate =
          DateFormat('EEEE , MMMM d , yyyy').format(DateTime.now());
    } else {
      widget.formattedDate = NepaliDateFormat('EEE , MMMM d , yyyy')
          .format(DateTime.now().toNepaliDateTime());
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    checkAd();
  }
}
