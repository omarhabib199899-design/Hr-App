import 'package:cnattendance/model/event.dart';
import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/screen/awards/awarddetailsscreen.dart';
import 'package:cnattendance/screen/awards/awardsscreen.dart';
import 'package:cnattendance/screen/eventscreen/eventdetailscreen.dart';
import 'package:cnattendance/screen/eventscreen/eventlistscreen.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RecentEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final event = context.watch<DashboardProvider>().event;
    return Visibility(
      visible: event != null ? true : false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  translate('common.office_events'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(EventListScreen());
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
            event != null
                ? Card(
                    elevation: 0,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    color: Colors.white12,
                    shape: ButtonBorder(),
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      onTap: () {
                        Get.to(EventDetailScreen(Event(
                            event.id,
                            event.title,
                            event.description,
                            event.location,
                            event.startDate,
                            event.endDate,
                            event.startTime,
                            event.endTime,
                            event.image,
                            event.createdBy,
                            event.creator,
                            event.eventUsers,
                            event.eventDepartments)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.location,
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              event.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Divider(
                              color: Colors.white30,
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  event.startDate +
                                      (event.endDate.isEmpty ? "" : " - ") +
                                      (event.endDate.isEmpty
                                          ? ""
                                          : event.endDate),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
                                Spacer(),
                                Text(
                                  event.startTime +
                                      (event.endTime.isEmpty ? "" : " - ") +
                                      (event.endTime.isEmpty
                                          ? ""
                                          : event.endTime),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                ),
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
