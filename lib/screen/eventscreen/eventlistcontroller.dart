import 'package:cnattendance/model/event.dart';
import 'package:cnattendance/repositories/eventsrepository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class EventListController extends GetxController {
  final repository = EventsRepository();
  var upcomingEventList = <Event>[].obs;
  var pastEventList = <Event>[].obs;
  int upcomingPage = 1;
  int pastPage = 1;

  var toggleValue = 0.obs;

  Future<void> getEvents(bool isUpcoming) async {
    try {
      EasyLoading.show(
          status: translate('loader.loading'),
          maskType: EasyLoadingMaskType.black);
      var events = <Event>[];
      final response = await repository.getEvents(
          isUpcoming ? upcomingPage : pastPage, isUpcoming ? 1 : 0);
      EasyLoading.dismiss(animation: true);
      for (var event in response.data) {
        events.add(Event(
            event.id,
            event.title,
            event.description,
            event.location,
            event.startDate,
            event.endDate,
            event.startTime,
            event.endTime,
            event.image,
            event.createdBy,
            event.creator,
            event.eventUsers,
            event.eventDepartments));
      }

      if (isUpcoming) {
        if (upcomingPage == 1) {
          upcomingEventList.value = events;
        } else {
          upcomingEventList.addAll(events);
        }

        if (events.isNotEmpty) {
          upcomingPage++;
        }
      } else {
        if (upcomingPage == 1) {
          pastEventList.value = events;
        } else {
          pastEventList.addAll(events);
        }

        if (events.isNotEmpty) {
          pastPage++;
        }
      }
    } catch (e) {
      EasyLoading.dismiss(animation: true);
    }
  }

  @override
  void onReady() {
    upcomingPage = 1;
    pastPage = 1;
    getEvents(true);
    getEvents(false);
    super.onReady();
  }
}
