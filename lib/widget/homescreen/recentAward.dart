import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/screen/awards/awarddetailsscreen.dart';
import 'package:cnattendance/screen/awards/awardsscreen.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RecentAward extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final award = context.watch<DashboardProvider>().award;
    return Visibility(
      visible: award != null ? true : false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  translate('home_screen.recent_award'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(AwardsScreen());
                  },
                  child: Text(
                    translate('home_screen.show_all'),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            award != null
                ? GestureDetector(
                    onTap: () {
                      Get.to(AwardDetailScreen(), arguments: {"award": award});
                    },
                    child: Card(
                      shape: ButtonBorder(),
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      color: Colors.white12,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    award.award_name,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    award.employee_name,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2), // Change color and width as needed
                                ),
                                padding: EdgeInsets.all(3), // Adjust padding if needed
                                child: ClipOval(
                                  child: Image.network(
                                    award.image,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
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
