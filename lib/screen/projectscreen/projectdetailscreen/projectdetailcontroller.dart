import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/projectdetail/ProjectDetailResponse.dart';
import 'package:cnattendance/model/attachment.dart';
import 'package:cnattendance/model/member.dart';
import 'package:cnattendance/model/project.dart';
import 'package:cnattendance/model/task.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailController extends GetxController {
  var project = Project(0, "", "","", "", "", "", 0, 0, [], [], []).obs;

  var memberImages = [].obs;
  var leaderImages = [].obs;

  Future<String> getProjectOverview() async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(
        await preferences.getAppUrl() +Constant.PROJECT_DETAIL_URL + "/" + Get.arguments["id"].toString());

    String token = await preferences.getToken();
    bool isAd = await preferences.getEnglishDate();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      EasyLoading.show(status: translate('loader.loading'), maskType: EasyLoadingMaskType.black);
      final response = await http.get(
        uri,
        headers: headers,
      );

      EasyLoading.dismiss(animation: true);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final projectResponse = ProjectDetailResponse.fromJson(responseData);

        List<Member> members = [];
        memberImages.clear();
        for (var member in projectResponse.data.assigned_member) {
          members.add(
              Member(member.id, member.name, member.avatar, post: member.post));
          memberImages.add(member.avatar);
        }

        List<Member> leaders = [];
        leaderImages.clear();
        for (var member in projectResponse.data.project_leader) {
          leaders.add(
              Member(member.id, member.name, member.avatar, post: member.post));
          leaderImages.add(member.avatar);
        }

        List<Attachment> attachments = [];
        for (var attachment in projectResponse.data.attachments) {
          if (attachment.type == "image") {
            attachments.add(Attachment(0, attachment.attachment_url, "image"));
          } else {
            attachments.add(Attachment(0, attachment.attachment_url, "file"));
          }
        }

        DateTime tempDate =
            DateFormat("yyyy-mm-dd").parse(projectResponse.data.start_date);
        NepaliDateTime nepaliDate = tempDate.toNepaliDateTime();

        String nepaliTempDate =
            NepaliDateFormat("MMMM dd yyyy").format(nepaliDate);

        Project response = Project(
            projectResponse.data.id,
            projectResponse.data.name,
            projectResponse.data.slug,
            projectResponse.data.description,
            isAd ? projectResponse.data.start_date : nepaliTempDate,
            projectResponse.data.priority,
            projectResponse.data.status,
            projectResponse.data.progress_percent,
            projectResponse.data.assigned_task_count,
            members,
            leaders,
            attachments);

        final List<Task> taskList = [];
        print(projectResponse.data.assigned_task_detail.length);
        for (var task in projectResponse.data.assigned_task_detail) {
          taskList.add(Task(
              task.task_id,
              task.task_name,
              projectResponse.data.name,
              task.start_date,
              task.deadline,
              task.status));
        }

        response.tasks.addAll(taskList);
        project.value = response;
        return "Loaded";
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  void onInit() {
    getProjectOverview();
    super.onInit();
  }

  Future<void> launchUrls(String _url) async {
    if (!await launchUrl(Uri.parse(_url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}
