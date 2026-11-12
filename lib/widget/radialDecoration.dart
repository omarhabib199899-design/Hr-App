import 'package:cnattendance/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

BoxDecoration RadialDecoration() {
  return BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/back.png"),
          fit: BoxFit.fitHeight,
          opacity: .7,
          alignment: Alignment.center),
      gradient: RadialGradient(colors: [
        HexColor(getAppTheme()? appTheme : "#000000"),
        HexColor(getAppTheme()? appAlternateTheme : "#000000"),
      ]));
}
