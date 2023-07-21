import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:taskzoo/widgets/zoo/AnimalBuilder.dart';

import 'package:taskzoo/models/biomes_model.dart';

import 'package:taskzoo/notifiers/zoo_notifier.dart';

class ZooBody extends StatelessWidget {
  final Biomes biomesData;

  ZooBody({required this.biomesData});

  @override
  Widget build(BuildContext context) {
    // get the ZooNotifier
    final zooNotifier = Provider.of<ZooNotifier>(context);

    // get the animals of the current biome
    final animals = biomesData.biomes[zooNotifier.currentBiome].animals;

    // get color for animal cards in current biome
    final animalCardColor =
        HexColor(biomesData.biomes[zooNotifier.currentBiome].secondaryColor);

    // rest of the code
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(20.0),
      itemCount: animals.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return AnimalBuilder(
            key: ValueKey(animals[index].svgPath),
            svgPath: animals[index].svgPath,
            backgroundColor: animalCardColor);
      },
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
