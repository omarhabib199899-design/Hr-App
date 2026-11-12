import 'package:cnattendance/provider/profileprovider.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/cartTitle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class CompanyDetail extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final profile  = Provider.of<ProfileProvider>(context).profile;
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
              CardTitle(translate('profile_screen.job_position'), profile.post),
              CardTitle(translate('profile_screen.branch'), profile.branch),
              CardTitle(translate('profile_screen.department'), profile.department),
              CardTitle(translate('profile_screen.employment_type'), profile.employment_type),
              CardTitle(translate('profile_screen.joined_date'), profile.joinedDate),
            ],
          ),
        ),
      ),
    );
  }

}