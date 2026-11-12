
import 'package:cnattendance/repositories/advancesalaryrepository.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class CreateAdvanceSalaryController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final expensesController = TextEditingController();

  AdvanceSalaryRepository repository = AdvanceSalaryRepository();

  final key = GlobalKey<FormState>();

  void checkForm() {
    if (key.currentState!.validate()) {
      createTada();
    }
  }

  Future<String> createTada() async {
    EasyLoading.show(status: translate('loader.loading'), maskType: EasyLoadingMaskType.black);
    try {
      final response = await repository.createAdvanceSalary(
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

  @override
  void onInit() {
    super.onInit();
  }
}
