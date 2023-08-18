import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:taskzoo/misc/hex_color.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String topBackgroundColor;
  final String animalSvgPath;
  final List<Widget> content;

  const OnboardingPage({
    required this.title,
    required this.topBackgroundColor,
    required this.animalSvgPath,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor(topBackgroundColor),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // White radial gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.7),
                          Colors.white.withOpacity(0)
                        ],
                        radius: 0.5,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    animalSvgPath,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(Dimensions.of(context).radii.largest),
                    topRight:
                        Radius.circular(Dimensions.of(context).radii.largest),
                  ),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Theme.of(context).cardColor,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: content),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
