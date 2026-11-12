
import 'package:cnattendance/repositories/advancesalaryrepository.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class EditAdvanceSalaryController extends GetxController {
  final descriptionController = TextEditingController();
  final expensesController = TextEditingController();

  AdvanceSalaryRepository repository = AdvanceSalaryRepository();

  final key = GlobalKey<FormState>();

  void checkForm() {
    if (key.currentState!.validate()) {
      upadteAdavance();
    }
  }

  Future<String> upadteAdavance() async {
    EasyLoading.show(status: translate('loader.loading'), maskType: EasyLoadingMaskType.black);
    try {
      final response = await repository.updateAdvanceSalary(
          Get.arguments["id"].toString(),
          expensesController.text.toString(),
          descriptionController.text.toString());
      EasyLoading.dismiss(animation: true);
      if (response.status == true) {
        showToast(response.message);
        Get.back();
      }
    } catch (e) {
      EasyLoading.dismiss(animation: true);
      showToast(e.toString());
    }

    return "loaded";
  }

  Future<String> getAdvanceSalaryDetail(String id) async {
    try {
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);

      final response = await repository.getAdvanceSalaryDetail(id);
      EasyLoading.dismiss(animation: true);

      final data = response.data;
      descriptionController.text = data.description;
      expensesController.text = data.requested_amount;
    } catch (e) {
      EasyLoading.dismiss(animation: true);
      Get.back();
    }
    return "loaded";
  }

  @override
  void onInit() {
    getAdvanceSalaryDetail(Get.arguments["id"]);
    super.onInit();
  }
}
