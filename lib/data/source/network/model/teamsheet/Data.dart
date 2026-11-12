import 'package:cnattendance/data/source/network/model/teamsheet/Branch.dart';
import 'package:cnattendance/data/source/network/model/teamsheet/TeamSheet.dart';

class Data {
  Data({
    required this.companyDetail,
    required this.branch,
  });

  factory Data.fromJson(dynamic json) {
    return Data(
        companyDetail: TeamSheet.fromJson(json['companyDetail']),
        branch:
            List<Branch>.from(json['branches'].map((x) => Branch.fromJson(x))));
  }

  TeamSheet companyDetail;
  List<Branch> branch;
}
