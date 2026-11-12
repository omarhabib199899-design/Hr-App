import 'package:cnattendance/screen/loanmanagement/createloanscreen.dart';
import 'package:cnattendance/screen/loanmanagement/editloanscreen.dart';
import 'package:cnattendance/screen/loanmanagement/loandetailscreen.dart';
import 'package:cnattendance/utils/constant.dart';
import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';

class LoanListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RadialDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(translate('loan_list_screen.loan')),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(CreateLoanScreen());
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(10))),
                      tileColor: Colors.white12,
                      onTap: () {
                        Get.to(LoanDetailScreen());
                      },
                      textColor: Colors.white,
                      iconColor: Colors.white,
                      title: Text(
                        "10000",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "24 June 2024",
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          if("pending" == "pending"){
                            Get.to(EditLoanScreen());
                          }else{
                            showToast("Accepted/Rejected Loan can't be edited");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.edit),
                        ),
                      ),
                      leading: Card(
                          color: "pending" == "pending"
                              ? Colors.orange
                              : "pending" == "rejected"
                                  ? Colors.red
                                  : Colors.green,
                          shape: CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "pending" == "pending"
                                  ? "P"
                                  : "pending" == "rejected"
                                      ? "R"
                                      : "A",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )),
                    ),
                  );
                },
              ),
            ),
          ),
      ),
    );
  }
}
