import 'package:flutter/material.dart';

class HomeStatsCard extends StatelessWidget {
  final List<StreamBuilder<int>> icons; // Change the type to StreamBuilder<int>

  const HomeStatsCard({Key? key, required this.icons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: icons, // Build each StreamBuilder widget in the list
        ),
      ),
    );
  }
}
