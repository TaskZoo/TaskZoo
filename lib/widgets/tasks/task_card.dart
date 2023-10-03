import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flutter/services.dart';
import 'package:progress_border/progress_border.dart';

import 'package:taskzoo/widgets/isar_service.dart';
import 'package:taskzoo/widgets/notifications/notification_service.dart';
import 'package:taskzoo/widgets/tasks/edit_task.dart';
import 'package:taskzoo/widgets/tasks/sound_player.dart';
import 'package:taskzoo/widgets/tasks/task.dart';
import 'package:flip_card/flip_card.dart';

String startOfWeek = "Monday";

class TaskCard extends StatefulWidget {
  final Task task;
  final IsarService service;

  TaskCard({
    Key? key,
    required this.task,
    required this.service,
  }) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with TickerProviderStateMixin {
  late DateTime previousDate;
  late DateTime nextCompletionDate;
  late HashSet<DateTime> completedDates;
  late bool isCompleted;
  late int currentCycleCompletions;
  late int timesPerMonth;

  late bool isFacingFront;
  late FlipCardController _controller;

  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _borderWidth;
  //bool increment = false;

  //Make modifications to previous date when storing data persistently
  @override
  void initState() {
    super.initState();
    previousDate = DateTime.parse(widget.task.previousDate);
    nextCompletionDate = DateTime.parse(widget.task.nextCompletionDate);
    completedDates = HashSet<DateTime>.from(
        widget.task.completedDates.map((date) => DateTime.parse(date)));
    isCompleted = widget.task.isCompleted;
    currentCycleCompletions = widget.task.currentCycleCompletions;
    timesPerMonth = widget.task.timesPerMonth;

    scheduleNotifications(widget.task.notificationDays, widget.task.id,
        widget.task.notificationTime, widget.task.title, widget.service);

    nextCompletionDate = calculateNextCompletionDate(
        determineFrequency(
          widget.task.daysOfWeek,
          widget.task.biDaily,
          widget.task.weekly,
          widget.task.monthly,
        ),
        previousDate);
    widget.task.last30DaysDates = _getLast30DaysDates();
    widget.task.completionCount30days =
        _getCompletionCount(widget.task.last30DaysDates);

    updateTaskSchema();

    _controller = FlipCardController();
    isFacingFront = true;

    _progressController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _borderWidth = Tween<double>(begin: 2, end: 2).animate(_pulseController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _progressController.reset();
          _pulseController.reverse();
        }
      });

