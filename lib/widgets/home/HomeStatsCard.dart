import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  Widget _buildStreamWidget(Stream<int> stream, Icon icon) {
  return StreamBuilder<int>(
    stream: stream,
    builder: (context, snapshot) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 5.0),
          if (snapshot.hasData)
            Text(snapshot.data!.toString(), style: TextStyle(fontSize: 16),)
          else
            CircularProgressIndicator(),
        ],
      );
    },
  );
}


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
              borderRadius: BorderRadius.circular(15.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStreamWidget(totalCollectedPiecesStream, Icon(FontAwesomeIcons.puzzlePiece)),
                _buildStreamWidget(countTasks(value, selectedTags), Icon(FontAwesomeIcons.listCheck)),
                _buildStreamWidget(countCompletedTasks(value, selectedTags), Icon(FontAwesomeIcons.check)),
              ],
            ),
          ),
        );
      },
    );
  }
}
