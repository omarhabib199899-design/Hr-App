import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:text_sizer_plus/text_sizer_plus.dart';

class Holidaycard extends StatelessWidget {
  final int id;
  final String name;
  final String month;
  final String day;
  final String desc;
  final bool isPublicHoliday;

  Holidaycard({
    required this.id,
    required this.name,
    required this.month,
    required this.day,
    required this.desc,
    required this.isPublicHoliday,
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
              padding: const EdgeInsets.all(5),
              child: Card(
                shape: ButtonBorder(),
                elevation: 0,
                color: isPublicHoliday ? Colors.red : Colors.blueAccent,
                child: Container(
                  width: 60,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextSizerPlus(month,
                            maxLines: 1, style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
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
                      parse(desc).body!.text,
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
