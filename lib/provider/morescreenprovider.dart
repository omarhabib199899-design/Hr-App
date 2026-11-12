import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/logout/Logoutresponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor_plus/http_interceptor_plus.dart';

class MoreScreenProvider with ChangeNotifier {
  late Map<String, String> features = {};
  bool showNfc = true;

  void changeAttendanceMethod(String type) {
    Preferences preferences = Preferences();
    preferences.saveAttendanceType(type);
    notifyListeners();
  }

  Future<void> getFeatures() async {
    Preferences preferences = Preferences();
    features = await preferences.getFeatures();
    showNfc = await preferences.getShowNfc();
    notifyListeners();
  }

  Future<Logoutresponse> logout() async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl()+Constant.LOGOUT_URL);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = Logoutresponse.fromJson(responseData);

        preferences.clearPrefs();
        return jsonResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<String> getDeviceName() async {
    Map deviceInfo = (await DeviceInfoPlugin().deviceInfo).data;
    String? brand = deviceInfo['brand'];
    String? model = deviceInfo['model'];
    String? name = deviceInfo['name'];

    return ("${name??""} ${brand??""} ${model??""}");
  }

  Future<void> addNfcApi(String title, String identifier) async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl()+Constant.ADD_NFC_URL);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    final http.Client client = LoggingMiddleware(http.Client());

    final response = await client.post(uri, headers: headers, body: {
      'title': await getDeviceName(),
      'identifier': identifier,
    });

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
    } else {
      var errorMessage = responseData['message'];
      throw errorMessage;
    }
  }
}
