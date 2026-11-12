import 'package:cnattendance/provider/employeedetailcontroller.dart';
import 'package:cnattendance/screen/profile/chatscreen.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/cartTitle.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(EmployeeDetailController());
    return Obx(
      () => Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(model.profile.value.name == ""
                ? translate('employee_detail_screen.profile')
                : model.profile.value.name),
          ),
          resizeToAvoidBottomInset: true,
          body: RefreshIndicator(
            onRefresh: () {
              return model.getEmployeeDetail(Get.arguments["employeeId"]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Obx(
                () => Column(
                  children: [
                    Container(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              model.profile.value.avatar))),
                                  alignment: Alignment.bottomCenter,
                                )),
                          ],
                        ),
                      ),
                    ),
                    model.profile.value.post != ''
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        final url = Uri.parse(
                                            "tel:${model.profile.value.phone}");
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      icon: Card(
                                          elevation: 0,
                                          color: Colors.white24,
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.call,
                                              color: Colors.white,
                                            ),
                                          ))),
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Get.to(ChatScreen(), arguments: {
                                          "name": model.profile.value.name,
                                          "avatar": model.profile.value.avatar,
                                          "username":
                                              model.profile.value.username,
                                        });
                                      },
                                      icon: Card(
                                          elevation: 0,
                                          color: Colors.white24,
                                          shape: CircleBorder(),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.message,
                                              color: Colors.white,
                                            ),
                                          ))),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    model.profile.value.post != ''
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 5),
                            width: double.infinity,
                            child: Text(
                              translate('employee_detail_screen.basic_details'),
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 15),
                            ),
                          )
                        : SizedBox(),
                    model.profile.value.post != ''
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            child: Card(
                              shape: ButtonBorder(),
                              color: Colors.white10,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.fullname'),
                                        model.profile.value.name),
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.username'),
                                        model.profile.value.username),
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.phone_number'),
                                        model.profile.value.phone),
                                    CardTitle(
                                        translate('employee_detail_screen.dob'),
                                        model.profile.value.dob),
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.gender'),
                                        model.profile.value.gender),
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.address'),
                                        model.profile.value.address),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    model.profile.value.post != ''
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 10, bottom: 5),
                            width: double.infinity,
                            child: Text(
                              translate(
                                  'employee_detail_screen.company_details'),
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 15),
                            ),
                          )
                        : SizedBox(),
                    model.profile.value.post != ''
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            child: Card(
                              shape: ButtonBorder(),
                              color: Colors.white10,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.job_position'),
                                        model.profile.value.post),
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.branch'),
                                        model.profile.value.branch),
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.department'),
                                        model.profile.value.department),
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.employment_type'),
                                        model.profile.value.employment_type),
                                    CardTitle(
                                        translate(
                                            'employee_detail_screen.joined_date'),
                                        model.profile.value.joinedDate),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    model.awardsList.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 10, bottom: 5),
                            width: double.infinity,
                            child: Text(
                              translate('employee_detail_screen.achievements'),
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 15),
                            ),
                          )
                        : SizedBox(),
                    model.awardsList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: model.awardsList.length,
                              itemBuilder: (context, index) {
                                final award = model.awardsList[index];
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 0),
                                          child: Text(
                                            "🏆   $award",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                    Divider(
                                      color: Colors.white30,
                                      indent: 10,
                                      endIndent: 10,
                                    )
                                  ],
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
