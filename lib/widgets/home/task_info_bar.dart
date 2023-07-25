import 'package:flutter/material.dart';
import 'package:taskzoo/widgets/tasks/rear_task_card_item.dart';

class RearTaskCard extends StatelessWidget {
  final List<StreamBuilder<int>> icons; // Change the type to StreamBuilder<int>

  const RearTaskCard({Key? key, required this.icons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0),
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
