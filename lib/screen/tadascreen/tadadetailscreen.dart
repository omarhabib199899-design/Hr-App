import 'package:cnattendance/provider/tadadetailcontroller.dart';
import 'package:cnattendance/screen/tadascreen/widget/attachmentbottomsheet.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:readmore/readmore.dart';

class TadaDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(TadaDetailController());
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
                    title: Text(translate('tada_detail_screen.tada_detail')),
                  ),
                  body: Obx(
                    () => Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.tada.value.title,
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Date",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(model.tada.value.submittedDate,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                child: VerticalDivider(
                                  width: 1,
                                  color: Colors.white54,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Status",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(model.tada.value.status,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                child: VerticalDivider(
                                  width: 1,
                                  color: Colors.white54,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text("Rs " + model.tada.value.expenses,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(height: 15),
                          Card(
                            elevation: 0,
                            color: Colors.white24,
                            margin: EdgeInsets.zero,
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
                                  ReadMoreText(
                                    parse(model.tada.value.description ?? "")
                                        .body!
                                        .text,
                                    trimLines: 15,
                                    colorClickableText: Colors.blue,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: ' Show more',
                                    trimExpandedText: ' Show less',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                    lessStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    moreStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.bottomSheet(
                                  AttachmentBottomSheet(
                                      model.tada.value.attachments!),
                                  isDismissible: true,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  ignoreSafeArea: true);
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white24,
                              margin: EdgeInsets.zero,
                              shape: ButtonBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Obx(
                                          () => Text(
                                            "Attachments ( ${model.tada.value.attachments!.length.toString()} )",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          translate(
                                              'task_detail_screen.view_all'),
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 10),
                                    // Card(
                                    //   color: Colors.blue,
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(10),
                                    //     child: Row(
                                    //       mainAxisSize: MainAxisSize.min,
                                    //       children: [
                                    //         Icon(
                                    //           Icons.comment,
                                    //           color: Colors.white,
                                    //         ),
                                    //         SizedBox(
                                    //           width: 10,
                                    //         ),
                                    //         Text(
                                    //           "Write a comment",
                                    //           style: TextStyle(
                                    //               color: Colors.white,
                                    //               fontSize: 15,
                                    //               fontWeight: FontWeight.bold),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
