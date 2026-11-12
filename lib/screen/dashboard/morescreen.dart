import 'package:cnattendance/provider/dashboardprovider.dart';
import 'package:cnattendance/provider/morescreenprovider.dart';
import 'package:cnattendance/provider/prefprovider.dart';
import 'package:cnattendance/screen/advancesalary/advancesalaryscreen.dart';
import 'package:cnattendance/screen/assetscreen/assetscreen.dart';
import 'package:cnattendance/screen/awards/awardsscreen.dart';
import 'package:cnattendance/screen/complainscreen/complainscreen.dart';
import 'package:cnattendance/screen/dashboard/projectscreen.dart';
import 'package:cnattendance/screen/eventscreen/eventlistscreen.dart';
import 'package:cnattendance/screen/profile/aboutscreen.dart';
import 'package:cnattendance/screen/profile/changepasswordscreen.dart';
import 'package:cnattendance/screen/profile/companyrulesscreen.dart';
import 'package:cnattendance/screen/profile/holidayscreen.dart';
import 'package:cnattendance/screen/profile/leavecalendarscreen.dart';
import 'package:cnattendance/screen/profile/meetingscreen.dart';
import 'package:cnattendance/screen/profile/noticescreen.dart';
import 'package:cnattendance/screen/profile/payslipscreen.dart';
import 'package:cnattendance/screen/profile/profilescreen.dart';
import 'package:cnattendance/screen/profile/ssfhistoryscreen.dart';
import 'package:cnattendance/screen/profile/supportscreen.dart';
import 'package:cnattendance/screen/profile/teamsheetscreen.dart';
import 'package:cnattendance/screen/tadascreen/TadaScreen.dart';
import 'package:cnattendance/screen/traning/traningscreen.dart';
import 'package:cnattendance/screen/warningscreen/warningscreen.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/headerprofile.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:cnattendance/widget/morescreen/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoreScreenState();
}

class MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final attendanceType = context.watch<PrefProvider>().attendanceType;
    final features = context.watch<MoreScreenProvider>().features;
    final showNfc = context.watch<MoreScreenProvider>().showNfc;
    final attendanceMethod = context.watch<DashboardProvider>().attendanceMethods;

    void changeAttendanceType(String type) {
      context.read<PrefProvider>().saveAttendanceType(type);
      showToast("Attendance method set to $type");
    }

    return FocusDetector(
      onFocusGained: () {
        context.read<MoreScreenProvider>().getFeatures();
      },
      child: Container(
        decoration: RadialDecoration(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: features.isEmpty
                  ? Center(
                      child: Text(
                        "Loading",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderProfile(),
                            if(attendanceMethod.isNotEmpty)
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  translate(
                                      'more_screen.attendance_default_method'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  if(attendanceMethod.contains("default"))
                                  GestureDetector(
                                    onTap: () {
                                      changeAttendanceType("Default");
                                    },
                                    child: Chip(
                                        backgroundColor:
                                            attendanceType != "Default"
                                                ? HexColor("#000")
                                                : HexColor("#036eb7"),
                                        avatar: Icon(
                                          Icons.fingerprint,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          translate('more_screen.default'),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: HexColor("#036eb7")),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10)))),
                                  ),
                                  if(attendanceMethod.contains("nfc"))
                                  GestureDetector(
                                    onTap: () {
                                      changeAttendanceType("NFC");
                                    },
                                    child: Chip(
                                        backgroundColor:
                                        attendanceType != "NFC"
                                            ? HexColor("#000")
                                            : HexColor("#036eb7"),
                                        avatar: Icon(
                                          Icons.nfc,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          translate('more_screen.nfc'),
                                          style:
                                          TextStyle(color: Colors.white),
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: HexColor("#036eb7")),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight:
                                                Radius.circular(10)))),
                                  ),
                                  if(attendanceMethod.contains("qr"))
                                  GestureDetector(
                                    onTap: () {
                                      changeAttendanceType("QR");
                                    },
                                    child: Chip(
                                        backgroundColor:
                                        attendanceType != "QR"
                                            ? HexColor("#000")
                                            : HexColor("#036eb7"),
                                        label: Text(
                                          translate('more_screen.qr_code'),
                                          style:
                                          TextStyle(color: Colors.white),
                                        ),
                                        avatar: Icon(
                                          Icons.qr_code,
                                          color: Colors.white,
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: HexColor("#036eb7")),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomRight:
                                                Radius.circular(10)))),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  translate('more_screen.account'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            Services(translate('more_screen.profile'),
                                Icons.person, ProfileScreen()),
                            Services(translate('more_screen.change_password'),
                                Icons.password, ChangePasswordScreen()),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 10),
                                child: Text(
                                  translate('more_screen.office_desk'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            Services(translate('more_screen.team_sheet'),
                                Icons.group, TeamSheetScreen()),
                            features["project-management"] != "1"
                                ? SizedBox.shrink()
                                : Services(
                                    translate('more_screen.project_management'),
                                    Icons.work,
                                    ProjectScreen()),
                            features["event"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('common.office_events'),
                                    Icons.event, EventListScreen()),
                            features["training"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('home_screen.training'),
                                    Icons.group, TrainingScreen()),
                            features["award"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('more_screen.awards'),
                                    Icons.workspace_premium, AwardsScreen()),
                            features["assets"] != "1"
                                ? SizedBox.shrink()
                                : Services(
                                translate('common.assets'),
                                Icons.production_quantity_limits,
                                AssetScreen()),
                            /*features["training"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('more_screen.training'),
                                    Icons.model_training, TrainingScreen()),*/
                            Services(translate('more_screen.holiday'),
                                Icons.calendar_month, HolidayScreen()),
                            Services(translate('more_screen.notices'),
                                Icons.message, NoticeScreen()),
                            features["meeting"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('more_screen.meeting'),
                                    Icons.meeting_room, MeetingScreen()),
                            Services(
                                translate('more_screen.leave_calendar'),
                                Icons.calendar_month_outlined,
                                LeaveCalendarScreen()),
                            features["warning"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('more_screen.warning'),
                                    Icons.warning, WarningScreen()),
                            features["complaint"] != "1"
                                ? SizedBox.shrink()
                                : Services(
                                    translate('more_screen.complain'),
                                    Icons.perm_device_information_outlined,
                                    ComplainScreen()),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 10),
                                child: Text(
                                  translate('more_screen.finance'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            features["tada"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('more_screen.tada'),
                                    Icons.money, TadaScreen()),
                            features["payroll-management"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('more_screen.payslip'),
                                    Icons.payments_outlined, PaySlipScreen()),
                            features["payroll-management"] != "1"
                                ? SizedBox.shrink()
                                : Services("SSF History",
                                    Icons.payments, SsfHistoryScreen()),
                            features["advance-salary"] != "1"
                                ? SizedBox.shrink()
                                : Services(
                                    translate('more_screen.advance_salary'),
                                    Icons.monetization_on,
                                    AdvanceSalaryScreen()),
                            /*features["loan"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('more_screen.loans'),
                                    Icons.handshake_outlined, LoanListScreen()),*/
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 10),
                                child: Text(
                                  translate('more_screen.additional'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            //Services('Issue Ticket', Icons.note, ProfileScreen()),
                            features["support"] != "1"
                                ? SizedBox.shrink()
                                : Services(translate('more_screen.support'),
                                    Icons.support_agent, SupportScreen()),
                            Services(translate('more_screen.company_rules'),
                                Icons.rule_folder, CompanyRulesScreen()),
                            Services(translate('more_screen.about_us'),
                                Icons.info, AboutScreen('about-us')),
                            Services(
                                translate('more_screen.terms_and_conditions'),
                                Icons.rule,
                                AboutScreen('terms-and-conditions')),
                            Services(
                              translate('more_screen.privacy_policy'),
                              Icons.policy,
                              ProfileScreen(),
                              control: 1,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 20, bottom: 10),
                                child: Text(
                                  translate('more_screen.others'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            features["dark-mode"] != "1"
                                ? SizedBox.shrink()
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          trailing: Switch(
                                            activeColor: Colors.blue,
                                            value: !getAppTheme(),
                                            onChanged: (value) {
                                              final box = GetStorage();
                                              box.write('theme',
                                                  !(box.read("theme") ?? true));
                                            },
                                          ),
                                          dense: true,
                                          minLeadingWidth: 5,
                                          leading: Icon(
                                            Icons.landscape,
                                            color: Colors.white,
                                          ),
                                          title: Text(
                                            translate('more_screen.dark_mode'),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          onTap: () {
                                            final box = GetStorage();
                                            box.write('theme',
                                                !(box.read("theme") ?? true));
                                          },
                                          selected: true,
                                        ),
                                        const Divider(
                                          height: 1,
                                          color: Colors.white24,
                                          indent: 15,
                                          endIndent: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: Column(
                                children: [
                                  ListTile(
                                    trailing: Switch(
                                      activeColor: Colors.blue,
                                      value: getAnimation(),
                                      onChanged: (value) {
                                        final box = GetStorage();
                                        box.write('animation',
                                            !(box.read("animation") ?? true));
                                      },
                                    ),
                                    dense: true,
                                    minLeadingWidth: 5,
                                    leading: Icon(
                                      Icons.animation,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      translate('more_screen.animation'),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    onTap: () {
                                      final box = GetStorage();
                                      box.write('animation',
                                          !(box.read("animation") ?? true));
                                    },
                                    selected: true,
                                  ),
                                  const Divider(
                                    height: 1,
                                    color: Colors.white24,
                                    indent: 15,
                                    endIndent: 15,
                                  ),
                                ],
                              ),
                            ),
                            !showNfc
                                ? SizedBox.shrink()
                                : Services(
                                    translate('more_screen.add_nfc'),
                                    Icons.nfc,
                                    SupportScreen(),
                                    control: 3,
                                  ),
                            Services(
                              translate('common.language'),
                              Icons.language,
                              ProfileScreen(),
                              control: 4,
                            ),
                            features["resignation"] != "1"
                                ? SizedBox.shrink()
                                : Services(
                                    "Resignation",
                                    Icons.group_remove_outlined,
                                    ProfileScreen(),
                                    control: 5,
                                  ),
                            Services(
                              translate('more_screen.log_out'),
                              Icons.logout,
                              ProfileScreen(),
                              control: 2,
                            ),
                          ],
                        ),
                      ),
                    )),
        ),
      ),
    );
  }
}
