import 'package:flutter/material.dart';

const int largeScreenSize = 1366;
const int smallScreenSize = 360;
const int mediumScreenSize = 768;

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget(
      {Key? key, required this.largeScreen, required this.smallScreen})
      : super(key: key);

  final Widget largeScreen;
  final Widget smallScreen;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < mediumScreenSize;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > largeScreenSize;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth >= largeScreenSize) {
          return largeScreen;
        } else if (constraints.maxWidth < largeScreenSize &&
            constraints.maxWidth >= mediumScreenSize) {
          return largeScreen;
        } else {
          return smallScreen;
        }
      }),
    );
  }
}
