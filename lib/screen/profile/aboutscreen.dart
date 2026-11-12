import 'package:cnattendance/provider/aboutcontroller.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  final String title;

  AboutScreen(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Get.put(AboutController());
    model.getContent(title);
    return Obx(
      () => Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(model.content['title']!),
            elevation: 0,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Visibility(
                  visible: model.isLoading.value ? false : true,
                  child: Html(
                    style: {
                      "body":
                          Style(color: Colors.white, fontSize: FontSize.medium)
                    },
                    data: model.content['description']!,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
