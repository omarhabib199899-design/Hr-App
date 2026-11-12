import 'package:cnattendance/model/event.dart';
import 'package:cnattendance/screen/eventscreen/eventlistcontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen(this.event);

  @override
  Widget build(BuildContext context) {
    final model = Get.put(EventListController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.image.isNotEmpty)
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          event.image,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        )),
                  if (event.image.isNotEmpty)
                    SizedBox(
                      height: 10,
                    ),
                  Text(
                    event.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translate('common.event_date'),
                              style: TextStyle(color: Colors.white70),
                            ),
                            Row(
                              children: [
                                Text(
                                  event.startdate +
                                      (event.endDate.isEmpty ? "" : " - ") +
                                      (event.endDate.isEmpty ? "" : event.endDate),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
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
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              translate('common.event_date'),
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              event.startTime +
                                  (event.endTime.isEmpty ? "" : " - ") +
                                  (event.endTime.isEmpty ? "" : event.endTime),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translate('common.location'),
                              style: TextStyle(color: Colors.white70),
                            ),
                            Row(
                              children: [
                                Text(
                                  event.location,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
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
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              translate('common.host'),
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              event.creator.name,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Card(
                    shape: ButtonBorder(),
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: Colors.white24,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate('common.event_description'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            event.description,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )
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
    );
  }
}
