import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/headerprofile.dart';
import 'package:cnattendance/widget/leavescreen/leave_list_dashboard.dart';
import 'package:cnattendance/widget/leavescreen/leave_list_detail_dashboard.dart';
import 'package:cnattendance/widget/leavescreen/leavebutton.dart';
import 'package:cnattendance/widget/leavescreen/leavetypefilter.dart';
import 'package:cnattendance/widget/leavescreen/toggleleavetime.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import 'package:cnattendance/provider/leaveprovider.dart';

class LeaveScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeaveScreenState();
}

class LeaveScreenState extends State<LeaveScreen> with WidgetsBindingObserver {
  var init = true;
  var isVisible = false;

  @override
  void didChangeDependencies() {
    if (init) {
      initialState();
      init = false;
    }

    super.didChangeDependencies();
  }

  Future<String> initialState() async {
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    final leaveData = await leaveProvider.getLeaveType();

    if (!mounted) {
      return "Loaded";
    }
    if (leaveData.statusCode != 200) {
      showToast(leaveData.message);
    }

    getLeaveDetailList();
    return "Loaded";
  }

  void getLeaveDetailList() async {
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    final detailResponse = await leaveProvider.getLeaveTypeDetail();

    if (!mounted) {
      return;
    }
    if (detailResponse.statusCode == 200) {
      isVisible = true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          padding: EdgeInsets.all(20), content: Text(detailResponse.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FocusDetector(
          onVisibilityGained: () {
            initialState();
          },
          child: SafeArea(
              child: RefreshIndicator(
            onRefresh: () {
              return initialState();
            },
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HeaderProfile(),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        width: double.infinity,
                        child: Text(
                          translate('leave_screen.leave'),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )),
                    LeaveListDashboard(),
                    Visibility(
                      visible: isVisible,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: LeaveButton()),
                    ),
                    SizedBox(height: 20,),
                    Visibility(
                      visible: isVisible,
                      child: Text(translate('leave_screen.recent_leave_activity'),style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),
                    SizedBox(height: 10,),
                    Stack(
                      children: [
                        Align(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
                            child: Card(
                              color: Colors.white12,
                              shape: ButtonBorder(),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: isVisible,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10),
                                          child: LeavetypeFilter()),
                                    ),
                                    Visibility(
                                        visible: isVisible, child: LeaveListdetailDashboard()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          child: Visibility(
                            visible: isVisible,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: ToggleLeaveTime()),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
