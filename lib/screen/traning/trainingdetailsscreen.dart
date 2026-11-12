import 'package:cnattendance/data/source/network/model/trainingresponse/trainingresponse.dart';
import 'package:cnattendance/screen/traning/trainingdetailcontroller.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

class TrainingDetailScreen extends StatelessWidget {
  final model = Get.put(TrainingDetailController());
  final trainingStatus = "In Progress";

  @override
  Widget build(BuildContext context) {
    final training = Get.arguments["training"] as Training;
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("Training Detail"),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        training.trainingType,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Start-End Date",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Row(
                                children: [
                                  Text(training.startDate,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  if (training.endDate.isNotEmpty)
                                    Text(" - ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                  if (training.endDate.isNotEmpty)
                                    SizedBox(
                                      width: 5,
                                    ),
                                  if (training.endDate.isNotEmpty)
                                    Text(training.endDate,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          child: VerticalDivider(
                            width: 1,
                            color: Colors.white54,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Start-End Time",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(training.startTime,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12)),
                                  if (training.endTime.isNotEmpty)
                                    Text(" - ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                  if (training.endTime.isNotEmpty)
                                    SizedBox(
                                      width: 5,
                                    ),
                                  if (training.endTime.isNotEmpty)
                                    Text(training.endTime,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Venue",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(training.venue,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          height: 30,
                          child: VerticalDivider(
                            width: 1,
                            color: Colors.white54,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Cost",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(training.cost,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Card(
                  elevation: 0,
                  color: Colors.white24,
                  margin: EdgeInsets.zero,
                  shape: ButtonBorder(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ReadMoreText(
                          training.description,
                          trimLines: 15,
                          colorClickableText: Colors.blue,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Show more',
                          trimExpandedText: ' Show less',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                          lessStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          moreStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Card(
                  elevation: 0,
                  color: Colors.white24,
                  margin: EdgeInsets.zero,
                  shape: ButtonBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Trainer(s)",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              "Expertise",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: training.trainer.asMap().entries.map((entry) {
                                int index = entry.key; // Get the index
                                var e = entry.value; // Get the trainer object

                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${e.name ?? ''}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            "${e.expertise ?? ''}",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if(index != training.trainer.length - 1)
                                    Divider(color: Colors.white30,)
                                  ],
                                );
                              }).toList()),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Card(
                  elevation: 0,
                  color: Colors.white24,
                  margin: EdgeInsets.zero,
                  shape: ButtonBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Participant(s)",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: training.employees
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                var e = entry.value;
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${index + 1}.",
                                            // Display index
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 15,
                                          child: Text(
                                            "${e.name ?? ''}",
                                            // Display index
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if(index + 1 != training.employees.length)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Divider(
                                        height: 1,
                                        indent: 2,
                                        endIndent: 2,
                                        color: Colors.white12,
                                      ),
                                    ),
                                    SizedBox(height: 5,)
                                  ],
                                );
                              }).toList(),
                            )),
                      ],
                    ),
                  ),
                ),
                if (training.certificate.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Certificate",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          /*Spacer(),
                        GestureDetector(
                            onTap: () async {
                              final value = await model
                                  .checkAndRequestStoragePermission();

                              if (value) {
                                model.saveFileLocally(training.certificate);
                              }
                              print(value);
                            },
                            child: Icon(
                              Icons.download,
                              color: Colors.white,
                            ))*/
                        ],
                      ),
                      if (training.certificate.isNotEmpty)
                        SizedBox(
                          height: 10,
                        ),
                      if (training.certificate.isNotEmpty)
                        Image.network(
                          training.certificate,
                          height: 300,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
