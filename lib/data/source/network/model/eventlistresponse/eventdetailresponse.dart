import 'dart:convert';

EventDetailRepsonse eventListRepsonseFromMap(String str) =>
    EventDetailRepsonse.fromMap(json.decode(str));

class EventDetailRepsonse {
  final EventApi data;
  final bool status;
  final int statusCode;

  EventDetailRepsonse({
    required this.data,
    required this.status,
    required this.statusCode,
  });

  factory EventDetailRepsonse.fromMap(Map<String, dynamic> json) =>
      EventDetailRepsonse(
        data: EventApi.fromMap(json["data"]),
        status: json["status"],
        statusCode: json["status_code"],
      );
}

class EventApi {
  final int id;
  final String title;
  final String description;
  final String location;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String image;
  final String createdBy;
  final Creator? creator;
  final List<EventUser> eventUsers;
  final List<EventDepartment> eventDepartments;

  EventApi({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.image,
    required this.createdBy,
    required this.creator,
    required this.eventUsers,
    required this.eventDepartments,
  });

  factory EventApi.fromMap(Map<String, dynamic> json) => EventApi(
        id: json["id"],
        title: json["title"].toString(),
        description: json["description"].toString(),
        location: json["location"].toString(),
        startDate: json["start_date"].toString(),
        endDate: json["end_date"].toString(),
        startTime: json["start_time"].toString(),
        endTime: json["end_time"].toString(),
        image: json["image"].toString(),
        createdBy: json["created_by"].toString(),
        creator: Creator.fromMap(json["creator"]),
        eventUsers: List<EventUser>.from(
            json["event_users"].map((x) => EventUser.fromMap(x))),
        eventDepartments: List<EventDepartment>.from(
            json["event_departments"].map((x) => EventDepartment.fromMap(x))),
      );
}

class Creator {
  final int id;
  final String name;
  final String email;
  final String username;
  final String phone;
  final String dob;
  final String gender;
  final String branch;
  final String department;
  final String post;
  final String avatar;
  final String onlineStatus;

  Creator({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.phone,
    required this.dob,
    required this.gender,
    required this.branch,
    required this.department,
    required this.post,
    required this.avatar,
    required this.onlineStatus,
  });

  factory Creator.fromMap(Map<String, dynamic> json) => Creator(
        id: json["id"],
        name: json["name"].toString(),
        email: json["email"].toString(),
        username: json["username"].toString(),
        phone: json["phone"].toString(),
        dob: json["dob"].toString(),
        gender: json["gender"].toString(),
        branch: json["branch"].toString(),
        department: json["department"].toString(),
        post: json["post"].toString(),
        avatar: json["avatar"].toString(),
        onlineStatus: json["online_status"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "username": username,
        "phone": phone,
        "dob": dob,
        "gender": gender,
        "branch": branch,
        "department": department,
        "post": post,
        "avatar": avatar,
        "online_status": onlineStatus,
      };
}

class EventDepartment {
  final String id;
  final String name;
  final String isActive;
  final String departmentHead;

  EventDepartment({
    required this.id,
    required this.name,
    required this.isActive,
    required this.departmentHead,
  });

  factory EventDepartment.fromMap(Map<String, dynamic> json) => EventDepartment(
        id: json["id"].toString(),
        name: json["name"].toString(),
        isActive: json["is_active"].toString(),
        departmentHead: json["department_head"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "is_active": isActive,
        "department_head": departmentHead,
      };
}

class EventUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String onlineStatus;
  final String avatar;
  final String post;

  EventUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.onlineStatus,
    required this.avatar,
    required this.post,
  });

  factory EventUser.fromMap(Map<String, dynamic> json) => EventUser(
        id: json["id"].toString(),
        name: json["name"].toString(),
        email: json["email"].toString(),
        phone: json["phone"].toString(),
        onlineStatus: json["online_status"].toString(),
        avatar: json["avatar"].toString(),
        post: json["post"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "online_status": onlineStatus,
        "avatar": avatar,
        "post": post,
      };
}
