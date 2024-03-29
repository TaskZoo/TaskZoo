import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'dart:ui' as ui;

import 'package:taskzoo/widgets/isar_service.dart';
import 'package:taskzoo/widgets/zoo/animalpieces.dart';

class AnimalBuilder extends StatefulWidget {
  final String svgPath;
  final Color backgroundColor;

  final IsarService service;
  AnimalBuilder(
      {required this.svgPath,
      required this.backgroundColor,
      Key? key,
      required this.service})
      : super(key: key);

  @override
  State<AnimalBuilder> createState() => AnimalBuilderState();
}

class AnimalBuilderState extends State<AnimalBuilder> {
  late Future<int> _numShapesFuture;
  int _numShapes = 0;
  late Future<String> _svgStringDataFuture;
  late int _totalNumShapes;

  @override
  void initState() {
    super.initState();
    _numShapesFuture = getNumShapes();
    _svgStringDataFuture = getSvgString(widget.svgPath);
  }

  Future<int> getNumShapes() async {
    _numShapes =
        await widget.service.getNumShapesFromAnimalPieces(widget.svgPath);
    return _numShapes;
  }

  Future<String> getSvgString(String svgPath) async {
    String svgData = await rootBundle.loadString(svgPath);
    _totalNumShapes = countPathsInSvg(svgData);

    return svgData;
  }

  Future<void> decrementTotalCollectedPieces() async {
    int currentTotalCollectedPieces =
        await widget.service.getPreference("totalCollectedPieces");
    int newTotalCollectedPieces = currentTotalCollectedPieces;
    if (currentTotalCollectedPieces > 0) {
      newTotalCollectedPieces = currentTotalCollectedPieces - 1;
    }

    widget.service
        .setPreference("totalCollectedPieces", newTotalCollectedPieces);
  }

  void addShape() async {
    int currentTotalCollectedPieces =
        await widget.service.getPreference("totalCollectedPieces");
    if (currentTotalCollectedPieces > 0 && _totalNumShapes > _numShapes) {
      setState(() {
        _numShapes += 8;
      });
      decrementTotalCollectedPieces();

      AnimalPieces animalUpdate = AnimalPieces(
          id: getSvgPathId(), pieces: _numShapes, animalName: widget.svgPath);
      widget.service.saveAnimalPieces(animalUpdate);
    }
  }

  int getSvgPathId() {
    // Use the hashCode method to convert the SVG path into an integer ID
    int id = widget.svgPath.hashCode.abs();
    return id;
  }

  int countPathsInSvg(String svgData) {
    // Define a regular expression that matches the path elements
    final pathRegex = RegExp(r'<path[^>]*>', multiLine: true);

    // Count the path elements
    final numPaths = pathRegex.allMatches(svgData).length;

    return numPaths;
  }

  String getBuilderSvg(String originalSvg, int numShapes) {
    // Define a regular expression that matches the SVG root element
    final rootRegex = RegExp(r'<svg[^>]*>', multiLine: true);

    // Find the SVG root element
    final rootMatch = rootRegex.firstMatch(originalSvg);
    if (rootMatch == null) {
      throw Exception('No SVG root element found');
    }
    final rootElement = originalSvg.substring(rootMatch.start, rootMatch.end);

    // Define a regular expression that matches the shape elements
    final shapeRegex = RegExp(r'<path[^>]*?>', multiLine: true);

    // Find the shape elements
    final shapeMatches = shapeRegex.allMatches(originalSvg).toList();

    // Modify the shapes based on their index
    final modifiedShapes = shapeMatches.map((match) {
      String shape = originalSvg.substring(match.start, match.end);

      if (shapeMatches.indexOf(match) >= numShapes) {
        // For shapes after the first n (_numShapes), change their fill and stroke to gray
        shape = shape.replaceAll(RegExp(r'fill="[^"]*"'), 'fill="#000000"');
        shape = shape.replaceAll(RegExp(r'stroke="[^"]*"'), 'stroke="#000000"');
      }

      return shape;
    }).join('\n');

    // Return the new SVG string
    return '$rootElement\n$modifiedShapes\n</svg>';
  }

  Future<ui.Image> getBuilderImage(
      Future<String> svgStringDataFuture, Future<int> numShapesFuture) async {
    // Wait for futures to complete
    String originalSvg = await svgStringDataFuture;
    await numShapesFuture;

    // get builder svg (only shapes that have been collected are colored)
    String builderSvgString = getBuilderSvg(originalSvg, _numShapes);

    // get vector graphics version of builer svg
    PictureInfo builderPictureInfo =
        await vg.loadPicture(SvgStringLoader(builderSvgString), null);

    // get image version of builder svg, 1024x1024 are dimensions of all animal svgs
    ui.Image builderImage =
        await builderPictureInfo.picture.toImage(1024, 1024);

    return builderImage;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: getBuilderImage(_svgStringDataFuture, _numShapesFuture),
      builder: (context, snapshot) {
        Widget? animalBuilderContent;

        if (snapshot.hasData) {
          final svgImageData = snapshot.data!;
          animalBuilderContent = RawImage(
            key: ValueKey('loaded_$_numShapes'), // Composite key
            image: svgImageData,
          );
        } else if (snapshot.hasError) {
          animalBuilderContent = Text('Error: ${snapshot.error}');
        } else {
          animalBuilderContent = Container(
            key: ValueKey('loading'), // Key for the loading state
          );
        }

        return GestureDetector(
          onTap: addShape,
          child: Container(
            padding: EdgeInsets.all(Dimensions.of(context).insets.smaller),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Dimensions.of(context).radii.medium),
              color: widget.backgroundColor,
            ),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: animalBuilderContent,
            ),
          ),
        );
      },
    );
  }
}
