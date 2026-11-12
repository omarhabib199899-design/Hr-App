import 'package:cnattendance/data/source/network/model/warningresponse/warningresponse.dart';
import 'package:cnattendance/repositories/warningrepository.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:get/get.dart';

class WarningController extends GetxController {
  var warningList = <Warning>[].obs;
  int page = 1;
  final repository = WarningRepository();

  Future<void> getWarnings() async {
    try {
      final response = await repository.getWarnings(page);
      if (page == 1) {
        warningList.value = response.data;
      } else {
        warningList.addAll(response.data);
      }

      if (warningList.isNotEmpty) {
        page++;
      }
    } catch (e) {
      print(e.toString());
      showToast(e.toString());
    }
  }

  Future<(bool, String)> saveResponseWarining(
      String userResponse, int id) async {
    try {
      var (status, message) =
          await repository.writeResponse(userResponse, id.toString());
      return (status, message);
    } catch (e) {
      return (false, e.toString());
    }
  }

  @override
  void onReady() {
    page = 1;
    getWarnings();
    super.onReady();
  }
}
