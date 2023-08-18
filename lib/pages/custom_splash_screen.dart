import 'package:flutter/material.dart';

class CustomSplashScreen extends StatefulWidget {
  final String imagePath;

  CustomSplashScreen({required this.imagePath});

  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
      child: Image.asset(
        widget.imagePath,
        width: 500,
        height: 500,
      ),
    ));
  }
}
