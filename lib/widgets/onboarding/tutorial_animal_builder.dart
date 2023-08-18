import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TutorialAnimalBuilder extends StatefulWidget {
  final String svgPath;

  TutorialAnimalBuilder({required this.svgPath});

  @override
  _TutorialAnimalBuilderState createState() => _TutorialAnimalBuilderState();
}

class _TutorialAnimalBuilderState extends State<TutorialAnimalBuilder> {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      widget.svgPath,
      height: 175,
    );
  }
}
