import 'package:cnattendance/provider/supportlistcontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class SupportListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(SupportListController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(translate('support_list_screen.my_tickets')),
        ),
        body: Obx(
          () => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(
                        10),bottomRight: Radius.circular(10))),
                    color: Colors.white12,
                    elevation: 0,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Obx(
                            () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    model.selected.value = "All";
                                    model.filterList();
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: model.selected.value == "All"
                                        ? Colors.white24
                                        : Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 15),
                                      child: Text(
                                        translate('support_list_screen.all'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    model.selected.value = "Pending";
                                    model.filterList();
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: model.selected.value == "Pending"
                                        ? Colors.white24
                                        : Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 15),
                                      child: Text(
                                        translate('support_list_screen.pending'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    model.selected.value = "In Progress";
                                    model.filterList();
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: model.selected.value == "In Progress"
                                        ? Colors.white24
                                        : Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 15),
                                      child: Text(
                                        translate('support_list_screen.in_progress'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    model.selected.value = "Solved";
                                    model.filterList();
                                  },
                                  child: Card(
                                    elevation: 0,
                                    color: model.selected.value == "Solved"
                                        ? Colors.white24
                                        : Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 15),
                                      child: Text(
                                        translate('support_list_screen.solved'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.filteredList.length,
                      itemBuilder: (context, index) {
                        final support = model.filteredList[index];
                        return InkWell(
                          onTap: () {
                            model.onSupportClicked(support);
                          },
                          child: Card(
                            shape: ButtonBorder(),
                            elevation: 0,
                            color: Colors.white12,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Card(
                                      shape: ButtonBorder(),
                                      elevation: 0,
                                      color: Colors.blueAccent,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              support.day,
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: 25),
                                            ),
                                            Text(support.month,
                                                style: TextStyle(color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            softWrap: true,
                                            support.title,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 18),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      overflow: TextOverflow.fade,
                                                      softWrap: true,
                                                      "${translate('support_list_screen.issue_to')}",
                                                      style: TextStyle(
                                                          color: Colors.grey, fontSize: 12),
                                                    ),
                                                    Text(
                                                      overflow: TextOverflow.fade,
                                                      softWrap: true,
                                                      "${support.requested_department}",
                                                      style: TextStyle(
                                                          color: Colors.white, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                                child: VerticalDivider(
                                                  thickness: 1,
                                                  width: 1,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      overflow: TextOverflow.fade,
                                                      softWrap: true,
                                                      "Status",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey, fontSize: 12),
                                                    ),
                                                    Text(
                                                      overflow: TextOverflow.fade,
                                                      softWrap: true,
                                                      support.status,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: support.status == "Pending"
                                                              ? Colors.deepOrange
                                                              : support.status == "In Progress"
                                                              ? Colors.orangeAccent
                                                              : Colors.green, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
