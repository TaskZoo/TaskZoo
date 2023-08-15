import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/widgets/onboarding/custom_nav_bar.dart';
import 'package:taskzoo/widgets/onboarding/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController();

  void onTap(int index) {
    setState(() {
      currentIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          OnboardingPage(
              topBackgroundColor: "#00CDFF",
              animalSvgPath: "assets/onboarding/flamingo.svg",
              title: "Create Tasks",
              content: [Text("Create tasks for goals...")]),
          Center(child: Text('Onboarding 2')),
          Center(child: Text('Onboarding 3')),
          Center(child: Text('Onboarding 4')),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
