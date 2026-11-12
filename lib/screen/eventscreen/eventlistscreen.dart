import 'package:cnattendance/screen/eventscreen/eventdetailscreen.dart';
import 'package:cnattendance/screen/eventscreen/eventlistcontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EventListScreen extends StatelessWidget {
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
          title: Text(translate('common.events')),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await model.getEvents(model.toggleValue.value == 0);
          },
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.sizeOf(context).height),
            child: ListView(
              children: [
                Center(
                  child: Obx(
                    () => ToggleSwitch(
                      activeBgColor: [Colors.white12],
                      activeFgColor: Colors.white,
                      inactiveFgColor: Colors.white,
                      inactiveBgColor: Colors.transparent,
                      minWidth: 100,
                      minHeight: 45,
                      initialLabelIndex: model.toggleValue.value,
                      totalSwitches: 2,
                      onToggle: (index) {
                        model.toggleValue.value = index!;
                      },
                      labels: [
                        translate('holiday_screen.upcoming'),
                        translate('holiday_screen.past')
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: model.toggleValue == 0
                          ? model.upcomingEventList.length
                          : model.pastEventList.length,
                      itemBuilder: (context, index) {
                        final item = model.toggleValue == 0
                            ? model.upcomingEventList[index]
                            : model.pastEventList[index];
                        return Card(
                          elevation: 0,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          color: Colors.white12,
                          shape: ButtonBorder(),
                          child: InkWell(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            onTap: () {
                              Get.to(EventDetailScreen(item));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.location,
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    item.title,
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
                                        item.startdate +
                                            (item.endDate.isEmpty
                                                ? ""
                                                : " - ") +
                                            (item.endDate.isEmpty
                                                ? ""
                                                : item.endDate),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Spacer(),
                                      Text(
                                        item.startTime +
                                            (item.endTime.isEmpty
                                                ? ""
                                                : " - ") +
                                            (item.endTime.isEmpty
                                                ? ""
                                                : item.endTime),
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
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
