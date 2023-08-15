import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

class CustomNavBar extends StatefulWidget {
  // icon sizes
  final double dotIconSize = 10;
  final double otherIconSize = 25;

  final int currentIndex;
  final Function onTap;

  CustomNavBar({required this.currentIndex, required this.onTap});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SafeArea(
        child: Container(
          height: 50,
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.of(context).insets.medium),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the onboarding screen
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.of(context).insets.medium),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            color: Theme.of(context).dividerColor,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.currentIndex < 3) {
                        widget.onTap(widget.currentIndex + 1);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text('Next', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      color: widget.currentIndex == 0
                          ? Theme.of(context).indicatorColor
                          : Theme.of(context).dividerColor,
                      icon: const Icon(Icons.circle),
                      onPressed: () {
                        widget.onTap(0);
                      },
                      iconSize: widget.dotIconSize,
                      padding: EdgeInsets.all(5),
                      constraints: BoxConstraints(),
                    ),
                    IconButton(
                      color: widget.currentIndex == 1
                          ? Theme.of(context).indicatorColor
                          : Theme.of(context).dividerColor,
                      icon: const Icon(Icons.circle),
                      onPressed: () {
                        widget.onTap(1);
                      },
                      iconSize: widget.dotIconSize,
                      padding: EdgeInsets.all(5),
                      constraints: BoxConstraints(),
                    ),
                    IconButton(
                      color: widget.currentIndex == 2
                          ? Theme.of(context).indicatorColor
                          : Theme.of(context).dividerColor,
                      icon: const Icon(Icons.circle),
                      onPressed: () {
                        widget.onTap(2);
                      },
                      iconSize: widget.dotIconSize,
                      padding: EdgeInsets.all(5),
                      constraints: BoxConstraints(),
                    ),
                    IconButton(
                      color: widget.currentIndex == 3
                          ? Theme.of(context).indicatorColor
                          : Theme.of(context).dividerColor,
                      icon: const Icon(Icons.circle),
                      onPressed: () {
                        widget.onTap(3);
                      },
                      iconSize: widget.dotIconSize,
                      padding: EdgeInsets.all(5),
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
