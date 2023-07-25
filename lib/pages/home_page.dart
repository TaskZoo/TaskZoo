import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/widgets/home/Appbar.dart';
import 'package:taskzoo/widgets/preference_service.dart';
import 'package:taskzoo/widgets/home/HomeStatsCard.dart';
import 'package:taskzoo/widgets/tasks/add_task.dart';
import 'package:taskzoo/widgets/tasks/task.dart';
import 'package:taskzoo/widgets/tasks/task_card.dart';
import 'package:taskzoo/widgets/isar_service.dart';

class HomePage extends StatefulWidget {
  final IsarService service;
  final PreferenceService preferenceService;
  HomePage({Key? key, required this.service, required this.preferenceService})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> selectedTags = [];
  ValueNotifier<String> selectedSchedule = ValueNotifier<String>('Daily');

  void _createTaskButton() {
    showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTaskSheet(widget.service),
    );
  }

  void updateSelectedSchedule(ValueNotifier<String> schedule) {
    selectedSchedule = schedule;
  }

  void updateSelectedTags(List<String> tags) {
    setState(() {
      selectedTags = tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onAddTaskPressed: _createTaskButton,
        selectedSchedule: selectedSchedule,
        onUpdateSelectedTags: updateSelectedTags,
        tasks: widget.service.getAllTasks(),
      ),
      body: Column(
        children: [
          HomeStatsCard(
            totalCollectedPiecesStream:
                widget.preferenceService.totalCollectedPiecesStream,
            countTasks: widget.service.countTasks,
            countCompletedTasks: widget.service.countCompletedTasks,
            selectedSchedule: selectedSchedule,
            selectedTags: selectedTags,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.of(context)
                  .insets
                  .medium), // Move the Padding widget here
              child: ValueListenableBuilder<String>(
                valueListenable: selectedSchedule,
                builder: (context, value, child) {
                  return StreamBuilder<List<Task>>(
                    stream: widget.service.filterTasksByScheduleAndSelectedTags(
                      value,
                      selectedTags,
                    ),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Task>> snapshot) {
                      if (snapshot.hasData) {
                        final tasks = snapshot.data!;
                        return GridView.count(
                          mainAxisSpacing: Dimensions.of(context).insets.medium,
                          crossAxisSpacing:
                              Dimensions.of(context).insets.medium,
                          crossAxisCount: 2,
                          children: tasks
                              .map(
                                (task) => TaskCard(
                                    task: task,
                                    service: widget.service,
                                    preferenceService:
                                        widget.preferenceService),
                              )
                              .toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<int> getTotalCollectedPieces() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  int totalCollectedPieces = prefs.getInt('totalCollectedPieces') ?? 0;

  return totalCollectedPieces;
}
