import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/misc/icons_model.dart';

class AppIconModal extends StatefulWidget {
  final String iconsDataPath;

  AppIconModal({required this.iconsDataPath});

  @override
  _AppIconModalState createState() => _AppIconModalState();
}

class _AppIconModalState extends State<AppIconModal> {
  int selectedIcon = 0; // Default to the first icon

  Future<AppIcons> _loadIconsData(String jsonPath) async {
    String jsonString = await rootBundle.loadString(jsonPath);
    final jsonData = json.decode(jsonString);
    final iconsData = AppIcons.fromJson(jsonData);

    return iconsData;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double modalHeight = screenHeight * 0.9; // 90% of the screen height

    return Container(
      height: modalHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.of(context).radii.largest),
          topRight: Radius.circular(Dimensions.of(context).radii.largest),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: EdgeInsets.only(top: Dimensions.of(context).insets.medium),
      child: ListView(
        children: [
          Center(
            child: Text(
              'App Icon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).indicatorColor,
              ),
            ),
          ),
          FutureBuilder<AppIcons>(
            future: _loadIconsData(widget.iconsDataPath),
            builder: (BuildContext context, AsyncSnapshot<AppIcons> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
                  itemCount: snapshot.data!.icons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Dimensions.of(context).insets.medium,
                    mainAxisSpacing: Dimensions.of(context).insets.medium,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final icon = snapshot.data!.icons[index];
                    return GestureDetector(
                        onTap: () => setState(() => selectedIcon = index),
                        child: Container(
                          padding: EdgeInsets.all(
                              Dimensions.of(context).insets.smaller),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.of(context).radii.medium),
                            color: HexColor(icon.backgroundColor),
                            border: selectedIcon ==
                                    index // Check the condition here
                                ? Border.all(
                                    // If true, set the border
                                    color: Colors.black,
                                    width: 2.0,
                                  )
                                : null, // If false, no border
                          ),
                          child: SvgPicture.asset(icon.svgPath),
                        ));
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
