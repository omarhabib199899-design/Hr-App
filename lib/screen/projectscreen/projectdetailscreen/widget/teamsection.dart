import 'package:cnattendance/screen/projectscreen/projectdetailscreen/projectdetailcontroller.dart';
import 'package:cnattendance/screen/projectscreen/projectdetailscreen/widget/teambottomsheet.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:image_stack/image_stack.dart';

class TeamSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProjectDetailController model = Get.find();
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(TeamBottomSheet(model.project.value.leaders,model.project.value.members,),
            isDismissible: true,
            enableDrag: true,
            isScrollControlled: false,
            ignoreSafeArea: true);
      },
      child: Card(
        elevation: 0,
        color: Colors.white24,
        margin: EdgeInsets.zero,
        shape: ButtonBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate('project_detail_screen.team_leads'),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    translate('project_detail_screen.view_all'),
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,decorationColor: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() =>ImageStack(
                      imageList: List<String>.from(model.memberImages),
                      totalCount: model.project.value.members.length,
                      imageRadius: 25,
                      imageCount: 4,
                      imageBorderColor: Colors.white,
                      imageBorderWidth: 1,
                    ),
                  ),
                  Obx(() => ImageStack(
                      imageList: List<String>.from(model.leaderImages),
                      totalCount: model.project.value.leaders.length,
                      imageRadius: 25,
                      imageCount: 1,
                      imageBorderColor: Colors.white,
                      imageBorderWidth: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
