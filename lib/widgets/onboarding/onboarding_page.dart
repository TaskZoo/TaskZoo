import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:taskzoo/misc/hex_color.dart';

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
    return Container(
      color: HexColor(topBackgroundColor),
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
                // SVG asset from animalSvgPath
                SvgPicture.asset(
                  animalSvgPath,
                  // You can set width, height, color, etc. as needed
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
                  style: TextStyle(
                      fontSize: 24), // You can customize the style as needed
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white, // Bottom container with white color
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
