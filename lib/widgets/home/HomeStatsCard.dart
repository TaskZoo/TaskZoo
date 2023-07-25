import 'package:flutter/material.dart';

class HomeStatsCard extends StatelessWidget {
  final Stream<int> totalCollectedPiecesStream;
  final Stream<int> Function(String, List<String>) countTasks;
  final Stream<int> Function(String, List<String>) countCompletedTasks;
  final ValueNotifier<String> selectedSchedule;
  final List<String> selectedTags;

  const HomeStatsCard({
    Key? key,
    required this.totalCollectedPiecesStream,
    required this.countTasks,
    required this.countCompletedTasks,
    required this.selectedSchedule,
    required this.selectedTags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedSchedule,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<int>(
                  stream: totalCollectedPiecesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int totalCollectedPieces = snapshot.data!;
                      return Text(totalCollectedPieces.toString());
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                StreamBuilder<int>(
                  stream: countTasks(value, selectedTags),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int totalTasks = snapshot.data!;
                      return Text(totalTasks.toString());
                    } else {
                      return CircularProgressIndicator(); // or any other placeholder widget
                    }
                  },
                ),
                StreamBuilder<int>(
                  stream: countCompletedTasks(value, selectedTags),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      int completed = snapshot.data!;
                      return Text(completed.toString());
                    } else {
                      return CircularProgressIndicator(); // or any other placeholder widget
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
