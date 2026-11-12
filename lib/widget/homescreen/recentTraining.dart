import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/screen/traning/trainingdetailsscreen.dart';
import 'package:cnattendance/screen/traning/traningscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RecentTraining extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final training = context.watch<DashboardProvider>().training;
    final userId = context.watch<PrefProvider>().userId;
    return Visibility(
      visible: training != null ? true : false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  translate('home_screen.training'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(TrainingScreen());
                  },
                  child: Text(
                    translate('home_screen.show_all'),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            training != null
                ? GestureDetector(
                    onTap: () {
                      Get.to(TrainingDetailScreen(),
                          arguments: {"training": training});
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      color: Colors.white12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(training.trainingType,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  height: 1.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text(
                                            (training.trainer
                                                .where(
                                                  (element) =>
                                              element.user_id.toString() ==
                                                  userId,
                                            )
                                            ).isEmpty
                                                ? "Participant"
                                                : "Trainer",
                                            style: TextStyle(color: Colors.white,fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start-End Date",
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                        Row(
                                          children: [
                                            Text(training.startDate,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 12)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            if(training.endDate.isNotEmpty)
                                            Text(" - ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 12)),
                                            if(training.endDate.isNotEmpty)
                                            SizedBox(
                                              width: 5,
                                            ),
                                            if(training.endDate.isNotEmpty)
                                            Text(training.endDate,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 30,
                                      child: VerticalDivider(
                                        width: 1,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start-End Time",
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                        Row(
                                          children: [
                                            Text(training.startTime,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 12)),
                                            if (training.endTime.isNotEmpty)
                                              Text(" - ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12)),
                                            if (training.endTime.isNotEmpty)
                                              SizedBox(
                                                width: 5,
                                              ),
                                            if (training.endTime.isNotEmpty)
                                              Text(training.endTime,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
