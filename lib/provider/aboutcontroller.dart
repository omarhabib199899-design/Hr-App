import 'package:cnattendance/repositories/aboutrepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class AboutController extends GetxController {
  AboutRepository repository = AboutRepository();

  var isLoading = false.obs;

  var _content = <String, String>{
    'title': '',
    'description': '',
  }.obs;

  Map<String, String> get content {
    return _content;
  }

  Future<void> getContent(String value) async {
    _content.value = {
      'title': '',
      'description': '',
    };
    try {
      isLoading.value = true;
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);
      final response = await repository.getContent(value);
      isLoading.value = false;
      EasyLoading.dismiss(animation: true);
      _content.update('title', (value) => response.data.title);
      _content.update('description', (value) => response.data.description);
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss(animation: true);
      rethrow;
    }
  }
}
