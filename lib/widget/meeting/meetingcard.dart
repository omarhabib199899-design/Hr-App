import 'package:cnattendance/data/source/network/model/meeting/Participator.dart';
import 'package:cnattendance/screen/profile/meetingdetailscreen.dart';
import 'package:cnattendance/widget/meeting/meetingparticipator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class MeetingCard extends StatelessWidget {
  final int id;
  final String title;
  final String venue;
  final String date;
  final String time;
  final List<Participator> participator;

  MeetingCard(this.id, this.title, this.venue, this.date, this.participator,this.time);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(MeetingDetailScreen(),arguments: {"id":id});
      },
      child: Card(
        color: Colors.white12,
        elevation: 0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
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
                                translate('meeting_list_screen.venue'),
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(venue,
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
                            children: [
                              Text(
                                "Date",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(date,
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
                                "Time",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(time,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
