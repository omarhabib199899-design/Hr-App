import 'package:cnattendance/provider/awardlistcontroller.dart';
import 'package:cnattendance/screen/awards/awarddetailsscreen.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get/get.dart';

class AwardsScreen extends StatelessWidget {
  final model = Get.put(AwardListController());

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        model.getAwards();
      },
      child: Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(translate('award_screen.award')),
          ),
          body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            color: Colors.white,
            backgroundColor: Colors.blueGrey,
            edgeOffset: 50,
            onRefresh: () {
              return model.getAwards();
            },
            child: SafeArea(
                child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: ButtonBorder(),
                      elevation: 0,
                      color: Colors.white12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/trophy.png",
                              height: 80,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate('award_screen.total_awards'),
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.workspace_premium,
                                      color: Colors.orangeAccent,
                                      size: 35,
                                    ),
                                    Obx(
                                      () => Text(
                                        model.totalAwards.value.toString(),
                                        style: TextStyle(
                                            fontSize: 38,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    /*
                    Obx(
                      () => Visibility(
                        visible: model.recentAward.value.id != 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 5),
                              child: Text(
                                translate('award_screen.recent_achievement'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Obx(
                              () => GestureDetector(
                                onTap: () {
                                  Get.to(AwardDetailScreen(), arguments: {
                                    "award": model.recentAward.value
                                  });
                                },
                                child: Card(
                                  shape: ButtonBorder(),
                                  elevation: 0,
                                  color: Colors.green.withOpacity(.50),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 30,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 20),
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Card(
                                                color: Colors.deepOrange,
                                                margin: EdgeInsets.zero,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 5),
                                                  child: Text(
                                                    "${translate('award_screen.rewcode')} : ${model.recentAward.value.reward_code}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                model.recentAward.value
                                                    .award_name,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                model.recentAward.value
                                                    .awarded_date,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.workspace_premium_outlined,
                                            color: Colors.white24,
                                            size: 80,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),*/
                    SizedBox(
                      height: 5,
                    ),
                    Obx(
                      () => Visibility(
                        visible: model.awardlist.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 5),
                              child: Text(
                                translate('award_screen.all_achievement'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Obx(
                              () => ListView.builder(
                                itemCount: model.awardlist.length,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final award = model.awardlist[index];
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(AwardDetailScreen(),
                                              arguments: {"award": award});
                                        },
                                        child: Card(
                                          shape: ButtonBorder(),
                                          elevation: 0,
                                          color: index == 0
                                              ? Colors.green
                                                  .withValues(alpha: .5)
                                              : Colors.white
                                                  .withValues(alpha: .15),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                right: 10,
                                                top: 0,
                                                bottom: 0,
                                                child: Icon(
                                                  Icons
                                                      .workspace_premium_outlined,
                                                  color: Colors.white
                                                      .withOpacity(.05),
                                                  size: 60,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0,
                                                        horizontal: 10),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          award.award_name,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              70,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "${translate('award_screen.awarded_by')}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .normal),
                                                                    ),
                                                                    Text(
                                                                      "${award.awarded_by}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                          15,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                child: SizedBox(
                                                                  height: 25,
                                                                  child: VerticalDivider(
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                                  children: [
                                                                    Text(
                                                                      "Awarded Date",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                          12,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                    ),
                                                                    Text(
                                                                      "${award.awarded_date}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                          15,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
