import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

Widget appIconModalContent(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double modalHeight = screenHeight * 0.9; // 80% of the screen height

  return Container(
    height: modalHeight,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimensions.of(context).radii.largest),
        topRight: Radius.circular(Dimensions.of(context).radii.largest),
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
    ),
    padding: EdgeInsets.symmetric(vertical: Dimensions.of(context).insets.medium),
    child: ListView(
      padding: EdgeInsets.only(top: 0),
      children: [
        Center(
          child: Text(
            'Add a New Task',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).indicatorColor,
            ),
          ),
        ),
        ModalBody(),
      ],
    ),
  );
}

class ModalBody extends StatelessWidget {
  ModalBody();

  @override
  Widget build(BuildContext context) {
    // rest of the code
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
      itemCount: 8,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Dimensions.of(context).insets.medium,
        mainAxisSpacing: Dimensions.of(context).insets.medium,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.all(Dimensions.of(context).insets.smaller),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(Dimensions.of(context).radii.medium),
            color: Theme.of(context).cardColor,
          ),
          child: SvgPicture.asset("assets/low_poly_curled_fox.svg"),
        );
      },
    );
  }
}
