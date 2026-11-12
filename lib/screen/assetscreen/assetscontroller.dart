import 'package:cnattendance/data/source/network/model/asssetlistresponse/assetlistresponse.dart';
import 'package:cnattendance/repositories/assetrepository.dart';
import 'package:get/get.dart';

class AssetController extends GetxController {
  final repository = AssetRepository();

  var assets = <AssetData>[].obs;

  @override
  void onReady() {
    super.onReady();
    getAssets();
  }

  Future<void> getAssets() async {
    try {
      final response = await repository.getAssets(1);
      assets.value = response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<(bool, String)> sendResponse(int id,String note,bool isWorking) async {
    final response = await repository.writeResponse(id.toString(), note,isWorking);
    return response;
  }
}
