import 'dart:async';

import 'package:progress_border/progress_border.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FlippingTaskCard extends StatefulWidget {
  @override
  _FlippingTaskCardState createState() => _FlippingTaskCardState();
}

class _FlippingTaskCardState extends State<FlippingTaskCard> {
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/custom_icons/clock.svg",
            color: Theme.of(context).iconTheme.color, semanticsLabel: 'Clock'),
        SizedBox(width: Dimensions.of(context).insets.smaller),
        Text("15 Hours Left"),
      ],
    );
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

  late FlipCardController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();

    // Initialize the timer to toggle the card every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _controller.toggleCard();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      flipOnTouch: false,
      controller: _controller,
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

class HoldingTaskCard extends StatefulWidget {
  @override
  _HoldingTaskCardState createState() => _HoldingTaskCardState();
}

class _HoldingTaskCardState extends State<HoldingTaskCard>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _borderWidth;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _borderWidth = Tween<double>(begin: 2, end: 2).animate(_pulseController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _progressController.reset();
          _pulseController.reverse();
        }
      });

    _progressController.addListener(() {
      if (_progressController.value == 1.0) {
        print("Task complete");
        _pulseController.forward();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        _progressController.animateTo(1);
      },
      onLongPressEnd: (details) {
        if (!_progressController.isCompleted) {
          _progressController.animateBack(0);
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_progressController, _pulseController]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Dimensions.of(context).radii.medium),
              color: Theme.of(context).cardColor,
              border: ProgressBorder.all(
                color: Theme.of(context).indicatorColor,
                width: _borderWidth.value,
                progress: _progressController.value,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
          );
        },
      ),
    );
  }
}
