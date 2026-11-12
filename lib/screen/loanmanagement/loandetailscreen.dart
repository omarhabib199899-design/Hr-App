import 'package:cnattendance/widget/radialDecoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LoanDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: RadialDecoration(),
      child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(translate('loan_detail_screen.loan_detail')),
            ),
            bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                child: Row(
                  children: [
                    Card(
                      elevation: 0,
                      color: "pending" == "pending"
                          ? Colors.orange.shade500
                          : "pending" == "rejected"
                              ? Colors.red.shade500
                              : Colors.green.shade500,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${translate('edit_loan_screen.total')} ",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    Text("Rs " + "50000",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Text(
                        "24 June 2024",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate('edit_loan_screen.requested_amount'),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      "800000",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate('edit_loan_screen.granted_amount'),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      "55000",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate('edit_loan_screen.interest_rate'),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      "10%",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate('edit_loan_screen.installment_period'),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      "12 months",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate('edit_loan_screen.is_settled'),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      "No",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      translate('edit_loan_screen.loan_detail'),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sodales ipsum faucibus imperdiet sodales. Praesent aliquet, magna sed ullamcorper finibus.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      translate('edit_loan_screen.verified_by'),
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      "Loard Benter",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "translate('edit_loan_screen.remarks')",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sodales ipsum faucibus imperdiet sodales. Praesent aliquet, magna sed ullamcorper finibus.",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
          ),
        ),
    );
  }
}
