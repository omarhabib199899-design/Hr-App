import 'package:cnattendance/model/leave.dart';
import 'package:cnattendance/provider/leaveprovider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class LeavetypeFilter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LeavetypeFilterState();
}

class LeavetypeFilterState extends State<LeavetypeFilter> {
  Leave? selectedValue;

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    final provider = Provider.of<LeaveProvider>(context);

    void onToggleChanged() async {
      final detailResponse = await provider.getLeaveTypeDetail();

      if (!mounted) return;
      if (detailResponse.statusCode == 200) {
        if (detailResponse.data.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(20),
              content: Text('No data found')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: const EdgeInsets.all(20),
            content: Text(detailResponse.message)));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          translate('leave_screen.filter'),
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: [
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    translate('leave_screen.select_leave_type'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: provider.filterLeaveList
                .map((item) => DropdownMenuItem<Leave>(
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
            value: selectedValue?.name,
            onChanged: (value) {
              selectedValue = value as Leave?;
              if (selectedValue != null) {
                provider.setType(selectedValue!.id);
                onToggleChanged();
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
        ),
      ],
    );
  }
}
