import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:cnattendance/model/chat.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http_interceptor_plus/http_interceptor_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  var host = "".obs;
  var hostUsername = "";
  var hostImage = "";
  var convoId = "";
  final chatController = TextEditingController();
  final scrollController = ScrollController();

  var chatList = <Chat>[].obs;

  Preferences pref = Preferences();

  @override
  Future<void> onReady() async {
    host.value = Get.arguments["name"];
    hostImage = Get.arguments["avatar"];
    hostUsername = Get.arguments["username"];

    setConversationDetail(hostUsername, await pref.getUsername());
    super.onReady();
  }

  void setConversationDetail(String user1, String user2) {
    int result = user1.compareTo(user2);
    if (result < 0) {
      convoId = user1 + user2;
    } else if (result > 0) {
      convoId = user2 + user1;
    } else {
      convoId = user1 + user2;
    }

    FirebaseFirestore.instance.collection('conversations').doc(convoId).set({
      'id': convoId,
      'user1': user1,
      'user2': user2,
    });

    listenChat();
  }

  Future<void> sendMessage(String message) async {
    var fcm = await FirebaseMessaging.instance.getToken();
    print(fcm);

    chatController.clear();
    FirebaseFirestore.instance.collection('messages').doc(Uuid().v4()).set({
      "id": convoId,
      "date": DateTime.now(),
      "message": base64.encode(utf8.encode(message)),
      "sender": await pref.getUsername(),
      "reciever": hostUsername
    });

    sendPushNotifiation(await pref.getUsername(), message,
        convoId, "chat", "", hostUsername);
  }

  Future<void> listenChat() async {
    final docRef = await FirebaseFirestore.instance
        .collection("messages")
        .orderBy("date", descending: true)
        .where("id", isEqualTo: convoId)
        .snapshots();

    docRef.listen(
      (event) {
        print("triiger");
        final chatDb = <Chat>[];
        for (var item in event.docs) {
          Timestamp firebaseTimestamp = item["date"];
          chatDb.add(Chat(
              item["id"],
              utf8.decode(base64.decode(item["message"])),
              item["sender"],
              item["reciever"],
              firebaseTimestamp.toDate()));
        }

        chatList.value = chatDb.reversed.toList();

        Future.delayed(Duration(milliseconds: 500)).then((_) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastOutSlowIn,
          );
        });
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  Future<void> sendPushNotifiation(
      String title,
      String message,
      String converstion_id,
      String type,
      String project_id,
      String username) async {

    Preferences preferences = Preferences();

    var uri = Uri.parse("${await preferences.getAppUrl()}${Constant.SEND_PUSH_NOTIFICATION}");

    String token = await preferences.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    var users = <String>[];
    users.add(username);

    final http.Client client = LoggingMiddleware(http.Client());

    final response = await client.post(uri, headers: headers, body: {
      "title": title,
      "message": message,
      "conversation_id": converstion_id,
      "type": type,
      "project_id": project_id,
      "usernames": jsonEncode(users),
    });

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      var errorMessage = responseData['message'];
      print(errorMessage);
      throw errorMessage;
    }
  }
}
