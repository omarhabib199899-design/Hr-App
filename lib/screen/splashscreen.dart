import 'dart:async';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/screen/auth/login_screen.dart';
import 'package:cnattendance/screen/dashboard/dashboard_screen.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          Preferences preferences = Preferences();
          if (await preferences.getHardReset()) {
            preferences.clearPrefs();
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            preferences.saveHardReset(false);
          } else {
            if (await preferences.getToken() == '') {
              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            } else {
              Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
            }
          }
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RadialDecoration(),
      child: Center(
          child: Image.asset(
        "assets/icons/logo_bnw.png",
        width: 120,
        height: 120,
      )),
    );
  }
}
