import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskzoo/widgets/isar_service.dart';

import 'package:taskzoo/widgets/zoo/Appbar.dart';
import 'package:taskzoo/widgets/zoo/BackgroundImage.dart';
import 'package:taskzoo/widgets/zoo/ZooBody.dart';

import 'package:taskzoo/misc/biomes_model.dart';
import 'package:taskzoo/misc/hex_color.dart';
import 'package:taskzoo/misc/zoo_notifier.dart';

class ZooPage extends StatefulWidget {
  final IsarService service;

  const ZooPage({Key? key, required this.service}) : super(key: key);

  @override
  _ZooPageState createState() => _ZooPageState();
}

class _ZooPageState extends State<ZooPage> {
  late Future<Biomes> _biomesFuture;

  @override
  void initState() {
    super.initState();
    _biomesFuture = loadBiomesData('assets/biomes_data/biomes_data.json');
    _biomesFuture.then((biomesData) => precacheImages(biomesData));
  }

  Future<Biomes> loadBiomesData(String jsonPath) async {
    String jsonString = await rootBundle.loadString(jsonPath);
    final jsonData = json.decode(jsonString);
    final biomesData = Biomes.fromJson(jsonData);

    return biomesData;
  }

  void precacheImages(Biomes biomesData) {
    for (var biome in biomesData.biomes) {
      precacheImage(AssetImage(biome.backgroundPath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // get the ZooNotifier
    final zooNotifier = Provider.of<ZooNotifier>(context);

    return FutureBuilder<Biomes>(
      future: _biomesFuture,
      builder: (BuildContext context, AsyncSnapshot<Biomes> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error loading data'),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: HexColor(
                snapshot.data!.biomes[zooNotifier.currentBiome].primaryColor),
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: CustomAppBar(biomesData: snapshot.data!),
            body: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                BackgroundImage(
                    imagePath: snapshot
                        .data!.biomes[zooNotifier.currentBiome].backgroundPath),
                ZooBody(biomesData: snapshot.data!, service: widget.service),
              ],
            ),
          );
        }
      },
    );
  }
}
