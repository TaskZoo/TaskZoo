import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskzoo/widgets/isar_service.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/widgets/zoo/AnimalBuilder.dart';

import 'package:taskzoo/misc/biomes_model.dart';
import 'package:taskzoo/misc/hex_color.dart';
import 'package:taskzoo/misc/zoo_notifier.dart';

class ZooBody extends StatelessWidget {
  final Biomes biomesData;
  final IsarService service;

  ZooBody({required this.biomesData, required this.service});

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
          service: service,
        );
      },
    );
  }
}
