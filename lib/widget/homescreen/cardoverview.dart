import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';

class CardOverView extends StatelessWidget {
  final String type;
  final String value;
  final dynamic icon;
  VoidCallback callback;

  CardOverView(
      {required this.type,
      required this.value,
      required this.icon,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 20,
      child: GestureDetector(
        onTap: callback,
        child: Card(
          shape: ButtonBorder(),
          elevation: 0,
          color: Colors.white12,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon is String
                        ? Image.asset(
                            icon,
                            width: 30,
                            height: 30,
                            color: Colors.white,
                          )
                        : Icon(
                            icon,
                            size: 30,
                            color: Colors.white,
                          ),
                    Text(
                      type,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                Card(
                  margin: EdgeInsets.zero,
                  color: Colors.white12,
                  shape: CircleBorder(),
                  elevation: 0,
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
