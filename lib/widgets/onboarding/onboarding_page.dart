import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

class OnboardingPage extends StatelessWidget {
  final String topBackgroundColor;
  final String animalSvgPath;
  final String title;
  final List<Widget> content;

  OnboardingPage({
    required this.topBackgroundColor,
    required this.animalSvgPath,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 24), // You can customize the style as needed
      ),
    );
  }
}
