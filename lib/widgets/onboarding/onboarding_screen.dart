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
              title: "Create Tasks",
              topBackgroundColor: "#FFA06B",
              animalSvgPath: "assets/onboarding/llama.svg",
              content: [
                const Text(
                  "Create tasks for goals that you want to achieve and filter by tags to keep everything organized.",
                  style: TextStyle(fontSize: 20),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.keyboard_control),
                  Container(
                    width: 1,
                    height: 40,
                    color: Theme.of(context).indicatorColor,
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.of(context).insets.smaller),
                  ),
                  const Icon(Icons.add),
                ]),
                const Text(
                  "Use daily, weekly, and monthly tasks to encourage productivity over different time periods.",
                  style: TextStyle(fontSize: 20),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).indicatorColor,
                        width: Dimensions.of(context).borderWidths.small,
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Center(
                      child: Text(
                        "D",
                        style: TextStyle(
                          color: Theme.of(context).indicatorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.of(context).insets.small),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).indicatorColor,
                        width: Dimensions.of(context).borderWidths.small,
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Center(
                      child: Text(
                        "W",
                        style: TextStyle(
                          color: Theme.of(context).indicatorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.of(context).insets.small),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).indicatorColor,
                        width: Dimensions.of(context).borderWidths.small,
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Center(
                      child: Text(
                        "M",
                        style: TextStyle(
                          color: Theme.of(context).indicatorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ]),
              ]),
          OnboardingPage(
              title: "Use Tasks",
              topBackgroundColor: "#45DAFF",
              animalSvgPath: "assets/onboarding/flamingo.svg",
              content: [
                const Text(
                  "Create tasks for goals that you want to achieve and filter by tags to keep everything organized.",
                  style: TextStyle(fontSize: 20),
                ),
              ]),
          OnboardingPage(
              title: "Collect Pieces",
              topBackgroundColor: "#85FF91",
              animalSvgPath: "assets/onboarding/parrot.svg",
              content: [
                const Text(
                  "Create tasks for goals that you want to achieve and filter by tags to keep everything organized.",
                  style: TextStyle(fontSize: 20),
                ),
              ]),
          OnboardingPage(
              title: "Build Animals",
              topBackgroundColor: "#FFEDA8",
              animalSvgPath: "assets/onboarding/lion.svg",
              content: [
                const Text(
                  "Create tasks for goals that you want to achieve and filter by tags to keep everything organized.",
                  style: TextStyle(fontSize: 20),
                ),
              ]),
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
