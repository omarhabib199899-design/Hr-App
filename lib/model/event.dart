import 'package:cnattendance/data/source/network/model/eventdetailresponse/eventlistresponse.dart';

class Event {
  int id;
  String title;
  String description;
  String location;
  String startdate;
  String endDate;
  String startTime;
  String endTime;
  String image;
  String createdBy;
  dynamic creator;
  List<dynamic> eventUsers;
  List<dynamic> eventDepartments;

  Event(
      this.id,
      this.title,
      this.description,
      this.location,
      this.startdate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.image,
      this.createdBy,
      this.creator,
      this.eventUsers,
      this.eventDepartments);
}
