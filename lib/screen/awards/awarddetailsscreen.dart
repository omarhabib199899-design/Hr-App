import 'package:cnattendance/model/award.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class AwardDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final award = Get.arguments["award"] as Award;
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(translate('award_detail_screen.award_detail')),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipOval(
                    child: Image.network(
                      award.image,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    award.employee_name,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    award.award_name,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${translate('award_detail_screen.awarded_by')}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            "${award.awarded_by}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: VerticalDivider(
                        width: 1,
                        color: Colors.white54,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Awarded Date",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            "${award.awarded_date}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: award.award_description.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('award_detail_screen.award_detail'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Card(
                        shape: ButtonBorder(),
                        elevation: 0,
                        color: Colors.white12,
                        margin: EdgeInsets.zero,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              parse(award.award_description).body!.text),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: award.gift_description.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('award_detail_screen.gift_detail'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Card(
                        shape: ButtonBorder(),
                        elevation: 0,
                        color: Colors.white12,
                        margin: EdgeInsets.zero,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            parse(award.gift_description).body!.text,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      if (award.awardImage.isNotEmpty)
                        Image.network(award.awardImage)
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
