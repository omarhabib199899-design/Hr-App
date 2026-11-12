import 'package:cnattendance/screen/projectscreen/taskdetailscreen/taskdetailcontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:readmore/readmore.dart';

class DescriptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskDetailController controller = Get.find();
    return Card(
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
              translate('task_detail_screen.description'),
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Obx(() =>ReadMoreText(
              parse(controller.taskDetail.value.description).body!.text,
              trimLines: 4,
              colorClickableText: Colors.blue,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' ${translate('project_detail_screen.show_more')}',
              trimExpandedText: ' ${translate('project_detail_screen.show_less')}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              lessStyle: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              moreStyle: TextStyle(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
