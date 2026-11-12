import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/checkliststatustoggle/CheckListStatusToggleResponse.dart';
import 'package:cnattendance/data/source/network/model/taskdetail/taskdetail.dart';
import 'package:cnattendance/model/checklist.dart';
import 'package:cnattendance/model/member.dart';
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

import '../../../model/attachment.dart';

class TaskDetailController extends GetxController {
  var taskDetail =
      (Task.all(0, "", "", "", "", "", "", "Completed", 0, 0, true, [], [], []))
          .obs;

  var memberImages = [].obs;
  var leaderImages = [].obs;

  Future<TaskDetailResponse> getTaskOverview() async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl() +
        Constant.TASK_DETAIL_URL +
        "/" +
        Get.arguments["id"].toString());

    String token = await preferences.getToken();
    bool isAd = await preferences.getEnglishDate();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);
      final response = await http.get(
        uri,
        headers: headers,
      );
      EasyLoading.dismiss(animation: true);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final taskResponse = TaskDetailResponse.fromJson(responseData);

        List<Member> members = [];
        memberImages.clear();
        for (var member in taskResponse.data.assigned_member) {
          members.add(
              Member(member.id, member.name, member.avatar, post: member.post));
          memberImages.add(member.avatar);
        }

        List<Checklist> checkLists = [];
        for (var checkList in taskResponse.data.checklists) {
          checkLists.add(Checklist(checkList.id, checkList.task_id,
              checkList.name, checkList.is_completed));
        }

        List<Attachment> attachments = [];
        for (var attachment in taskResponse.data.attachments) {
          if (attachment.type == "image") {
            attachments.add(Attachment(0, attachment.attachment_url, "image"));
          } else {
            attachments.add(Attachment(0, attachment.attachment_url, "file"));
          }
        }

        DateTime startDate =
            DateFormat("MMM dd yyyy").parse(taskResponse.data.start_date);

        NepaliDateTime nepaliStartDate = startDate.toNepaliDateTime();

        String nepaliStartTempDate =
            NepaliDateFormat("MMM dd yyyy").format(nepaliStartDate);

        var task = Task.all(
            taskResponse.data.task_id,
            taskResponse.data.task_name,
            taskResponse.data.project_name,
            taskResponse.data.description,
            isAd ? taskResponse.data.start_date : nepaliStartTempDate,
            taskResponse.data.deadline,
            taskResponse.data.priority,
            taskResponse.data.status,
            taskResponse.data.task_progress_percent,
            taskResponse.data.task_comments.length,
            taskResponse.data.has_checklist,
            members,
            checkLists,
            attachments);

        taskDetail.value = task;
        return taskResponse;
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

  Future<bool> checkListToggle(String checkListId) async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl() +
        Constant.UPDATE_CHECKLIST_TOGGLE_URL +
        "/" +
        checkListId);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    debugPrint(uri.toString());
    try {
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);
      final response = await http.get(
        uri,
        headers: headers,
      );
      EasyLoading.dismiss(animation: true);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final taskResponse =
            CheckListStatusToggleResponse.fromJson(responseData);

        return true;
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> checkListTaskToggle(String taskId) async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl() +
        Constant.UPDATE_TASK_TOGGLE_URL +
        "/" +
        taskId);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    debugPrint(uri.toString());
    try {
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);
      final response = await http.get(
        uri,
        headers: headers,
      );
      EasyLoading.dismiss(animation: true);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        Get.back();
        showToast("Task completed");
        return true;
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> launchUrls(String _url) async {
    if (!await launchUrl(Uri.parse(_url),
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void onInit() {
    getTaskOverview();
    super.onInit();
  }
}
