import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TutorialTaskCard extends StatefulWidget {
  @override
  _TutorialTaskCardState createState() => _TutorialTaskCardState();
}

class _TutorialTaskCardState extends State<TutorialTaskCard> {
  Widget _getFrontTopInfo() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Dimensions.of(context).insets.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "10 Pushups",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Fitness",
          ),
        ],
      ),
    );
  }

  Widget _getFrontBottomInfo() {
    // if the task is completed the user gets a checkmark
    if (false) {
      return Center(
        child: SvgPicture.asset("assets/custom_icons/check.svg",
            color: Theme.of(context).iconTheme.color, semanticsLabel: 'Check'),
      );
    }

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.of(context).insets.small),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/custom_icons/clock.svg",
                color: Theme.of(context).iconTheme.color,
                semanticsLabel: 'Clock'),
            SizedBox(width: Dimensions.of(context).insets.smaller),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("15 Hours Left"),
              ],
            ),
          ],
        ));
  }

  Widget _getCardFront() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getFrontTopInfo(),
        Container(
          height: 1.0,
          color: Theme.of(context).dividerColor,
        ),
        _getFrontBottomInfo(),
      ],
    );
  }

  Widget _getCardBack() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/custom_icons/pencil.svg",
            color: Theme.of(context).iconTheme.color, semanticsLabel: 'Pencil'),
        SizedBox(width: Dimensions.of(context).insets.medium),
        Container(
          width: 1.0,
          height: 40,
          color: Theme.of(context).dividerColor,
        ),
        SizedBox(width: Dimensions.of(context).insets.medium),
        SvgPicture.asset("assets/custom_icons/trash.svg",
            color: Theme.of(context).iconTheme.color, semanticsLabel: 'Trash'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      side: CardSide.FRONT,
      front: Container(
        padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Dimensions.of(context).radii.medium),
          color: Theme.of(context).cardColor,
        ),
        child: _getCardFront(),
      ),
      back: Container(
        padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Dimensions.of(context).radii.medium),
          color: Theme.of(context).cardColor,
        ),
        child: _getCardBack(),
      ),
    );
  }
}
