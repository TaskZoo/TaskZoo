import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimalBuilder extends StatefulWidget {
  AnimalBuilder({required this.svgPath, required this.backgroundColor, Key? key}) : super(key: key);

  final String svgPath;
  final Color backgroundColor;

  @override
  State<AnimalBuilder> createState() => AnimalBuilderState();
}

class AnimalBuilderState extends State<AnimalBuilder> {
  int _numShapes = 0;
  late Future<String> svgDataFuture;
  int _totalNumShapes = 0;

  Future<String> loadSvgData(String assetName) async {
    return await rootBundle.loadString(assetName);
  }

  @override
  void initState() {
    super.initState();
    svgDataFuture = loadSvgData(widget.svgPath);
  }

  void addShape() {
    setState(() {
      _numShapes += 50;
    });
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

  int countPathsInSvg(String svgData) {
    // Define a regular expression that matches the path elements
    final pathRegex = RegExp(r'<path[^>]*>', multiLine: true);

    // Count the path elements
    final numPaths = pathRegex.allMatches(svgData).length;

    return numPaths;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: svgDataFuture,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // svg data starts with empty image (this wont change if no data is loaded)
        String svgData =
            '''<?xml version="1.0" encoding="UTF-8"?><svg xmlns="http://www.w3.org/2000/svg" width="1" height="1"/>''';

        if (snapshot.connectionState == ConnectionState.done) {
          // get svg string data based on svg file and number of desired shapes
          svgData = snapshot.data!;
          // find total number of shapes so we can tell user how close they are to being complete with this shape
          _totalNumShapes = countPathsInSvg(svgData);
          svgData = getBuilderSvg(svgData, _numShapes);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return GestureDetector(
          onTap: addShape,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: widget.backgroundColor,
            ),
            child: SvgPicture.string(
              svgData,
            ),
          ),
        );
      },
    );
  }
}