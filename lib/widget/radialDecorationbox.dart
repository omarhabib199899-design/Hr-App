import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';

//041033
BoxDecoration RadialDecorationBox() {
  final box = GetStorage();
  return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: HexColor(box.read('theme')??true ? appAlternateTheme : "#252525"));
}
