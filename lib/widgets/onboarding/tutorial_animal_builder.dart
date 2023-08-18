import 'dart:async';

import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TutorialAnimalBuilder extends StatefulWidget {
  final String svgPath;

  TutorialAnimalBuilder({required this.svgPath});

  @override
  _TutorialAnimalBuilderState createState() => _TutorialAnimalBuilderState();
}

class _TutorialAnimalBuilderState extends State<TutorialAnimalBuilder> {
  int _numShapes = 0;
  late Future<String> svgDataFuture;
  int _totalNumShapes = 0;
  late Timer _timer;

  Future<String> loadSvgData(String assetName) async {
    return await rootBundle.loadString(assetName);
  }

  @override
  void initState() {
    super.initState();
    svgDataFuture = loadSvgData(widget.svgPath);

    Future.delayed(Duration(seconds: 1), () {
      _timer = Timer.periodic(Duration(milliseconds: 250), (Timer t) {
        addShape();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void addShape() {
    if (_numShapes >= _totalNumShapes) {
      _timer.cancel(); // Cancel the existing timer

      // Introduce a delay of one second
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _numShapes = 0; // Reset the number of shapes
        });

        // Restart the timer after the delay
        _timer = Timer.periodic(Duration(milliseconds: 250), (Timer t) {
          addShape();
        });
      });
    } else {
      setState(() {
        _numShapes += 5;
      });
    }
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

        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: SvgPicture.string(
            svgData,
            height: 175,
            key: ValueKey<int>(
                _numShapes), // Unique key based on the number of shapes
          ),
        );
      },
    );
  }
}
