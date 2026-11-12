import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/screen/profile/NotificationScreen.dart';
import 'package:cnattendance/screen/profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';

import '../provider/dashboardprovider.dart';
import 'customalertdialog.dart';

class HeaderProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HeaderState();
}

class HeaderState extends State<HeaderProfile> {
  Future<void> sendLocation() async {
    try {
      setState(() {
        EasyLoading.show(
            status: translate('loader.requesting'),
            maskType: EasyLoadingMaskType.black);
      });
      final response = await context.read<DashboardProvider>().onSendLocation();
      setState(() {
        EasyLoading.dismiss(animation: true);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(response),
            );
          },
        );
      });
    } catch (e) {
      setState(() {
        EasyLoading.dismiss(animation: true);
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog(e.toString()),
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PrefProvider>(context);
    final isEnabledLocation =
        context.watch<DashboardProvider>().isLocationEnabled;
    return GestureDetector(
      onTap: () {
        pushScreen(context,
            screen: ProfileScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.fade);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                imageUrl: provider.avatar,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Image.asset(
                    'assets/images/dummy_avatar.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate('home_screen.hello_there'),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    provider.fullname,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    provider.userName,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            Spacer(),
            if (isEnabledLocation)
              Tooltip(
                message: "Send Location",
                child: IconButton(
                    onPressed: () {
                      sendLocation();
                    },
                    icon: Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                    )),
              ),
            Tooltip(
              message: "Notifications",
              child: IconButton(
                  onPressed: () {
                    pushScreen(context,
                        screen: NotificationScreen(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.fade);
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
