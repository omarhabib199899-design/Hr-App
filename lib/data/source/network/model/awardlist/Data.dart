import 'package:cnattendance/data/source/network/model/awardlist/AllAward.dart';
import 'package:cnattendance/data/source/network/model/awardlist/RecentAward.dart';

class Data {
  List<AllAward> all_awards;
  RecentAward? recent_award;
  int total_awards;

  Data(
      {required this.all_awards,
      this.recent_award,
      required this.total_awards});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      all_awards: (json['all_awards'] as List)
          .map((i) => AllAward.fromJson(i))
          .toList(),
      recent_award: json["recent_award"] != null
          ? RecentAward.fromJson(json['recent_award'])
          : null,
      total_awards: json['total_awards'],
    );
  }
}
