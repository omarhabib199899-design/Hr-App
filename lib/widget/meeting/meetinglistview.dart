import 'package:cnattendance/provider/meetingcontroller.dart';
import 'package:cnattendance/widget/meeting/meetingcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MeetingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MeetingController model = Get.find();
    return Obx(() => Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: model.meetingList.length,
            itemBuilder: (context, i) {
              return MeetingCard(
                model.meetingList[i].id,
                model.meetingList[i].title,
                model.meetingList[i].venue,
                model.meetingList[i].meetingDate,
                model.meetingList[i].participator,
                model.meetingList[i].meetingStartTime,
              );
            }),
      ),
    );
  }
}
