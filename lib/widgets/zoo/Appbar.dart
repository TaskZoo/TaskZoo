import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

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
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: zooNotifier.currentBiome == iconIndex
                    ? Theme.of(context).indicatorColor
                    : Theme.of(context).scaffoldBackgroundColor,
                width: Dimensions.of(context).borderWidths.medium, // adjust width as needed
              ),
            ),
            child: FittedBox(
              child: IconButton(
                icon: SvgPicture.asset(
                  currentBiomeIcon.svgPath,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).indicatorColor, BlendMode.srcIn),
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
