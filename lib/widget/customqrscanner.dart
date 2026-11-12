import 'package:cnattendance/widget/buttonborder.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<String?> showCustomQrScanner(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Scan QR Code',style: TextStyle(color: Colors.white,fontSize: 14),),
        content: SizedBox(
          width: 200,
          height: 200,
          child: MobileScanner(
            onDetect: (barcodes) {
              Navigator.pop(context, barcodes.barcodes.first.rawValue ?? null);
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, null); // Return text
            },
            style: ElevatedButton.styleFrom(
              shape: ButtonBorder(),
              backgroundColor: Colors.blue, // Background color
            ),
            child: Container(width: double.infinity,child: Center(child: Text('Cancel',style: TextStyle(color: Colors.white),))),
          ),
        ],
      );
    },
  );
}
