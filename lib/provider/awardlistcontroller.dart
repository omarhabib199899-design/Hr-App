import 'package:cnattendance/model/award.dart';
import 'package:cnattendance/repositories/awardrepository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class AwardListController extends GetxController {
  var awardlist = <Award>[].obs;
  var recentAward = Award(
      award_description: "",
      award_name: "",
      awarded_by: "",
      awarded_date: "",
      employee_name: "",
      gift_description: "",
      gift_item: "",
      id: 0,
      image: "",
      awardImage: "",
      reward_code: "").obs;
  var totalAwards = 0.obs;
  final respository = AwardRepository();

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> getAwards() async {
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);
      final response = await respository.getAwards();
      EasyLoading.dismiss(animation: true);

      totalAwards.value = response.data.total_awards;
      if (response.data.recent_award != null) {
        recentAward.value = Award(
            award_description: response.data.recent_award!.award_description,
            award_name: response.data.recent_award!.award_name,
            awarded_by: response.data.recent_award!.awarded_by,
            awarded_date: response.data.recent_award!.awarded_date,
            employee_name: response.data.recent_award!.employee_name,
            gift_description: response.data.recent_award!.gift_description,
            gift_item: response.data.recent_award!.gift_item,
            id: response.data.recent_award!.id,
            image: response.data.recent_award!.image,
            awardImage: response.data.recent_award!.awardImage,
            reward_code: response.data.recent_award!.reward_code);
      }else{
        recentAward.value.id = 0;
        recentAward.refresh();
      }

      var list = <Award>[];

      for (var award in response.data.all_awards) {
        list.add(Award(
            award_description: award.award_description,
            award_name: award.award_name,
            awarded_by: award.awarded_by,
            awarded_date: award.awarded_date,
            employee_name: award.employee_name,
            gift_description: award.gift_description,
            gift_item: award.gift_item,
            id: award.id,
            image: award.image,
            awardImage: award.awardImage,
            reward_code: award.reward_code));
      }

      awardlist.value = list;

  }
}
