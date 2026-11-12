import 'package:cnattendance/model/tada.dart';
import 'package:cnattendance/provider/tadalistcontroller.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class TadaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(TadaListController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            translate('tada_list_screen.tada'),
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              model.onTadaCreateClicked();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue),
        body: Obx(
          () => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RefreshIndicator(
                onRefresh: () {
                  return model.getTadaList();
                },
                child: ListView.builder(
                  itemCount: model.tadaList.length,
                  itemBuilder: (context, index) {
                    Tada item = model.tadaList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(10))),
                        tileColor: Colors.white12,
                        onTap: () {
                          model.onTadaClicked(item.id.toString());
                        },
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        title: Text(
                          item.title,
                          style: TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                          item.submittedDate,
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            if (item.status == "Accepted") {
                              showToast("Accepted TADA can't be edited");
                            } else {
                              model.onTadaEditClicked(item.id.toString());
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.edit),
                          ),
                        ),
                        leading: Card(
                            color: item.status == "Pending"
                                ? Colors.orange
                                : item.status == "Rejected"
                                    ? Colors.red
                                    : Colors.green,
                            shape: CircleBorder(),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                item.status == "Pending"
                                    ? "P"
                                    : item.status == "Rejected"
                                        ? "R"
                                        : "A",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            )),
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
