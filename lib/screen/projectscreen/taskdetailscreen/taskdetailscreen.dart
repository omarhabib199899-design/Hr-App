import 'package:cnattendance/screen/projectscreen/taskdetailscreen/taskdetailcontroller.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/widget/attachmentsection.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/widget/commentsection.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/widget/checklistsection.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/widget/confirmbottomsheet.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/widget/descriptionsection.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/widget/headersection.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/widget/teamsection.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class TaskDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TaskDetailController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Obx(() => Text(
                  controller.taskDetail.value.projectName!,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
          ),
          bottomNavigationBar: Obx(
            () => controller.taskDetail.value.has_checklist == false && controller.taskDetail.value.status != "Completed"
                ? SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                        ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                useRootNavigator: true,
                                builder: (context) {
                                  return ConfirmBottomSheet();
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Text(translate('task_detail_screen.mark_as_finish')),
                          )),
                    ),
                )
                : SizedBox.shrink(),
          ),
          body: Obx(
            () => SafeArea(
              child: RefreshIndicator(
                onRefresh: () {
                  return controller.getTaskOverview();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: controller.taskDetail.value.id != 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderSection(),
                              SizedBox(
                                height: 20,
                              ),
                              DescriptionSection(),
                              SizedBox(height: 20,),
                              TeamSection(),
                              SizedBox(height: 20,),
                              AttachmentSection(),
                              SizedBox(height: 20,),
                              CommentSection(),
                              SizedBox(height: 20,),
                              CheckListSection()
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ),
          )),
    );
  }
}
