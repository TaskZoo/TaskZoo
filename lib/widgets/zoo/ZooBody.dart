import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:taskzoo/widgets/isar_service.dart';
import 'package:taskzoo/widgets/preference_service.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/widgets/zoo/AnimalBuilder.dart';

import 'package:taskzoo/misc/biomes_model.dart';

import 'package:taskzoo/misc/zoo_notifier.dart';

class ZooBody extends StatelessWidget {
  final Biomes biomesData;
  final PreferenceService preferenceService;
  final IsarService service;

  ZooBody(
      {required this.biomesData,
      required this.preferenceService,
      required this.service});

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
      padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
      itemCount: animals.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Dimensions.of(context).insets.medium,
        mainAxisSpacing: Dimensions.of(context).insets.medium,
      ),
      itemBuilder: (BuildContext context, int index) {
        return AnimalBuilder(
          key: ValueKey(animals[index].svgPath),
          svgPath: animals[index].svgPath,
          backgroundColor: animalCardColor,
          preferenceService: preferenceService,
          service: service,
        );
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
