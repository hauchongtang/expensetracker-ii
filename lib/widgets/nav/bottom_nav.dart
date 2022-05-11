import 'package:flutter/material.dart';

BottomNavigationBar bottomNavBar(BuildContext context, int _selectedIdx,
        {required void Function(int index) onItemTapped}) =>
    BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart), label: "Stats"),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info")
      ],
      currentIndex: _selectedIdx,
      selectedItemColor: Color(0xff05386b),
      unselectedItemColor: Color.fromARGB(255, 76, 76, 76),
      onTap: onItemTapped,
      backgroundColor: Color(0xff5cdb95),
    );
