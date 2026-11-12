import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class GeneralScreen extends StatelessWidget {
  var outputDate = "".obs;

  Future<void> checkAd(DateTime tempDate) async {
    Preferences preferences = Preferences();
    final isAd = await preferences.getEnglishDate();
    if (!isAd) {
      outputDate.value =
          NepaliDateFormat("dd-MM-yyyy").format(tempDate.toNepaliDateTime());
    }
  }

  @override
  Widget build(BuildContext context) {
    final param = Get.arguments;

    if (param["date"] != "") {
      DateTime tempDate = DateFormat("yyyy-MM-dd").parse(param["date"]);
      var outputFormat = DateFormat('MM-dd-yyyy');
      outputDate.value = outputFormat.format(tempDate);

      checkAd(tempDate);
    }
    return Scaffold(
      body: Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(translate('general_screen.notification_detail'),
                style: TextStyle(color: Colors.white)),
            elevation: 0,
          ),
          body: SafeArea(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            param["title"],
                            style:
                                TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if(outputDate != "")
                      Card(
                        elevation: 0,
                        color: Colors.white24,
                        margin: EdgeInsets.zero,
                        shape: ButtonBorder(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                translate('general_screen.published_date'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Text(
                                outputDate.value,
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    Card(
                      elevation: 0,
                      color: Colors.white24,
                      margin: EdgeInsets.only(top: 10),
                      shape: ButtonBorder(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              param["message"],
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
