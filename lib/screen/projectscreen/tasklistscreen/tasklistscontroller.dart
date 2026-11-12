import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/tasklistresponse/tasklistresponse.dart';
import 'package:cnattendance/model/task.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class TaskListController extends GetxController {
  final taskList = <Task>[].obs;
  final filteredList = <Task>[].obs;
  final selected = "All".obs;

  void filterList() {
    filteredList.clear();
    if (selected.value == "All") {
      filteredList.addAll(taskList);
    } else {
      for (var project in taskList) {
        if (project.status == selected.value) {
          filteredList.add(project);
        }
      }
    }
  }

  Future<String> getTaskList() async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl() + Constant.TASK_LIST_URL);

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
      debugPrint(response.body.toString());
      EasyLoading.dismiss(animation: true);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        taskList.clear();
        final taskResponse = tasklistresponse.fromJson(responseData);

        for (var task in taskResponse.data) {
          DateTime startDate = DateFormat("MMM dd yyyy").parse(task.start_date);
          DateTime endDate = DateFormat("MMM dd yyyy").parse(task.end_date);

          NepaliDateTime nepaliStartDate = startDate.toNepaliDateTime();
          NepaliDateTime nepaliEndDate = endDate.toNepaliDateTime();

          String nepaliStartTempDate =
              NepaliDateFormat("MMM dd yyyy").format(nepaliStartDate);
          String nepaliEndTempDate =
              NepaliDateFormat("MMM dd yyyy").format(nepaliEndDate);

          taskList.add(Task(
              task.task_id,
              task.task_name,
              task.project_name,
              isAd ? task.start_date : nepaliStartTempDate,
              isAd ? task.end_date : nepaliEndTempDate,
              task.status,
              progress: task.task_progress_percent,hasProgress: true,priority: task.priority));
        }

        filterList();
        return "loaded";
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
    getTaskList();
    super.onInit();
  }
}
