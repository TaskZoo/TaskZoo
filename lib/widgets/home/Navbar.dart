import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    color: Theme.of(context).indicatorColor,
                    icon: SvgPicture.asset("assets/custom_icons/stats.svg",
                        color: Theme.of(context).iconTheme.color,
                        semanticsLabel: 'Stats'),
                    onPressed: () {
                      widget.onTap(0);
                    },
                  ),
                  IconButton(
                    color: Theme.of(context).indicatorColor,
                    icon: SvgPicture.asset("assets/custom_icons/settings.svg",
                        color: Theme.of(context).iconTheme.color,
                        semanticsLabel: 'Settings'),
                    onPressed: () {
                      widget.onTap(3);
                    },
                  ),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
