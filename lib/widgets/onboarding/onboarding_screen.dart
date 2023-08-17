import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:taskzoo/widgets/onboarding/custom_nav_bar.dart';
import 'package:taskzoo/widgets/onboarding/onboarding_page.dart';
import 'package:taskzoo/widgets/onboarding/tutorial_task_card.dart';

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
    Widget onboarding_page_1 = OnboardingPage(
        title: "Create Tasks",
        topBackgroundColor: "#FFA06B",
        animalSvgPath: "assets/onboarding/llama.svg",
        content: [
          const Text(
            "Create tasks for goals that you want to achieve and filter by tags to keep everything organized.",
            style: TextStyle(fontSize: 20),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset("assets/custom_icons/filter.svg",
                color: Theme.of(context).iconTheme.color,
                semanticsLabel: 'Filter'),
            Container(
              width: 1,
              height: 40,
              color: Theme.of(context).indicatorColor,
              margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.of(context).insets.large),
            ),
            SvgPicture.asset("assets/custom_icons/plus.svg",
                color: Theme.of(context).iconTheme.color,
                semanticsLabel: 'Plus'),
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
        ]);

    Widget onboarding_page_2 = OnboardingPage(
        title: "Use Tasks",
        topBackgroundColor: "#45DAFF",
        animalSvgPath: "assets/onboarding/flamingo.svg",
        content: [
          const Text(
            "Hold down a task card to mark it as complete, or tap the task card to modify/delete the task.",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: Dimensions.of(context).insets.medium,
          ),
          Expanded(
              child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(aspectRatio: 1 / 1, child: TutorialTaskCard()),
                SizedBox(width: Dimensions.of(context).insets.medium),
                AspectRatio(aspectRatio: 1 / 1, child: TutorialTaskCard()),
              ],
            ),
          ))
        ]);

    Widget onboarding_page_3 = OnboardingPage(
        title: "Collect Pieces",
        topBackgroundColor: "#85FF91",
        animalSvgPath: "assets/onboarding/parrot.svg",
        content: [
          const Text(
            "Get rewarded with pieces every time you complete a task!",
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FontAwesomeIcons.puzzlePiece),
              SizedBox(width: Dimensions.of(context).insets.large),
              Text("Number increase animation")
            ],
          ),
          const Text(
            "The amount of pieces you receive depends on how big a task you complete.",
            style: TextStyle(fontSize: 20),
          ),
        ]);

    Widget onboarding_page_4 = OnboardingPage(
        title: "Build Animals",
        topBackgroundColor: "#FFEDA8",
        animalSvgPath: "assets/onboarding/lion.svg",
        content: [
          const Text(
            "Tapping an animal that is incomplete will use pieces to build that animal.",
            style: TextStyle(fontSize: 20),
          ),
          SvgPicture.asset(
            "assets/onboarding/rat.svg",
            height: 175,
          ),
          const Text(
            "Once an animal is complete, it becomes part of your zoo!",
            style: TextStyle(fontSize: 20),
          ),
        ]);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          onboarding_page_1,
          onboarding_page_2,
          onboarding_page_3,
          onboarding_page_4
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
