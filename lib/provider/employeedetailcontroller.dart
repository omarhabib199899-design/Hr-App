import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/employeedetailresponse/Data.dart';
import 'package:cnattendance/data/source/network/model/employeedetailresponse/employeedetailresponse.dart';
import 'package:cnattendance/model/award.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:cnattendance/model/profile.dart' as up;
import 'package:http/http.dart' as http;

class EmployeeDetailController extends GetxController{
  var  profile = up.Profile(
      id: 0,
      avatar: '',
      name: '',
      username: '',
      email: '',
      post: '',
      phone: '',
      dob: '',
      gender: '',
      address: '',
      bankName: '',
      bankNumber: '',
      joinedDate: '',
      department: '',
      branch: '',
      bank_type: '',
      employment_type: '',
  ).obs;

  var awardsList = <String>[].obs;
  
  Future<employeedetailresponse> getEmployeeDetail(String id) async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl()+Constant.EMPLOYEE_PROFILE_URL+"/$id");


    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);
      final response = await http.get(uri, headers: headers);
      EasyLoading.dismiss(animation: true);
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData.toString());

        final responseJson = employeedetailresponse.fromJson(responseData);
        parseUser(responseJson.data);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  void parseUser(Data rprofile) {
    profile.value.avatar = rprofile.avatar;
    profile.value.name = rprofile.name;
    profile.value.username = rprofile.username;
    profile.value.post = rprofile.post;
    profile.value.phone = rprofile.phone;
    profile.value.dob = rprofile.dob;
    profile.value.gender = rprofile.gender;
    profile.value.address = rprofile.address;
    profile.value.branch = rprofile.branch;
    profile.value.department = rprofile.department;
    profile.value.employment_type = rprofile.employment_type;

    var awards = <String>[];
    for(var award in rprofile.all_awards){
      awards.add(award.award_name);
    }

    awardsList.value = awards;

    profile.refresh();
    awardsList.refresh();
  }

  @override
  void onInit() {
    getEmployeeDetail(Get.arguments["employeeId"]);
    super.onInit();
  }
}