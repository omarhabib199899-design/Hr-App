import 'package:cnattendance/model/checklist.dart';
import 'package:cnattendance/screen/projectscreen/taskdetailscreen/taskdetailcontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class CheckListSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TaskDetailController controller = Get.find();
    return Card(
      elevation: 0,
      shape: ButtonBorder(),
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translate('task_detail_screen.checklists'),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => controller.taskDetail.value.checkList.length == 0
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          translate('task_detail_screen.no_checklist_found'),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(height: 1,indent: 0,endIndent: 0,color: Colors.white30,);
                      },
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.taskDetail.value.checkList.length,
                      itemBuilder: (context, index) {
                        Checklist checklist =
                            controller.taskDetail.value.checkList[index];
                        var state = false.obs;
                        state.value =
                            checklist.isCompleted == "0" ? false : true;
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          elevation: 0,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final response = await controller
                                  .checkListToggle(checklist.id.toString());

                              if (response) {
                                state.toggle();
                                checklist.isCompleted =
                                    state.value == false ? "0" : "1";
                                state.refresh();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => Icon(
                                      state == true
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: state == true
                                          ? Colors.white
                                          : Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(checklist.name,
                                        maxLines: 2,
                                        style: TextStyle(
                                            height: 1.2,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
