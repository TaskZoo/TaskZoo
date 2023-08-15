import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/widgets/onboarding/custom_nav_bar.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Onboarding'),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
