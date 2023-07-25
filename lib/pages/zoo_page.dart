import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskzoo/widgets/preference_service.dart';

import 'package:taskzoo/widgets/zoo/Appbar.dart';
import 'package:taskzoo/widgets/zoo/BackgroundImage.dart';
import 'package:taskzoo/widgets/zoo/ZooBody.dart';

import 'package:taskzoo/misc/biomes_model.dart';

import 'package:taskzoo/misc/zoo_notifier.dart';

class ZooPage extends StatefulWidget {
  final PreferenceService preferenceService;

  const ZooPage({Key? key, required this.preferenceService}) : super(key: key);

  @override
  _ZooPageState createState() => _ZooPageState();
}

class _ZooPageState extends State<ZooPage> {
  late Future<Biomes> _biomesFuture;

  @override
  void initState() {
    super.initState();
    _biomesFuture = loadBiomesData('assets/biomes_data.json');
  }

  Future<Biomes> loadBiomesData(String jsonPath) async {
    String jsonString = await rootBundle.loadString(jsonPath);
    final jsonData = json.decode(jsonString);
    final biomesData = Biomes.fromJson(jsonData);

    return biomesData;
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
                ZooBody(
                    biomesData: snapshot.data!,
                    preferenceService: widget.preferenceService),
              ],
            ),
          );
        }
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
