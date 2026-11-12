import 'dart:io';

import 'package:cnattendance/data/source/network/model/trainingresponse/trainingresponse.dart';
import 'package:cnattendance/repositories/trainingrepository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TrainingDetailController extends GetxController {
  final repository = TrainingRepository();
  var upcomingTrainingList = <Training>[].obs;
  var pastTrainingList = <Training>[].obs;
  int upcomingPage = 1;
  int pastPage = 1;

  var toggleValue = 0.obs;

  Future<bool> checkAndRequestStoragePermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
    }

    return status.isGranted;
  }

  Future<void> saveFileLocally(String url) async {
    Directory? directory = await getApplicationDocumentsDirectory();
    String path = directory!.path;
    print(path);
  }

  Future<void> getTrainings(bool isUpcoming) async {
    try {
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);
      var tranings = <Training>[];
      final response = await repository.getTraining(
          isUpcoming ? upcomingPage : pastPage, isUpcoming ? 1 : 0);
      EasyLoading.dismiss(animation: true);
      tranings = response.data;

      if (isUpcoming) {
        if (upcomingPage == 1) {
          upcomingTrainingList.value = tranings;
        } else {
          upcomingTrainingList.addAll(tranings);
        }

        if (tranings.isNotEmpty) {
          upcomingPage++;
        }
      } else {
        if (pastPage == 1) {
          pastTrainingList.value = tranings;
        } else {
          pastTrainingList.addAll(tranings);
        }

        if (tranings.isNotEmpty) {
          pastPage++;
        }
      }
    } catch (e) {
      EasyLoading.dismiss(animation: true);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }
}
