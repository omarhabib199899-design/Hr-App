import 'package:cnattendance/provider/profileprovider.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/cartTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class BasicDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Card(
        shape: ButtonBorder(),
        color: Colors.white10,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTitle(translate('profile_screen.phone_number'), profile.phone),
              CardTitle(translate('profile_screen.dob'), profile.dob),
              CardTitle(translate('profile_screen.gender'), profile.gender),
              CardTitle(translate('profile_screen.address'), profile.address),
            ],
          ),
        ),
      ),
    );
  }
}
