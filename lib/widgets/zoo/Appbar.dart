import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:taskzoo/misc/biomes_model.dart';

import 'package:taskzoo/misc/zoo_notifier.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Biomes biomesData;

  CustomAppBar({required this.biomesData});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final zooNotifier = Provider.of<ZooNotifier>(context);
    final biomes = widget.biomesData.biomes;
    final icons = biomes.map((biome) => biome.icon).toList();

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: icons.map((currentBiomeIcon) {
          int iconIndex = icons.indexOf(currentBiomeIcon);
          return Container(
            height: 35.0, // adjust as needed
            width: 35.0, // adjust as needed
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: zooNotifier.currentBiome == iconIndex
                  ? Colors.black
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: zooNotifier.currentBiome == iconIndex
                      ? Colors.black
                      : Colors.white,
                  spreadRadius: 4,
                  blurRadius: 5,
                ),
              ],
            ),
            child: FittedBox(
              child: IconButton(
                icon: SvgPicture.asset(
                  currentBiomeIcon.svgPath,
                  colorFilter: ColorFilter.mode(
                      zooNotifier.currentBiome == iconIndex
                          ? Colors.white
                          : Colors.black,
                      BlendMode.srcIn),
                ),
                onPressed: () {
                  zooNotifier.changeBiome(iconIndex);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
