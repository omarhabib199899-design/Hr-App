import 'package:cnattendance/model/advancesalary.dart';
import 'package:cnattendance/repositories/advancesalaryrepository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class AdvanceDetailController extends GetxController {
  var advanceSalary = AdvanceSalary(0, "", "", "", "", false, "", "", "","","").obs;
  var isLoading = false.obs;
  AdvanceSalaryRepository repository = AdvanceSalaryRepository();

  Future<String> getAdvanceSalaryDetail(String id) async {
    try {
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);

      final response = await repository.getAdvanceSalaryDetail(id);
      EasyLoading.dismiss(animation: true);

      final data = response.data;

      final salary = AdvanceSalary(
          data.id,
          data.description,
          data.requested_amount,
          data.released_amount,
          data.status,
          data.is_settled,
          data.verified_by,
          data.remark,
          data.released_date,data.requested_date,data.released_date);

      advanceSalary.value = salary;
    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss(animation: true);
      Get.back();
    }
    return "loaded";
  }

  @override
  void onInit() {
    getAdvanceSalaryDetail(Get.arguments['id']);
    super.onInit();
  }
}
