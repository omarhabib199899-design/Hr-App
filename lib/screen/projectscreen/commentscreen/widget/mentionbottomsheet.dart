import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnattendance/model/member.dart';
import 'package:cnattendance/screen/projectscreen/commentscreen/commentscreencontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class MentionBottomSheet extends StatelessWidget {
  List<Member> members;

  MentionBottomSheet(this.members);

  final model = Get.put(CommentScreenController());
  @override
  Widget build(BuildContext context) {
    var filteredList = <Member>[];
    for(var member in members){
      if(!model.mentionList.contains(member)){
        filteredList.add(member);
      }
    }
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: RadialDecoration(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  translate('comment_list_screen.team'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  itemCount: filteredList.length,
                  itemBuilder: (ctx, i) =>
                      Padding(padding: EdgeInsets.all(5), child: InkWell(onTap: () {
                        model.mentionList.add(filteredList[i]);
                        Get.back();
                      },child: teamCard(filteredList[i])))),
            ],
          ),
        ),
      ),
    );
  }

  Widget teamCard(Member member) {
    return Card(
      shape: ButtonBorder(),
      elevation: 0,
      color: Colors.white10,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                imageUrl:member.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      member.name,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text(member.post,
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
