import 'package:cnattendance/provider/advancedetailcontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class AdvanceDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(AdvanceDetailController());
    return Container(
      decoration: RadialDecoration(),
      child: Obx(
        () => SafeArea(
          child: model.isLoading.value
              ? SizedBox.shrink()
              : Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    title:
                        Text(translate('advance_detail_screen.advance_detail')),
                  ),
                  bottomNavigationBar: Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      child: Row(
                        children: [
                          Card(
                            elevation: 0,
                            color: model.advanceSalary.value.status
                                        .toLowerCase() ==
                                    "pending"
                                ? Colors.orange.shade500
                                : model.advanceSalary.value.status
                                            .toLowerCase() ==
                                        "rejected"
                                    ? Colors.red.shade500
                                    : Colors.green.shade500,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  model.advanceSalary.value.status
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${translate('advance_detail_screen.total')} ",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                          Text(
                              "${translate('advance_detail_screen.rs')} " +
                                  model.advanceSalary.value.released_amount,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                  body: Obx(
                    () => SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Requested Date",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      Text(
                                        model.advanceSalary.value.requested_date,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: Colors.white54,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Released Date",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      Text(
                                        model.advanceSalary.value.released_date,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 0,
                              shape: ButtonBorder(),
                              color: Colors.white24,
                              margin: EdgeInsets.zero,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate(
                                          'advance_detail_screen.requested_amount'),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                    Text(
                                      model.advanceSalary.value.requested_amount,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      translate(
                                          'advance_detail_screen.released_amount'),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                    Text(
                                      model.advanceSalary.value.released_amount,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate(
                                            'advance_detail_screen.is_settled'),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      Text(
                                        !model.advanceSalary.value.is_settled
                                            ? translate(
                                                'advance_detail_screen.no')
                                            : translate(
                                                'advance_detail_screen.yes'),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: Colors.white54,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        translate(
                                            'advance_detail_screen.verified_by'),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                      Text(
                                        parse(model.advanceSalary.value
                                                    .verifiedBy ??
                                                "N/A")
                                            .body!
                                            .text,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 0,
                              shape: ButtonBorder(),
                              color: Colors.white24,
                              margin: EdgeInsets.zero,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate('advance_detail_screen.reason'),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                    Text(
                                      parse(model.advanceSalary.value
                                                  .description ??
                                              "")
                                          .body!
                                          .text,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Card(
                              elevation: 0,
                              shape: ButtonBorder(),
                              color: Colors.white24,
                              margin: EdgeInsets.zero,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate('advance_detail_screen.remarks'),
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                    Text(
                                      parse(model.advanceSalary.value.remark ??
                                              "N/A")
                                          .body!
                                          .text,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
