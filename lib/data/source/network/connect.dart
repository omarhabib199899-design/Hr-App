import 'dart:convert';

import 'package:cnattendance/data/source/datastore/preferences.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor_plus/http_interceptor_plus.dart';

class Connect {
  Future<http.Response> getResponse(
      String url, Map<String, String> headers) async {
    Preferences preferences = Preferences();
    final storage = GetStorage();
    String language = storage.read("language") ?? "en";

    headers.addEntries({
      "langauge": language,
    }.entries);

    final http.Client client = LoggingMiddleware(http.Client());
    var uri = Uri.parse(await preferences.getAppUrl() + url);
    return client.get(uri, headers: headers);
  }

  Future<http.Response> postResponse(String url, Map<String, String> headers,
      Map<String, dynamic> body) async {
    Preferences preferences = Preferences();
    final storage = GetStorage();
    String language = storage.read("language") ?? "en";

    headers.addEntries({
      "langauge": language,
    }.entries);

    final http.Client client = LoggingMiddleware(http.Client());
    var uri = Uri.parse(await preferences.getAppUrl() + url);
    return client.post(uri, headers: headers, body: body);
  }

  Future<http.Response> postResponseRaw(String url, Map<String, String> headers,
      Map<String, dynamic> body) async {
    Preferences preferences = Preferences();
    final storage = GetStorage();
    String language = storage.read("language") ?? "en";

    headers.addEntries({
      "langauge": language,
    }.entries);

    final http.Client client = LoggingMiddleware(http.Client());
    var uri = Uri.parse(await preferences.getAppUrl() + url);
    return client.post(uri, headers: headers, body: jsonEncode(body));
  }
}
