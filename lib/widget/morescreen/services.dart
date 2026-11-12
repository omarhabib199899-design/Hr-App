import 'dart:convert';
import 'dart:io';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/provider/morescreenprovider.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/customalertdialog.dart';
import 'package:cnattendance/widget/customnfcdialog.dart';
import 'package:cnattendance/widget/issueresignationsheet.dart';
import 'package:cnattendance/widget/log_out_bottom_sheet.dart';
import 'package:cnattendance/widget/showlanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';

class Services extends StatefulWidget {
  final String name;
  final IconData icon;
  final Widget route;
  final int control;

  Services(this.name, this.icon, this.route, {this.control = 0});

  @override
  State<StatefulWidget> createState() => ServicesState();
}

class ServicesState extends State<Services> {
  void onAddNfc(String identifier) async {
    try {
      setState(() {
        EasyLoading.show(
            status: translate('loader.requesting'), maskType: EasyLoadingMaskType.black);
      });

      final response =
          await context.read<MoreScreenProvider>().addNfcApi("nfc", identifier);
      if (!mounted) {
        return;
      }

      setState(() {
        EasyLoading.dismiss(animation: true);
        if (Platform.isAndroid) {
          Navigator.pop(context);
        }
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomAlertDialog("Nfc Added Successfully"),
            );
          },
        );
      });
    } catch (e) {
      setState(() {
        EasyLoading.dismiss(animation: true);

        if (Platform.isAndroid) {
          Navigator.pop(context);
        }

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
  Widget build(BuildContext context, [bool mounted = true]) {
    void showNfcScanner() {
      if (Platform.isAndroid) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Dialog(
              child: CustomNfcDialog(NFCMODE.add),
            );
          },
        );
      }

      if (Platform.isIOS) {
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            onAddNfc(base64.encode(utf8.encode(findKey(tag.data))));
            NfcManager.instance.stopSession();
          },
        );
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        children: [
          ListTile(
            dense: true,
            minLeadingWidth: 5,
            leading: Icon(
              widget.icon,
              color: Colors.white,
            ),
            title: Text(
              widget.name,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onTap: () async {
              if (widget.control == 1) {
                Preferences pref = Preferences();
                openBrowserTab(await pref.getAppUrl());
              } else if (widget.control == 2) {
                showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    builder: (context) {
                      return LogOutBottomSheet();
                    });
              } else if (widget.control == 3) {
                bool isAvailable = await NfcManager.instance.isAvailable();
                if (!isAvailable) {
                  showToast(
                      "NFC is not found. Please enable or try from another device.");
                  return;
                }
                showNfcScanner();
              } else if (widget.control == 4) {
                showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    builder: (context) {
                      return ShowLanguage();
                    });
              }else if (widget.control == 5) {
                showModalBottomSheet(
                    elevation: 0,
                    context: context,
                    useRootNavigator: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context)
                            .viewInsets,
                        child: IssueResignationSheet(),
                      );
                    });
              } else {
                pushScreen(context,
                    screen: widget.route,
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.fade);
              }
            },
            selected: true,
          ),
          const Divider(
            height: 1,
            color: Colors.white24,
            indent: 15,
            endIndent: 15,
          ),
        ],
      ),
    );
  }

  openBrowserTab(String url) async {
    await FlutterWebBrowser.openWebPage(
      url: url + "privacy",
      customTabsOptions: const CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        shareState: CustomTabsShareState.on,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.black,
        preferredControlTintColor: Colors.grey,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }
}
