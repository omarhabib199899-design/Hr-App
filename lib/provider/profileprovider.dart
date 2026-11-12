import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/data/source/network/model/profile/Profile.dart';
import 'package:cnattendance/data/source/network/model/profile/Profileresponse.dart';
import 'package:cnattendance/model/profile.dart' as up;
import 'package:cnattendance/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class ProfileProvider with ChangeNotifier {
  final up.Profile _profile = up.Profile(
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
  );

  up.Profile get profile {
    return _profile;
  }

  Future<bool> isAd() async {
    Preferences preferences = Preferences();
    final value = await preferences.getEnglishDate();

    return value;
  }

  Future<Profileresponse> getProfile() async {
    Preferences preferences = Preferences();
    var uri = Uri.parse(await preferences.getAppUrl() + Constant.PROFILE_URL);

    checkValueInPref(preferences);

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData.toString());

        final responseJson = Profileresponse.fromJson(responseData);
        parseUser(responseJson.data);

        return responseJson;
      } else {
        var errorMessage = responseData['message'];
        throw errorMessage;
      }
    } catch (error) {
      throw unknownError(error);
    }
  }

  Future<void> parseUser(Profile profile) async {
    Preferences preferences = Preferences();
    final isAD = await preferences.getEnglishDate();

    _profile.id = profile.id;
    _profile.avatar = profile.avatar;
    _profile.name = profile.name;
    _profile.username = profile.username;
    _profile.email = profile.email;
    _profile.post = profile.post;
    _profile.phone = profile.phone;
    _profile.gender = profile.gender;
    _profile.address = profile.address;
    _profile.bankName = profile.bankName;
    _profile.bankNumber = profile.bankAccountNo;
    _profile.department = profile.department;
    _profile.branch = profile.branch;
    _profile.bank_type = profile.bankAccountType;
    _profile.employment_type = profile.employmentType;

    _profile.dob = isAD
        ? profile.dob
        : NepaliDateFormat("yyyy-MM-dd").parseAndFormat(DateFormat("yyyy-MM-dd")
            .parse(profile.dob)
            .toNepaliDateTime()
            .toString());

    _profile.joinedDate = isAD
        ? profile.joiningDate
        : NepaliDateFormat("yyyy-MM-dd").parseAndFormat(DateFormat("yyyy-MM-dd")
            .parse(profile.joiningDate)
            .toNepaliDateTime()
            .toString());

    notifyListeners();
  }

  void checkValueInPref(Preferences preferences) async {
    final user = await preferences.getUser();
    _profile.name = user.name;
    _profile.username = user.username;
    _profile.email = user.email;
    _profile.avatar = user.avatar;
    notifyListeners();
  }

  Future<Profileresponse> updateProfile(
      String name,
      String email,
      String address,
      String dob,
      String gender,
      String phone,
      File avatar) async {
    Preferences preferences = Preferences();
    var uri =
        Uri.parse(await preferences.getAppUrl() + Constant.EDIT_PROFILE_URL);

    String token = await preferences.getToken();

    var formattedDob = "";
    if (dob != "") {
      formattedDob = (await isAd())
          ? dob
          : DateFormat("yyyy-MM-dd")
              .format(NepaliDateTime.parse(dob).toDateTime());
    }

    dynamic response;
    try {
      if (avatar.path != '') {
        var requests = http.MultipartRequest('POST', uri);

        Map<String, String> headers = {
          'Accept': 'application/json; charset=UTF-8',
          'Content-type': 'multipart/form-data',
          'Authorization': 'Bearer $token'
        };

        final img.Image capturedImage =
            img.decodeImage(await File(avatar.path).readAsBytes())!;
        final img.Image orientedImage = img.bakeOrientation(capturedImage);
        var file =
            await File(avatar.path).writeAsBytes(img.encodeJpg(orientedImage));

        requests.files.add(
          http.MultipartFile(
            'avatar',
            file.readAsBytes().asStream(),
            await avatar.length(),
            filename: Random().hashCode.toString(),
          ),
        );

        requests.headers.addAll(headers);

        response = await requests.send();

        await response.stream.transform(utf8.decoder).listen((value) {
          final responseJson = Profileresponse.fromJson(json.decode(value));
          if (responseJson.statusCode == 200) {
            parseUser(responseJson.data);
            return responseJson;
          } else {
            var errorMessage = responseJson.message;
            throw errorMessage;
          }
        });

        return Future.error('error');
      } else {
        Map<String, String> headers = {
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        };

        response = await http.post(uri, headers: headers, body: {
          'name': name,
          'email': email,
          'address': address,
          'dob': formattedDob,
          'gender': gender,
          'phone': phone,
        });

        final responseData = json.decode(response.body);
        if (response.statusCode == 200) {
          debugPrint(responseData.toString());
          final responseJson = Profileresponse.fromJson(responseData);

          parseUser(responseJson.data);
          return responseJson;
        } else {
          var errorMessage = responseData['message'];
          throw errorMessage;
        }
      }
    } catch (error) {
      throw unknownError(error);
    }
  }
}
