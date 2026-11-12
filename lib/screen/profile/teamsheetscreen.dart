import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnattendance/data/source/network/model/teamsheet/Branch.dart';
import 'package:cnattendance/data/source/network/model/teamsheet/Department.dart';
import 'package:cnattendance/model/team.dart';
import 'package:cnattendance/provider/teamsheetprovider.dart';
import 'package:cnattendance/screen/profile/chatscreen.dart';
import 'package:cnattendance/screen/profile/employeedetailscreen.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamSheetScreen extends StatelessWidget {
  static const routeName = '/teamsheet';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TeamSheetProvider(),
      child: TeamSheet(),
    );
  }
}

class TeamSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TeamSheetState();
}

class TeamSheetState extends State<TeamSheet> {
  var initialState = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (initialState) {
      getTeam();
      initialState = false;
    }
    super.didChangeDependencies();
  }

  Future<String> getTeam() async {
    setState(() {
      isLoading = true;
      EasyLoading.show(status: translate('loader.loading'), maskType: EasyLoadingMaskType.black);
    });
    try {
      await Provider.of<TeamSheetProvider>(context, listen: false).getTeam();
      setState(() async {
        isLoading = false;
        EasyLoading.dismiss(animation: true);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        EasyLoading.dismiss(animation: true);
      });
    }

    return "Loaded";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeamSheetProvider>(context);
    final teamList =
        Provider.of<TeamSheetProvider>(context, listen: true).mainTeamList;
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(translate('team_sheet_screen.team_sheet')),
            elevation: 0,
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () {
                return getTeam();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  teamList.isEmpty
                      ? SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton2(
                              underline: SizedBox.shrink(),
                              isExpanded: true,
                              items: (provider.branches)
                                  .map((item) => DropdownMenuItem<Branch>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: provider.branches
                                  .where((element) =>
                                      element.id == provider.selectedBranch)
                                  .first,
                              onChanged: (value) {
                                setState(() {
                                  provider.selectedBranch =
                                      (value as Branch).id;
                                  provider.setDepartment((value).department);
                                  provider.selectedDepartment =
                                      (value).department.first.id;
                                  provider.makeTeamList();
                                });
                              },
                              iconStyleData: IconStyleData(
                                icon: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                iconSize: 14,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.grey,
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
                                padding: const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(10)),
                                  color: HexColor("#FFFFFF"),
                                ),
                                elevation: 0,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                padding: null,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  color: HexColor("#FFFFFF"),
                                ),
                                elevation: 8,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: 40,
                                padding: const EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            DropdownButton2(
                              underline: SizedBox.shrink(),
                              isExpanded: true,
                              items: (provider.department)
                                  .map((item) => DropdownMenuItem<Department>(
                                        value: item,
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              value: provider.department
                                  .where((element) =>
                                      element.id == provider.selectedDepartment)
                                  .first,
                              onChanged: (value) {
                                setState(() {
                                  provider.selectedDepartment =
                                      (value as Department).id;
                                  provider.makeTeamList();
                                });
                              },
                              iconStyleData: IconStyleData(
                                icon: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                iconSize: 14,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.grey,
                              ),
                              buttonStyleData: ButtonStyleData(
                                height: 50,
                                width: 160,
                                padding: const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(10)),
                                  color: HexColor("#FFFFFF"),
                                ),
                                elevation: 0,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                padding: null,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  color: HexColor("#FFFFFF"),
                                ),
                                elevation: 8,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: 40,
                                padding: const EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        itemCount: provider.teamList.length,
                        itemBuilder: (ctx, i) => Padding(
                            padding: EdgeInsets.all(5),
                            child: teamCard(provider.teamList[i]))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget teamCard(Team teamList) {
    return Card(
      shape: ButtonBorder(),
      elevation: 0,
      color: Colors.white10,
      child: InkWell(
        onTap: () {
          Get.to(EmployeeDetailScreen(),
              arguments: {"employeeId": teamList.id.toString()});
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color:
                            teamList.active == "1" ? Colors.green : Colors.grey,
                        width: 2)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    imageUrl: teamList.avatar,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        teamList.name,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(teamList.post,
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    final url = Uri.parse("tel:${teamList.phone}");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () async {
                    Get.to(ChatScreen(), arguments: {
                      "name": teamList.name,
                      "avatar": teamList.avatar,
                      "username": teamList.username,
                    });
                  },
                  icon: const Icon(
                    Icons.message,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
