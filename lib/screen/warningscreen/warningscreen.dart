import 'package:cnattendance/screen/warningscreen/warningcontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/profile/warning_bottom_sheet.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(WarningController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("Warning"),
        ),
        body: Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              model.page = 1;
              await model.getWarnings();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height),
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: true,
                  itemCount: model.warningList.length,
                  itemBuilder: (context, index) {
                    final warning = model.warningList[index];
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            elevation: 0,
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            builder: (context) {
                              return WarningBottomSheet(warning);
                            });
                      },
                      child: Card(
                        shape: ButtonBorder(),
                        color: warning.response.isEmpty
                            ? Colors.blue.withValues(alpha: .5)
                            : Colors.white24,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      warning.warningDate,
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      warning.subject,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                warning.response.isNotEmpty
                                    ? Icons.reply
                                    : Icons.warning,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
