
import 'package:cnattendance/screen/projectscreen/projectdetailscreen/widget/teambottomsheet.dart';
import 'package:cnattendance/provider/groupchatcontroller.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GroupChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Get.put(GroupChatController());
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleSpacing: 0,
          title: Obx(() => Row(
            children: [
              Text(model.host.value),
            ],
          )),
          actions: [IconButton(onPressed: () {
            Get.bottomSheet(TeamBottomSheet(model.leaders,model.members,),
                isDismissible: true,
                enableDrag: true,
                isScrollControlled: false,
                ignoreSafeArea: true);
          }, icon: Icon(Icons.person,color: Colors.white,))],
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    controller: model.scrollController,
                    primary: false,
                    shrinkWrap: true,
                    itemCount: model.chatList.length,
                    itemBuilder: (context, index) {
                      final message = model.chatList[index];
          
                      bool isSameDate = true;
                      final DateTime date = DateTime(message.dateTime.year,
                          message.dateTime.month, message.dateTime.day);
          
                      if (index == 0) {
                        isSameDate = false;
                      } else {
                        final DateTime prevDate = DateTime(
                            model.chatList[index - 1].dateTime.year,
                            model.chatList[index - 1].dateTime.month,
                            model.chatList[index - 1].dateTime.day);
                        isSameDate = date.isAtSameMomentAs(prevDate);
                      }
          
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                isSameDate
                                    ? SizedBox.shrink()
                                    : Text(
                                        DateFormat("MMM dd yyyy")
                                            .format(message.dateTime),
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                      ),
                                Card(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          message.sender != model.sender
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.end,
                                      children: [
                                        message.sender != model.sender
                                            ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            "@"+message.sender,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12,fontWeight: FontWeight.bold),
                                          ),
                                        ):SizedBox.shrink(),
                                        Row(
                                          children: [
                                            message.sender == model.sender
                                                ? SizedBox(
                                              width: 20,
                                            )
                                                : SizedBox.shrink(),
                                            message.sender == model.sender
                                                ? Spacer()
                                                : SizedBox.shrink(),
                                            Card(
                                              elevation: 0,
                                              color: Colors.white10,
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Text(
                                                  message.message,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            message.sender != model.sender
                                                ? SizedBox(
                                                    width: 20,
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Text(
                                            DateFormat("hh:mm a")
                                                .format(message.dateTime),
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Divider(color: Colors.white10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: TextFormField(
                          autofocus: false,
                          maxLines: 1,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          validator: (value) {
                            return null;
                          },
                          controller: model.chatController,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              hintText: translate('group_chat_screen.send_message'),
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0)),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.transparent),
                        )),
                        GestureDetector(
                          onTap: () {
                            if (model.chatController.text.isNotEmpty) {
                              model.sendMessage(model.chatController.text);
                            }
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
