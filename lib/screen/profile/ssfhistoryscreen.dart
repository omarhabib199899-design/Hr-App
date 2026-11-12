import 'package:cnattendance/model/month.dart';
import 'package:cnattendance/provider/payslipprovider.dart';
import 'package:cnattendance/provider/ssfprovider.dart';
import 'package:cnattendance/screen/profile/payslipdetailscreen.dart';
import 'package:cnattendance/widget/buttonborder.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class SsfHistoryScreen extends StatefulWidget {
  bool initital = true;

  @override
  State<StatefulWidget> createState() => SsfHistoryScreenState();
}

class SsfHistoryScreenState extends State<SsfHistoryScreen> {
  bool showAll = true;

  @override
  Future<void> didChangeDependencies() async {
    if (widget.initital) {
      context.read<SSFProvider>().getBS();
      widget.initital = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final year = context.watch<SSFProvider>().year;

    var selectedYear = context.watch<SSFProvider>().selectedYear;
    var ssfList = context.watch<SSFProvider>().ssfList;
    var currency = context.watch<SSFProvider>().currency;

    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("SSF History"),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: ButtonBorder(),
                  margin: EdgeInsets.zero,
                  color: HexColor("#20FFFFFF"),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Consumer(
                                builder: (context, value, child) {
                                  return year.isEmpty
                                      ? SizedBox.shrink()
                                      : Expanded(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              isExpanded: true,
                                              items: (year)
                                                  .map((item) =>
                                                      DropdownMenuItem<int>(
                                                        value: item,
                                                        child: Text(
                                                          item.toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: selectedYear,
                                              onChanged: (value) {
                                                setState(() {
                                                  print(value);
                                                  context
                                                          .read<SSFProvider>()
                                                          .selectedYear =
                                                      value as int;
                                                });
                                              },
                                              iconStyleData: IconStyleData(
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                ),
                                                iconSize: 14,
                                                iconEnabledColor: Colors.black,
                                                iconDisabledColor: Colors.grey,
                                              ),
                                              buttonStyleData: ButtonStyleData(
                                                height: 50,
                                                width: 160,
                                                padding: const EdgeInsets.only(
                                                    left: 14, right: 14),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(10),
                                                          topRight:
                                                              Radius.circular(
                                                                  0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: HexColor("#FFFFFF"),
                                                ),
                                                elevation: 0,
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                maxHeight: 200,
                                                padding: null,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(0),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color: HexColor("#FFFFFF"),
                                                ),
                                                elevation: 8,
                                              ),
                                              menuItemStyleData:
                                                  MenuItemStyleData(
                                                height: 40,
                                                padding: const EdgeInsets.only(
                                                    left: 14, right: 14),
                                              ),
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: HexColor("#036eb7"),
                                shape: ButtonBorder()),
                            onPressed: () async {
                              setState(() {
                                EasyLoading.show(
                                    status: "Loading",
                                    maskType: EasyLoadingMaskType.black);
                              });
                              context
                                  .read<SSFProvider>()
                                  .getSSFHistory(selectedYear);
                              setState(() {
                                EasyLoading.dismiss(animation: true);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(2.0),
                              child: Center(
                                child: Text(
                                  "Request SSF History",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (ssfList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "History",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: ssfList.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      final item = ssfList[index];
                      return Card(
                        elevation: 0,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        color: Colors.white.withValues(alpha: 0.10),
                        shape: ButtonBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.month,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Spacer(),
                                  Text(
                                    currency +
                                        " " +
                                        (item.officeContribution +
                                                item.salaryContribution)
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.white38,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Salary Deduction",
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          currency +
                                              " " +
                                              item.salaryContribution
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: VerticalDivider(
                                      width: 1,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Office Contribution",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          currency +
                                              " " +
                                              item.officeContribution
                                                  .toStringAsFixed(2),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
