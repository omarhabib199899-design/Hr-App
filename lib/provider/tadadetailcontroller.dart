
import 'package:cnattendance/model/attachment.dart';
import 'package:cnattendance/model/tada.dart';
import 'package:cnattendance/repositories/tadarepository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class TadaDetailController extends GetxController {
  var tada = Tada(0, "", "", "", "", "", "", "", []).obs;
  var isLoading = false.obs;
  TadaRepository repository = TadaRepository();

  Future<String> getTadaDetail() async {
    try {
      isLoading.value = true;
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);
      final response =
          await repository.getTadaDetail(Get.arguments["tadaId"].toString());
      EasyLoading.dismiss(animation: true);

      final data = response.data;
      final attachmentList = <Attachment>[];
      for (var attachment in data.attachments.image) {
        attachmentList.add(Attachment(attachment.id, attachment.url, "image"));
      }
      for (var attachment in data.attachments.file) {
        attachmentList.add(Attachment(attachment.id, attachment.url, "file"));
      }

      final date = DateFormat("MMM dd yyyy","en")
          .parse(data.submitted_date)
          .toNepaliDateTime();

      final nepaliDate = NepaliDateFormat("MMM dd yyyy").format(date);

      Tada rTada = Tada(
          data.id,
          data.title,
          data.description,
          data.total_expense,
          data.status,
          data.remark,
          data.verified_by,
          await repository.getIsAd()
              ? data.submitted_date
              : nepaliDate,
          attachmentList);

      tada.value = rTada;

      isLoading.value = false;
      return "Loaded";
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  void onInit() {
    getTadaDetail();
    super.onInit();
  }
}
