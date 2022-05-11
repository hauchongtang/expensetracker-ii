import 'package:flutter/material.dart';

String firstName = "Duck";
String secondName = "Rabbit";
String bothName = "Both";

Drawer appBarDrawer(BuildContext context) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text("Switch Accounts"),
            decoration: BoxDecoration(color: Color(0xff379683)),
          ),
          ListTile(
            title: Text(firstName),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(secondName),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(bothName),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
