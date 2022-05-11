import 'package:expense_tracker_ii/api/google_sheets_api.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  GoogleSheetsAPI().init("xxx");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
