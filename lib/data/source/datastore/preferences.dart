import 'package:cnattendance/data/source/network/model/login/User.dart';
import 'package:cnattendance/data/source/network/model/dashboard/User.dart'
    as DashboardUser;
import 'package:cnattendance/data/source/network/model/login/Login.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences with ChangeNotifier {
  final String USER_ID = "user_id";
  final String USER_AVATAR = "user_avatar";
  final String USER_TOKEN = "user_token";
  final String USER_EMAIL = "user_email";
  final String USER_NAME = "user_name";
  final String USER_FULLNAME = "user_fullname";
  final String USER_AUTH = "user_auth";
  final String WORKSPACE = "workspace_type";
  final String APP_IN_ENGLISH = "eng_date";
  final String ATTENDANCE_TYPE = "attendance_type";
  final String APP_URL = "app_url";
  final String HARD_RESET_APP = "HARD_RESET";
  final String BIRTHDAY_WISHED = "BIRTHDAY_WISHED";
  final String SHOW_NFC = "SHOW_NFC";
  final String SHOWNOTE = "SHOW_NOTE";
  final String SHOWLOCATION = "SHOWLOCATION";

  //feature control
  final String PROJECT_MANAGEMENT = "project-management";
  final String MEETING = "meeting";
  final String TADA = "tada";
  final String PAYROLL_MANGEMENT = "payroll-management";
  final String ADVANCE_SALARY = "advance-salary";
  final String SUPPORT = "support";
  final String DARK_MODE = "dark-mode";
  final String NFC_QR = "nfc-qr";
  final String AWARD = "award";
  final String TRAINING = "training";
  final String LOAN = "loan";
  final String EVENT = "event";
  final String COMPLAIN = "COMPLAIN";
  final String WARNING = "WARNING";
  final String RESIGNATION = "RESIGNATION";
  final String ASSETS = "ASSETS";

  Future<bool> saveUser(Login data) async {
    // Obtain shared preferences.
    User user = data.user;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(USER_TOKEN, data.tokens);
    await prefs.setInt(USER_ID, user.id);
    await prefs.setString(USER_AVATAR, user.avatar);
    await prefs.setString(USER_EMAIL, user.email);
    await prefs.setString(USER_NAME, user.username);
    await prefs.setString(USER_FULLNAME, user.name);
    await prefs.setString(WORKSPACE, user.workspace_type);

    notifyListeners();

    return true;
  }

  Future<bool> saveUserDashboard(DashboardUser.User user) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(USER_ID, user.id);
    await prefs.setString(USER_AVATAR, user.avatar);
    await prefs.setString(USER_EMAIL, user.email);
    await prefs.setString(USER_NAME, user.username);
    await prefs.setString(USER_FULLNAME, user.name);
    await prefs.setString(WORKSPACE, user.workspace_type);

    notifyListeners();

    return true;
  }

  Future<void> setFeatures(Map<String, String> features) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        PROJECT_MANAGEMENT, features["project-management"] ?? "0");
    await prefs.setString(MEETING, features["meeting"] ?? "0");
    await prefs.setString(TADA, features["tada"] ?? "0");
    await prefs.setString(
        PAYROLL_MANGEMENT, features["payroll-management"] ?? "0");
    await prefs.setString(ADVANCE_SALARY, features["advance-salary"] ?? "0");
    await prefs.setString(SUPPORT, features["support"] ?? "0");
    await prefs.setString(DARK_MODE, features["dark-mode"] ?? "0");
    await prefs.setString(NFC_QR, features["nfc-qr"] ?? "0");
    await prefs.setString(AWARD, features["award"] ?? "0");
    await prefs.setString(TRAINING, features["training"] ?? "0");
    await prefs.setString(LOAN, features["loan"] ?? "0");
    await prefs.setString(EVENT, features["event"] ?? "0");
    await prefs.setString(COMPLAIN, features["complaint"] ?? "0");
    await prefs.setString(WARNING, features["warning"] ?? "0");
    await prefs.setString(RESIGNATION, features["resignation"] ?? "0");
    await prefs.setString(ASSETS, features["assets"] ?? "0");

    notifyListeners();
  }

  Future<Map<String, String>> getFeatures() async {
    Map<String, String> features = <String, String>{};
    final prefs = await SharedPreferences.getInstance();

    features["project-management"] =
        await prefs.getString(PROJECT_MANAGEMENT) ?? "1";
    features["meeting"] = await prefs.getString(MEETING) ?? "1";
    features["tada"] = await prefs.getString(TADA) ?? "1";
    features["payroll-management"] =
        await prefs.getString(PAYROLL_MANGEMENT) ?? "1";
    features["advance-salary"] = await prefs.getString(ADVANCE_SALARY) ?? "1";
    features["support"] = await prefs.getString(SUPPORT) ?? "1";
    features["dark-mode"] = await prefs.getString(DARK_MODE) ?? "1";
    features["nfc-qr"] = await prefs.getString(NFC_QR) ?? "1";
    features["award"] = await prefs.getString(AWARD) ?? "1";
    features["training"] = await prefs.getString(TRAINING) ?? "1";
    features["loan"] = await prefs.getString(LOAN) ?? "1";
    features["event"] = await prefs.getString(EVENT) ?? "1";
    features["complaint"] = await prefs.getString(COMPLAIN) ?? "1";
    features["warning"] = await prefs.getString(WARNING) ?? "1";
    features["resignation"] = await prefs.getString(RESIGNATION) ?? "1";
    features["assets"] = await prefs.getString(ASSETS) ?? "1";

    return features;
  }

  void saveBasicUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(USER_ID, user.id);
    await prefs.setString(USER_AVATAR, user.avatar);
    await prefs.setString(USER_EMAIL, user.email);
    await prefs.setString(USER_NAME, user.username);
    await prefs.setString(USER_FULLNAME, user.name);

    notifyListeners();
  }

  Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(USER_ID, 0);
    await prefs.setString(USER_TOKEN, '');
    await prefs.setString(USER_AVATAR, '');
    await prefs.setString(USER_EMAIL, '');
    await prefs.setString(USER_NAME, '');
    await prefs.setString(USER_FULLNAME, '');
    await prefs.setBool(USER_AUTH, false);
    await prefs.setBool(APP_IN_ENGLISH, true);
    await prefs.setString(WORKSPACE, "1");
    await prefs.setString(ATTENDANCE_TYPE, "Default");
    await prefs.setString(APP_URL, "");

    notifyListeners();
  }

  void saveUserAuth(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(USER_AUTH, value);
  }

  void saveShowNfc(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHOW_NFC, value);
  }

  void saveHardReset(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(HARD_RESET_APP, value);
  }

  void saveAppUrl(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(APP_URL, value);
  }

  void saveAttendanceType(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ATTENDANCE_TYPE, value);
    notifyListeners();
  }

  void saveAppEng(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(APP_IN_ENGLISH, value);
  }

  void saveBirthdayWished(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(BIRTHDAY_WISHED, value);
  }

  void saveNote(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHOWNOTE, value);
  }

  void saveEmployeeLocation(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHOWLOCATION, value);
  }

  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    return User(
        id: prefs.getInt(USER_ID) ?? 0,
        name: prefs.getString(USER_FULLNAME) ?? "",
        email: prefs.getString(USER_EMAIL) ?? "",
        username: prefs.getString(USER_NAME) ?? "",
        avatar: prefs.getString(USER_AVATAR) ?? "",
        workspace_type: prefs.getString(WORKSPACE) ?? "1");
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(USER_TOKEN) ?? "";
  }

  Future<bool> getNote() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(SHOWNOTE) ?? false;
  }

  Future<bool> getEnableLocation() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(SHOWLOCATION) ?? false;
  }

  Future<String> getAttendanceType() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(ATTENDANCE_TYPE) ?? "Default";
  }

  Future<bool> getUserAuth() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(USER_AUTH) ?? false;
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(USER_ID) ?? 0;
  }

  Future<bool> getShowNfc() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(SHOW_NFC) ?? true;
  }

  Future<bool> getBirthdayWished() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(BIRTHDAY_WISHED) ?? false;
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_NAME) ?? "";
  }

  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_EMAIL) ?? "";
  }

  Future<String> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_AVATAR) ?? "";
  }

  Future<String> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_FULLNAME) ?? "";
  }

  Future<String> getWorkSpace() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(WORKSPACE) ?? "1";
  }

  Future<bool> getEnglishDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(APP_IN_ENGLISH) ?? true;
  }

  Future<String> getAppUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(APP_URL) ?? Constant.appUrl;
  }

  Future<bool> getHardReset() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(HARD_RESET_APP) ?? true;
  }
}
