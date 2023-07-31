import 'package:flutter/material.dart';

Widget appIconModalContent(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double modalHeight = screenHeight * 0.9;  // 80% of the screen height

  return Container(
    height: modalHeight,
    padding: EdgeInsets.all(20.0),
    child: Column(
      children: [
        Text("Choose an App Icon"),
        // Add other widgets such as a list of app icons, etc.
      ],
    ),
  );
}
