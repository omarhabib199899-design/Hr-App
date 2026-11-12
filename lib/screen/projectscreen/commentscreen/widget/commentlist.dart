import 'package:cnattendance/model/comment.dart';
import 'package:cnattendance/model/reply.dart';
import 'package:cnattendance/screen/profile/employeedetailscreen.dart';
import 'package:cnattendance/screen/projectscreen/commentscreen/commentscreencontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class CommentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CommentScreenController model = Get.find();

    return Obx(
      () => ListView.builder(
        controller: model.scrollController,
        itemCount: model.commentList.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Comment comment = model.commentList[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            elevation: 0,
            color: Colors.white12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        comment.avatar,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              comment.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(comment.createdAt,
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(children: [
                          for (var mention in comment.mentions) ...[
                            WidgetSpan(
                                child: Card(
                              color: Colors.white24,
                              elevation: 0,
                              child: InkWell(
                                onTap: () {
                                  Get.to(EmployeeDetailScreen(),
                                      arguments: {"employeeId": mention.userId.toString()});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  child: Text(
                                    "@" + mention.name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ))
                          ],
                          WidgetSpan(
                              child: Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                parse(comment.description).body!.text,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                        ])),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              model.user.value.id.toString() ==
                                      comment.userId.toString()
                                  ? GestureDetector(
                                      onTap: () {
                                        model.deleteComment(
                                            comment.id.toString());
                                      },
                                      child: Text(
                                        translate('comment_list_screen.delete'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  model.onReplyClicked(comment.id.toString());
                                },
                                child: Obx(
                                  () => Text(
                                    model.commentId.value.toString() !=
                                            comment.id.toString()
                                        ? translate('comment_list_screen.reply')
                                        : translate('comment_list_screen.cancel_reply'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListView.builder(
                          itemCount: comment.replies.length,
                          physics: NeverScrollableScrollPhysics(),
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Reply reply = comment.replies[index];
                            return Card(
                              elevation: 0,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          reply.avatar,
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                reply.name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(reply.createdAt,
                                                  style: TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text.rich(TextSpan(children: [
                                            for (var mention
                                                in reply.mentions) ...[
                                              WidgetSpan(
                                                  child: Card(
                                                color: Colors.white24,
                                                elevation: 0,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5,
                                                      vertical: 3),
                                                  child: Text(
                                                    "@" + mention.name,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ))
                                            ],
                                            WidgetSpan(
                                                child: Card(
                                              elevation: 0,
                                              color: Colors.transparent,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                child: Text(
                                                  reply.description,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ))
                                          ])),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            alignment: Alignment.centerRight,
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                model.user.value.id
                                                            .toString() ==
                                                        reply.userId.toString()
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          model.deleteReply(
                                                              reply.id
                                                                  .toString());
                                                        },
                                                        child: Text(
                                                          translate('comment_list_screen.delete'),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    : SizedBox.shrink(),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
