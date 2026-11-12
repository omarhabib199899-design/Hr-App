import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:text_sizer_plus/text_sizer_plus.dart';

class BirthdayCard extends StatelessWidget {
  final int id;
  final String name;
  final String post;
  final String image;

  BirthdayCard({
    required this.id,
    required this.name,
    required this.post,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: ButtonBorder(),
      elevation: 0,
      color: Colors.white12,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: ClipOval(child: Image.network(image,width: 60,height: 60,)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      softWrap: true,
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      parse(post).body!.text,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
