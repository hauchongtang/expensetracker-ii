import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

AppBar topNavBar(BuildContext context, GlobalKey<ScaffoldState> key) => AppBar(
      // leading: Row(
      //   children: const [Padding(padding: EdgeInsets.only(left: 16))],
      // ),
      title: Row(children: [
        Image.asset(
          "assets/icons/duck.png",
          height: 32,
        ),
        SizedBox(
          width: 12,
        ),
        Text(
          "'s Dash",
          style: TextStyle(color: Color(0xffedf5e1)),
        ),
      ]),
      leading: IconButton(
        onPressed: (() {
          html.window.location.reload();
        }),
        icon: Icon(
          Icons.refresh_outlined,
          semanticLabel: "Press to go to Sheets",
        ),
        splashColor: Color(0xff8ee4af),
        hoverColor: Color(0xff379683),
      ),
      backgroundColor: Color(0xff05386b),
    );
