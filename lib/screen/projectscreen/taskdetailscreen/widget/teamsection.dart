import 'package:cnattendance/screen/projectscreen/taskdetailscreen/taskdetailcontroller.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/widget/teambottomsheet.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:image_stack/image_stack.dart';

class TeamSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskDetailController controller = Get.find();
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(TeamBottomSheet(controller.taskDetail.value.members),
            isDismissible: true,
            enableDrag: true,
            isScrollControlled: false,
            ignoreSafeArea: true);
      },
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white24,
        shape: ButtonBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate('task_detail_screen.teams'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    translate('task_detail_screen.view_all'),
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Obx(() => ImageStack(
                  imageList: List<String>.from(controller.memberImages),
                  totalCount: controller.memberImages.length,
                  imageRadius: 25,
                  imageCount: 4,
                  imageBorderColor: Colors.white,
                  imageBorderWidth: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
