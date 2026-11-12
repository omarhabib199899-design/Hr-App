import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ShowLanguage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RadialDecoration(),
      height: 500,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    translate('common.select_language'),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Spacer(),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close,color: Colors.white,))
                ],
              ),
            ),
            languageCard("English", "🇺🇸", "en"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("русский", "🇷🇺", "ru"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("Española", "🇪🇸", "es"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("فارسی", "🇮🇷", "fa"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("हिंदी", "🇮🇳", "in"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("Turkish", "🇹🇷", "tr"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("Deutsch", "🇩🇪", "de"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("Français", "🇫🇷", "fr"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("नेपाली", "🇳🇵", "ne"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("عربي", "🇦🇪", "ar"),
            Divider(
              endIndent: 10,
              indent: 10,
              height: 1,
              color: Colors.white30,
            ),
            languageCard("Português", "🇵🇹", "pt"),
          ],
        ),
      ),
    );
  }

  Widget languageCard(String title, String flag, String language) {
    final storage = GetStorage();
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      dense: false,
      visualDensity: VisualDensity.compact,
      leading: Text(
        flag,
        style: TextStyle(fontSize: 20),
      ),
      trailing: language == storage.read("language")
          ? Icon(
        Icons.check,
        color: Colors.white,
      )
          : SizedBox.shrink(),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        final storage = GetStorage();
        storage.write("language", language);
        Get.updateLocale(Locale(language));
      },
    );
  }
  
}