import 'package:cnattendance/model/leave.dart';
import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class LeaveTypeIssueLeave extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => LeaveTypeIssueLeaveState();
}

class LeaveTypeIssueLeaveState extends State<LeaveTypeIssueLeave>{
  Leave? selectedValue;

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    final provider = Provider.of<LeaveProvider>(context);

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: const [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.white,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                'Select Leave Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: provider.leaveList
            .map((item) => DropdownMenuItem<Leave>(
                  value: item,
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          selectedValue = value as Leave?;
          if (selectedValue != null) {
            setState(() {

            });
          }
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
    );
  }
}
