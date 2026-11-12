import 'package:cnattendance/provider/noticecontroller.dart';
import 'package:cnattendance/widget/notice/noticelist.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class NoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(NoticeController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(translate('notice_screen.notices')),
          ),
          body: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () {
                model.page = 1;
                return model.getNotice();
              },
              child: NoticeList())),
    );
  }
}
