import 'package:cnattendance/screen/projectscreen/commentscreen/commentscreen.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/taskdetailcontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class CommentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskDetailController controller = Get.find();
    return GestureDetector(
      onTap: () {
        Get.to(CommentScreen(),
            arguments: {"taskId": controller.taskDetail.value.id.toString(),"members":controller.taskDetail.value.members});
      },
      child: Card(
        elevation: 0,
        color: Colors.white24,
        margin: EdgeInsets.zero,
        shape: ButtonBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => Text(
                      "${translate('task_detail_screen.comments')} ( ${controller.taskDetail.value.noOfComments} )",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    translate('task_detail_screen.view_all'),
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              // SizedBox(height: 10),
              // Card(
              //   color: Colors.blue,
              //   child: Padding(
              //     padding: const EdgeInsets.all(10),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(
              //           Icons.comment,
              //           color: Colors.white,
              //         ),
              //         SizedBox(
              //           width: 10,
              //         ),
              //         Text(
              //           "Write a comment",
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