    _progressController.addListener(() {
      if (_progressController.value == 1.0) {
        if (!isCompleted && widget.task.isMeantForToday) {
          setState(() {
            String schedule = determineFrequency(
              widget.task.daysOfWeek,
              widget.task.biDaily,
              widget.task.weekly,
              widget.task.monthly,
            );

            updatePiecesInformation();
            isCompleted = true;
            widget.task.isCompleted = isCompleted;
            hapticFeedback();
            completionSound();
            _streakAndStatsHandler(schedule);
            addCompletionCountEntry();
          });
        }
        _pulseController.forward();
      }
    });
  }

  void flipCardIfNeeded() {
    if ((_controller.state != null && _controller.state!.isFront ||
        !isFacingFront)) {
      isFacingFront = true;
      _controller.toggleCardWithoutAnimation();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String schedule = determineFrequency(
      widget.task.daysOfWeek,
      widget.task.biDaily,
      widget.task.weekly,
      widget.task.monthly,
    );

    String monthlyOrWeekly = (schedule == "monthly") ? "month" : "week";

    //Reset completion
    _completionResetHandler();

    //Handle setting and resetting stats based on the schedule
    _streakAndStatsHandler(schedule);

    //Handles Weekly/Monthly completions
    _setCompletionStatus(schedule);

    // flipCardIfNeeded();

    return GestureDetector(
        onLongPressStart: (details) {
          if (!isCompleted && widget.task.isMeantForToday && isFacingFront) {
            _progressController.animateTo(1);
          }
        },
        onLongPressEnd: (details) {
          if (!_progressController.isCompleted) {
            _progressController.animateBack(0);
          }
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([_progressController, _pulseController]),
          builder: (context, child) {
            return Container(
                child: FlipCard(
              controller: _controller,
              onFlip: () {
                isFacingFront = !isFacingFront;
              },
              fill: Fill.fillBack,
              direction: FlipDirection.HORIZONTAL,
              side: CardSide.FRONT,
              front: _getCardFront(schedule),
              back: _getCardBack(schedule),
            ));
          },
        ));
  }

  Widget _getFrontTopInfo() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: Dimensions.of(context).insets.small),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.task.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.task.tag,
          ),
        ],
      ),
    );
  }

  Widget _getFrontBottomInfo(String schedule) {
    // if the task is not meant for today we can tell user to chill
    if (!widget.task.isMeantForToday) {
      return const Center(
        child: Text('Relax, not today!'),
      );
    }

    // if the task is completed the user gets a checkmark
    if (isCompleted) {
      return Center(
        child: SvgPicture.asset("assets/custom_icons/check.svg",
            color: Theme.of(context).iconTheme.color, semanticsLabel: 'Check'),
      );
    }

    // if neither of the two above apply, we need to let the user know how much time/tasks they have left

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/custom_icons/clock.svg",
            color: Theme.of(context).iconTheme.color, semanticsLabel: 'Clock'),
        SizedBox(width: Dimensions.of(context).insets.smaller),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getTimeUntilNextCompletionDate()),
            if (_setCompletionStatus(schedule) > 0)
              Text(
                '${_setCompletionStatus(schedule)} tasks left',
              ),
          ],
        ),
      ],
    );
  }

  Widget _getCardFront(String schedule) {
    return Container(
      padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(Dimensions.of(context).radii.medium),
        color: Theme.of(context).cardColor,
        border: ProgressBorder.all(
          color: Theme.of(context).indicatorColor,
          width: _borderWidth.value, // Use animated border width
          progress: _progressController.value,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
      ),
      child: Opacity(
        opacity: widget.task.isMeantForToday ? 1 : 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getFrontTopInfo(),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            _getFrontBottomInfo(schedule),
          ],
        ),
      ),
    );
  }

  Widget _getCardBack(schedule) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(Dimensions.of(context).radii.medium),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return EditTaskSheet(
                    title: widget.task.title,
                    tag: widget.task.tag,
                    daysOfWeek: widget.task.daysOfWeek,
                    biDaily: widget.task.biDaily,
                    weekly: widget.task.weekly,
                    monthly: widget.task.monthly,
                    timesPerWeek: widget.task.timesPerWeek,
                    timesPerMonth: timesPerMonth,
                    enableNotifications: widget.task.notificationsEnabled,
                    notificationsDays: widget.task.notificationDays,
                    selectedTime:
                        parseTimeFromString(widget.task.notificationTime),
                    onUpdateTask: (editedTaskData) {
                      setState(() {
                        widget.task.title = editedTaskData['title'];
                        widget.task.tag = editedTaskData['tag'];
                        widget.task.daysOfWeek = editedTaskData['daysOfWeek'];
                        widget.task.biDaily = editedTaskData['biDaily'];
                        widget.task.weekly = editedTaskData['weekly'];
                        widget.task.monthly = editedTaskData['monthly'];
                        widget.task.timesPerWeek =
                            editedTaskData['timesPerWeek'];
                        timesPerMonth = editedTaskData['timesPerMonth'];
                        widget.task.schedule = editedTaskData['schedule'];
                        widget.task.notificationDays =
                            editedTaskData['notificationsDays'];
                        widget.task.notificationTime =
                            editedTaskData['selectedTime'].toString();
                        widget.task.notificationsEnabled =
                            editedTaskData['notificationsEnabled'];
                        deleteAllNotifications(widget.task.id, widget.service);
                        scheduleNotifications(
                            widget.task.notificationDays,
                            widget.task.id,
                            widget.task.notificationTime,
                            widget.task.title,
                            widget.service);
                        isCompletedFalse(schedule);
                        updateTaskSchema();
                      });
                    },
                  );
                },
              );
            },
            child: SvgPicture.asset("assets/custom_icons/pencil.svg",
                color: Theme.of(context).iconTheme.color,
                semanticsLabel: 'Pencil'),
          ),
          SizedBox(width: Dimensions.of(context).insets.medium),
          Container(
            width: 1.0,
            height: 40,
            color: Theme.of(context).dividerColor,
          ),
          SizedBox(width: Dimensions.of(context).insets.medium),
          GestureDetector(
            onTap: () {
              // Show a dialog to confirm the deletion
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                        dialogBackgroundColor: Theme.of(context).cardColor),
                    child: AlertDialog(
                      title: const Text('Delete Task'),
                      content: const Text(
                          'Are you sure you want to delete this task?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Theme.of(context).indicatorColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Delete',
                            style: TextStyle(
                                color: Theme.of(context).indicatorColor),
                          ),
                          onPressed: () {
                            deleteTask();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            Dimensions.of(context).radii.medium),
                      ),
                    ),
                  );
                },
              );
            },
            child: SvgPicture.asset("assets/custom_icons/trash.svg",
                color: Theme.of(context).iconTheme.color,
                semanticsLabel: 'Trash'),
          ),
        ],
      ),
    );
  }

  void isCompletedFalse(String schedule) {
    if (completedDates.isNotEmpty) {
      DateTime earliestDate =
          completedDates.reduce((a, b) => a.isBefore(b) ? a : b);
      completedDates.remove(earliestDate);
      setState(() {
        isCompleted = false;
      });
    }
  }

  String determineFrequency(
    List<bool> daysOfWeek,
    bool biDaily,
    bool weekly,
    bool monthly,
  ) {
    if (daysOfWeek.any((day) => day == true)) {
      return 'custom';
    } else if (weekly) {
      return 'weekly';
    } else if (monthly) {
      return 'monthly';
    } else if (biDaily) {
      return 'biDaily';
    } else {
      return 'daily';
    }
  }

  String _getTimeUntilNextCompletionDate() {
    final now = DateTime.now();
    final difference = nextCompletionDate.difference(now);

    // print(
    //     "${widget.task.title}: Now - ${now}, NextCompletionDate - ${nextCompletionDate}, Difference - ${difference}");
    updateTaskSchema();

    String schedule = determineFrequency(
      widget.task.daysOfWeek,
      widget.task.biDaily,
      widget.task.weekly,
      widget.task.monthly,
    );

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    // print(
    //     "${widget.task.title}: ${widget.task.nextCompletionDate}: $difference");

    if (schedule == "biDaily") {
      if (hours > 24) {
        return "${hours - 24} hours left";
      } else {
        return "$hours hours left";
      }
    }
    if (days >= 1) {
      return "$days days left";
    } else if (hours > 0) {
      return "$hours hours left";
    } else {
      return "Under 1 hour left";
    }
  }

  List<String> _getLast30DaysDates() {
    final today = DateTime.now();
    final last30DaysDates = <String>[];
    for (int i = 0; i < 30; i++) {
      final date = today.subtract(Duration(days: i));
      last30DaysDates
          .add(DateTime(date.year, date.month, date.day).toIso8601String());
    }
    return last30DaysDates;
  }

  int _getCompletionCount(List<String> last30DaysDates) {
    int count = 0;
    for (final date in last30DaysDates) {
      if (completedDates.contains(DateTime.parse(date))) {
        count++;
      }
    }
    return count;
  }

  int _setCompletionStatus(String schedule) {
    int remainingCompletions = 0;
    if (schedule == "weekly") {
      if (currentCycleCompletions < widget.task.timesPerWeek) {
        isCompleted = false;
        remainingCompletions =
            widget.task.timesPerWeek - currentCycleCompletions;
        return remainingCompletions;
      } else {
        return 0;
      }
    } else if (schedule == "monthly") {
      if (currentCycleCompletions < timesPerMonth) {
        isCompleted = false;
        remainingCompletions = timesPerMonth - currentCycleCompletions;
        return remainingCompletions;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  }

  //TODO: Refactor this method before release
  void _streakAndStatsHandler(String schedule) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);
    if (schedule == "daily") {
      widget.task.isMeantForToday = true;
      if (isCompleted) {
        if (!completedDates.contains(today)) {
          completedDates.add(today);
          previousDate = today;
          nextCompletionDate =
              calculateNextCompletionDate(schedule, previousDate);
          updateTaskSchema();
        }
      } else if (nextCompletionDate.isBefore(now)) {
        nextCompletionDate = calculateNextCompletionDate(schedule, today);
      }
    } else if (schedule == "custom") {
      //Requires further testing
      widget.task.isMeantForToday = widget.task.daysOfWeek[now.weekday - 1];
      if (isCompleted && widget.task.isMeantForToday) {
        if (!completedDates.contains(today)) {
          if (widget.task.isMeantForToday) {
            completedDates.add(today);
            previousDate = today;
            nextCompletionDate =
                calculateNextCompletionDate(schedule, previousDate);
            updateTaskSchema();
          }
        }
      } else if ((nextCompletionDate.difference(now).inHours) > 24) {
        nextCompletionDate = calculateNextCompletionDate(schedule, today);
      }
    } else if (schedule == "biDaily") {
      int daysDifference = nextCompletionDate.difference(today).inDays;
      if (daysDifference % 2 == 0) {
        widget.task.isMeantForToday = true;
      } else {
        widget.task.isMeantForToday = false;
      }
      if (isCompleted) {
        if (!completedDates.contains(today)) {
          completedDates.add(today);
          previousDate = today;
          nextCompletionDate =
              calculateNextCompletionDate(schedule, previousDate);
          updateTaskSchema();
        }
      } else if (nextCompletionDate.isBefore(now) &&
          widget.task.isMeantForToday) {
        nextCompletionDate = calculateNextCompletionDate(schedule, today);
      }
      // print(nextCompletionDate);
    } else if (schedule == "weekly") {
      widget.task.isMeantForToday = true;
      if (isCompleted) {
        if (!completedDates.contains(today)) {
          currentCycleCompletions++;
          updateTaskSchema();
          if (currentCycleCompletions >= widget.task.timesPerWeek) {
            completedDates.add(today);
            previousDate = today;
            nextCompletionDate =
                calculateNextCompletionDate(schedule, previousDate);
            updateTaskSchema();
          }
        }
      } else if (nextCompletionDate.isBefore(now)) {
        nextCompletionDate = calculateNextCompletionDate(schedule, today);
      }
    } else if (schedule == "monthly") {
      if (isCompleted) {
        if (!completedDates.contains(today)) {
          // print("Incremented");
          currentCycleCompletions++;
          updateTaskSchema();
          if (currentCycleCompletions >= timesPerMonth) {
            completedDates.add(today);
            previousDate = today;
            nextCompletionDate =
                calculateNextCompletionDate(schedule, previousDate);
            updateTaskSchema();
          }
        }
      } else if (nextCompletionDate.isBefore(now)) {
        nextCompletionDate = calculateNextCompletionDate(schedule, today);
      }
    }
  }

  void _completionResetHandler() {
    //NOTE: Potential Fix: Check if current date is before next completion date if so dont change
    if (isCompleted &&
        !(completedDates.contains(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, 0, 0, 0)))) {
      isCompleted = false;
      updateTaskSchema();
    }
  }

  DateTime calculateNextCompletionDate(
      String schedule, DateTime previousCompletionDate) {
    DateTime nextValidDate = previousCompletionDate;

    switch (schedule) {
      case 'daily':
        return previousCompletionDate.add(const Duration(days: 1));
      case 'custom':
        final mondayShifted = shiftRight(widget.task.daysOfWeek, 1);
        final daysOfWeek = widget.task.daysOfWeek;
        final currentDay = previousCompletionDate.weekday;
        final nextValidDay = (currentDay) % 7; // Get the next day index
        final now = DateTime.now();

        if (mondayShifted[nextValidDay] == true) {
          nextValidDate = DateTime(now.year, now.month, now.day)
              .add(const Duration(hours: 23, minutes: 59));
          return nextValidDate;
        }
        // Find the next true day of the week
        int count = 0;
        for (int i = nextValidDay; i < 7; i++) {
          count++;
          if (daysOfWeek[i]) {
            nextValidDate = DateTime(now.year, now.month, now.day + count)
                .add(const Duration(hours: 23, minutes: 59));
            break;
          }
        }
        return nextValidDate;
      case 'weekly':
        final currentDate = DateTime.now();
        final currentDay = currentDate.weekday;
        int daysUntilNextDay = (7 + getDayOfWeek(startOfWeek) - currentDay) % 7;
        if (daysUntilNextDay == 0) daysUntilNextDay = 7;
        final nextDay = currentDate.add(Duration(days: daysUntilNextDay));
        final nextDayAtMidnight =
            DateTime(nextDay.year, nextDay.month, nextDay.day, 0, 0, 0);
        return nextDayAtMidnight;

      case 'monthly':
        if (previousCompletionDate.month == 12) {
          nextValidDate = DateTime(previousCompletionDate.year + 1, 1, 1);
        } else {
          nextValidDate = DateTime(
              previousCompletionDate.year, previousCompletionDate.month + 1, 1);
        }
        return nextValidDate;
      case 'biDaily':
        return previousCompletionDate.add(const Duration(days: 2));
      default:
        return previousCompletionDate.add(const Duration(days: 1));
    }
  }

  List<bool> shiftRight(List<bool> array, int n) {
    List<bool> shiftedArray = List.from(array);
    final int size = array.length;

    for (int i = 0; i < size; i++) {
      int newIndex = (i + n) % size;
      shiftedArray[newIndex] = array[i];
    }

    return shiftedArray;
  }

  void updateTaskSchema() {
    // // Convert DateTime objects back into their ISO8601 string form
    widget.task.previousDate = previousDate.toIso8601String();
    widget.task.nextCompletionDate = nextCompletionDate.toIso8601String();
    widget.task.completedDates =
        completedDates.map((date) => date.toIso8601String()).toList();
    widget.task.isCompleted = isCompleted;
    widget.task.currentCycleCompletions = currentCycleCompletions;

    //saves Task to TaskSchema
    widget.service.saveTask(widget.task);
  }

  void updatePiecesInformation() async {
    // Get the current value of totalAnimalPieces from the box
    String schedule = determineFrequency(
      widget.task.daysOfWeek,
      widget.task.biDaily,
      widget.task.weekly,
      widget.task.monthly,
    );
    int increment = 1;

    if (schedule == 'custom') {
      increment = 2;
    } else if (schedule == 'weekly') {
      increment = 2;
    } else if (schedule == 'monthly') {
      increment = 3;
    } else if (schedule == 'daily') {
      increment = 1;
    }

    widget.task.piecesObtained += increment;
    incrementTotalCollectedPieces(increment);
  }

  void deleteTask() async {
    deleteAllNotifications(widget.task.id, widget.service);
    widget.service.deleteTask(widget.task);
  }

  int getDayOfWeek(String day) {
    switch (day.toLowerCase()) {
      case "monday":
        return 1;
      case "tuesday":
        return 2;
      case "wednesday":
        return 3;
      case "thursday":
        return 4;
      case "friday":
        return 5;
      case "saturday":
        return 6;
      case "sunday":
        return 7;
      default:
        throw ArgumentError("Invalid day of the week: $day");
    }
  }

  Future<void> incrementTotalCollectedPieces(int pieceChange) async {
    int currentTotalCollectedPieces =
        await widget.service.getPreference("totalCollectedPieces");
    int newTotalCollectedPieces = currentTotalCollectedPieces + pieceChange;
    widget.service
        .setPreference("totalCollectedPieces", newTotalCollectedPieces);
  }

  Future<void> hapticFeedback() async {
    bool hapticFeedbackEnabled = await widget.service
        .getPreference("hapticFeedback")
        .then((value) => value != 0);
    if (hapticFeedbackEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void completionSound() async {
    bool soundEnabled =
        await widget.service.getPreference("sound").then((value) => value != 0);
    if (soundEnabled) {
      // SoundPlayer soundPlayer = SoundPlayer();
      // soundPlayer.playSound();
      AudioPlayerService audioPlayerService = AudioPlayerService();
      audioPlayerService.play();
    }
  }

  Future<void> configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  void addCompletionCountEntry() {
    widget.service.updateDailyCompletionEntry(true);
  }

  TimeOfDay parseTimeFromString(String timeString) {
    // print("TimeString: $timeString");
    int hour = int.parse(timeString.substring(10, 12));
    int minute = int.parse(timeString.substring(13, 15));
    return TimeOfDay(hour: hour, minute: minute);
  }
}
