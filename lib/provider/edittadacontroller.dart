import 'dart:convert';
import 'dart:io';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/leaveissue/IssueLeaveResponse.dart';
import 'package:cnattendance/data/source/network/model/tadadetail/tadadetailresponse.dart';
import 'package:cnattendance/model/attachment.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class EditTadaController extends GetxController {
  var fileList = <PlatformFile>[].obs;
  var attachmentList = <Attachment>[].obs;

  String id = "";

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final expensesController = TextEditingController();

  final key = GlobalKey<FormState>();

  void onFileClicked() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    final platformFile = result?.files.single;
    if (platformFile != null) {
      fileList.add(platformFile);
    }

  }

  void checkForm() {
    if (key.currentState!.validate()) {
      editTada();
    }
  }

  Future<String> getTadaDetail() async {
    Preferences preferences = Preferences();
    var uri =
    Uri.parse(await preferences.getAppUrl()+Constant.TADA_DETAIL_URL + "/${Get.arguments["tadaId"]}");

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      EasyLoading.show(status: translate('loader.loading'),maskType: EasyLoadingMaskType.black);
      final response = await http.get(
        uri,
        headers: headers,
      );
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);
      EasyLoading.dismiss(animation: true);

      if (response.statusCode == 200) {
        final tadaResponse = TadaDetailResponse.fromJson(responseData);

        final data = tadaResponse.data;
        final attachments = <Attachment>[];
        for (var attachment in data.attachments.image) {
          attachments
              .add(Attachment(attachment.id, attachment.url, "image"));
        }
        for (var attachment in data.attachments.file) {
          attachments.add(Attachment(attachment.id, attachment.url, "file"));
        }

        titleController.text = parse(data.title).body!.text;
        descriptionController.text = parse(data.description).body!.text;
        expensesController.text = data.total_expense;
        attachmentList.value = attachments;

        return "Loaded";
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      print(e);
      showToast(e.toString());
      throw e;
    }
  }

  Future<String> editTada() async {
    try{
      Preferences preferences = Preferences();
      var uri = Uri.parse(await preferences.getAppUrl()+Constant.TADA_UPDATE_URL);

      String token = await preferences.getToken();

      Map<String, String> headers = {
        'Accept': 'application/json; charset=UTF-8',
        'Content-type': 'multipart/form-data',
        'Authorization': 'Bearer $token'
      };
      var requests = http.MultipartRequest('POST', uri);
      requests.headers.addAll(headers);


      requests.fields.addAll({
        "title": titleController.text,
        "description": descriptionController.text,
        "total_expense": expensesController.text,
        "tada_id": id,
      });

      for (var filed in fileList) {
        final file = File(filed.path!);
        final stream = http.ByteStream(Stream.castFrom(file.openRead()));
        final length = await file.length();

        final multipartFile = http.MultipartFile(
            'attachments[]',
            stream,
            length,
            filename: filed.name
        );
        requests.files.add(multipartFile);
      }

      EasyLoading.show(status: translate('loader.loading'),maskType: EasyLoadingMaskType.black);
      final responseStream = await requests.send();

      final response = await http.Response.fromStream(responseStream);

      EasyLoading.dismiss(animation: true);
      debugPrint(response.toString());
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final tadaResponse = IssueLeaveResponse.fromJson(responseData);
        showToast("Tada has been updated");
        Get.back();
        return "Loaded";
      } else {
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    }catch(e){
      showToast(e.toString());
      return "Failed";
    }
  }

  void removeItem(int index) {
    fileList.removeAt(index);
  }

  Future<void> removeAttachment(int id,int index) async {
    Preferences preferences = Preferences();
    var uri =
    Uri.parse(await preferences.getAppUrl()+Constant.TADA_DELETE_ATTACHMENT_URL + "/$id");

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      EasyLoading.show(status: translate('loader.loading'),maskType: EasyLoadingMaskType.black);
      final response = await http.get(
        uri,
        headers: headers,
      );

      EasyLoading.dismiss(animation: true);
      debugPrint(response.body.toString());

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final tadaResponse = IssueLeaveResponse.fromJson(responseData);

        attachmentList.removeAt(index);

      } else {
        EasyLoading.dismiss(animation: true);
        var errorMessage = responseData['message'];
        print(errorMessage);
        throw errorMessage;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  void onInit() {
    getTadaDetail();
    id = Get.arguments['tadaId'];
    super.onInit();
  }

  Future<void> launchUrls(String _url) async {
    if (!await launchUrl(Uri.parse(_url),mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> launchFile(String _url) async {
    if (!await launchUrl(Uri.file(_url))) {
      throw Exception('Could not launch $_url');
    }
  }
}
