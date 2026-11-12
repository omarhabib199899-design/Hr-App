import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/notification/NotifiactionDomain.dart';
import 'package:cnattendance/data/source/network/model/notification/NotificationResponse.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cnattendance/model/notification.dart' as Not;
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class NotificationController extends GetxController {
  static int per_page = 10;
  int page = 1;

  var _notificationList = <Not.Notification>[].obs;
  late ScrollController controller;

  List<Not.Notification> get notificationList {
    return [..._notificationList];
  }

  Future<NotificationResponse> getNotification() async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl()+Constant.NOTIFICATION_URL).replace(queryParameters: {
      'page': page.toString(),
      'per_page': per_page.toString(),
    });

    String token = await preferences.getToken();
    bool isAd = await preferences.getEnglishDate();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final jsonResponse = NotificationResponse.fromJson(responseData);

        makeNotificationList(jsonResponse.data);
        return jsonResponse;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> makeNotificationList(List<NotifiactionDomain> data) async {
    Preferences preferences = Preferences();
    bool isAd = await preferences.getEnglishDate();

    if (page == 1) {
      _notificationList.clear();
    }

    if (data.isNotEmpty) {
      for (var item in data) {
        DateTime tempDate =
            DateFormat("yyyy-MM-dd").parse(item.notificationPublishedDate);
        NepaliDateTime nepaliDate = tempDate.toNepaliDateTime();
        print(nepaliDate);

        _notificationList.add(Not.Notification(
            id: item.id,
            title: item.notificationTitle,
            description: item.description,
            month: isAd?DateFormat('MMM').format(tempDate):NepaliDateFormat('MMMM').format(nepaliDate),
            day: isAd?DateFormat('dd').format(tempDate):NepaliDateFormat('dd').format(nepaliDate),
            date: tempDate));
      }

      page += page;
    }
  }

  @override
  void onInit() {
    controller = ScrollController()..addListener(_loadMore);
    super.onInit();
  }

  @override
  void onReady() {
    getNotification();
    super.onReady();
  }

  @override
  void onClose() {
    controller.removeListener(_loadMore);
    super.onClose();
  }

  var isLoading = false;

  void _loadMore() async{
    if(!isLoading) {
      if (controller.position.maxScrollExtent == controller.position.pixels) {
        isLoading = true;
        getNotification();
        isLoading = false;
      }
    }
  }
}
