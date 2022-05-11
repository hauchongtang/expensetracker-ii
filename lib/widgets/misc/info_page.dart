import 'package:flutter/material.dart';
import 'dart:js' as js;

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Created by Hau Chong"),
          Text("Made with Flutter & Google Sheets"),
          Text("Charts are currently unavailable on PWA"),
          Text(
              "Deleting the transaction will be done via Sheets: Delete row!\n"),
          Text("Press the below to go to Google Sheets"),
          SizedBox(
            height: 16,
          ),
          IconButton(
            onPressed: (() {
              js.context.callMethod('open', [
                'page'
              ]);
            }),
            icon: Icon(
              Icons.table_chart_sharp,
              semanticLabel: "Press to go to Sheets",
            ),
            splashColor: Color(0xff8ee4af),
            hoverColor: Color(0xff379683),
          ),
        ]),
      ),
    );
  }
}
