import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/widgets/isar_service.dart';
import 'package:taskzoo/widgets/notifications/notification_service.dart';
import 'package:taskzoo/widgets/preference_service.dart';
import 'package:taskzoo/widgets/tasks/edit_task.dart';
import 'package:taskzoo/widgets/tasks/task.dart';

String startOfWeek = "Monday";

class TaskCard extends StatefulWidget {
  final Task task;
  final IsarService service;
  final PreferenceService preferenceService;

  TaskCard(
      {Key? key,
      required this.task,
      required this.service,
      required this.preferenceService})
      : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isTapped = false;
  late DateTime previousDate;
  late DateTime nextCompletionDate;
  late HashSet<DateTime> completedDates;

  //Make modifications to previous date when storing data persistently
  @override
  void initState() {
    super.initState();
    previousDate = DateTime.parse(widget.task.previousDate);
    nextCompletionDate = DateTime.parse(widget.task.nextCompletionDate);
    completedDates = HashSet<DateTime>.from(
        widget.task.completedDates.map((date) => DateTime.parse(date)));

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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
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
    if (widget.task.isCompleted) {
      return const Center(
        child: Icon(
          FontAwesomeIcons.check,
        ),
      );
    }

    // if neither of the two above apply, we need to let the user know how much time/tasks they have left

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.of(context).insets.small),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(FontAwesomeIcons.clock),
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
        ));
  }

  Widget _getCardFront(String schedule) {
    return Opacity(
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
    );
  }

  Widget _getCardBack(schedule) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            print(widget.task.notificationTime);
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
                  timesPerMonth: widget.task.timesPerMonth,
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
                      widget.task.timesPerWeek = editedTaskData['timesPerWeek'];
                      widget.task.timesPerMonth =
                          editedTaskData['timesPerMonth'];
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
          child: const Icon(
            Icons.edit,
          ),
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
                  data: Theme.of(context)
                      .copyWith(dialogBackgroundColor: Theme.of(context).cardColor),
                  child: AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text(
                        'Are you sure you want to delete this task?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel', style: TextStyle(color: Theme.of(context).indicatorColor),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Delete', style: TextStyle(color: Theme.of(context).indicatorColor),),
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
          child: const Icon(
            Icons.delete,
          ),
        ),
      ],
    );
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

    //Set notifications
    scheduleNotifications(widget.task.notificationDays, widget.task.id,
        widget.task.notificationTime, widget.task.title, widget.service);
    //printAllScheduledNotifications();

    //Reset completion
    _completionResetHandler();

    //Handle setting and resetting stats based on the schedule
    _streakAndStatsHandler(schedule);

    //Handles Weekly/Monthly completions
    _setCompletionStatus(schedule);

    return GestureDetector(
        onTap: () {
          setState(() {
            _isTapped = !_isTapped;
          });
        },
        onLongPress: !widget.task.isCompleted &&
                !_isTapped &&
                widget.task.isMeantForToday
            ? () {
                setState(() {
                  updatePiecesInformation();
                  widget.task.isCompleted = true;
                  addCompletionCountEntry();
                  _streakAndStatsHandler(schedule);
                });
              }
            : null,
        child: Container(
            padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Dimensions.of(context).radii.medium),
              color: Theme.of(context).cardColor,
            ),
            child:
                _isTapped ? _getCardBack(schedule) : _getCardFront(schedule)));
  }

  // Rest of the code remains the same...

  void isCompletedFalse(String schedule) {
    if (completedDates.isNotEmpty) {
      DateTime earliestDate =
          completedDates.reduce((a, b) => a.isBefore(b) ? a : b);
      completedDates.remove(earliestDate);
      setState(() {
        widget.task.isCompleted = false;
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

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 1) {
      return "$days days left";
    } else if (days == 1) {
      return "1 day left";
    } else if (hours > 0) {
      return "$hours hours left";
    } else {
      return "$minutes min left";
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
      if (widget.task.currentCycleCompletions < widget.task.timesPerWeek) {
        widget.task.isCompleted = false;
        remainingCompletions =
            widget.task.timesPerWeek - widget.task.currentCycleCompletions;
        return remainingCompletions;
      } else {
        return 0;
      }
    } else if (schedule == "monthly") {
      if (widget.task.currentCycleCompletions < widget.task.timesPerMonth) {
        widget.task.isCompleted = false;
        remainingCompletions =
            widget.task.timesPerMonth - widget.task.currentCycleCompletions;
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
      widget.task.isStreakContinued = now.isBefore(nextCompletionDate);
      if (widget.task.isStreakContinued && widget.task.isCompleted) {
        if (!completedDates.contains(today)) {
          completedDates.add(today);
          print("added");
          widget.task.last30DaysDates = _getLast30DaysDates();
          widget.task.completionCount30days =
              _getCompletionCount(widget.task.last30DaysDates);
          widget.task.streakCount++;
          if (widget.task.streakCount > widget.task.longestStreak) {
            widget.task.longestStreak = widget.task.streakCount;
          }
          previousDate = today;
          nextCompletionDate =
              calculateNextCompletionDate(schedule, previousDate);
          updateTaskSchema();
        }
      }
      if (!widget.task.isStreakContinued) {
        widget.task.streakCount = 0;
        nextCompletionDate =
            calculateNextCompletionDate(schedule, DateTime.now());
        updateTaskSchema();
      }
    } else if (schedule == "custom") {
      //Requires further testing
      widget.task.isMeantForToday = widget.task.daysOfWeek[now.weekday - 1];
      widget.task.isStreakContinued =
          previousDate.isBefore(nextCompletionDate) ||
              !widget.task.isMeantForToday;
      if (widget.task.isStreakContinued &&
          widget.task.isCompleted &&
          widget.task.isMeantForToday) {
        if (!completedDates.contains(today)) {
          if (widget.task.isMeantForToday) {
            completedDates.add(today);
            print("added3");
            widget.task.last30DaysDates = _getLast30DaysDates();
            widget.task.completionCount30days =
                _getCompletionCount(widget.task.last30DaysDates);
            widget.task.streakCount++;
            if (widget.task.streakCount > widget.task.longestStreak) {
              widget.task.longestStreak = widget.task.streakCount;
            }
            previousDate = today;
            nextCompletionDate =
                calculateNextCompletionDate(schedule, previousDate);
            updateTaskSchema();
          }
        }
      }
      if (!widget.task.isStreakContinued) {
        widget.task.streakCount = 0;
        nextCompletionDate =
            calculateNextCompletionDate(schedule, DateTime.now());
      }
    } else if (schedule == "biDaily") {
      widget.task.isStreakContinued = now.isBefore(nextCompletionDate);
      if (widget.task.isStreakContinued && widget.task.isCompleted) {
        if (!completedDates.contains(today)) {
          completedDates.add(today);
          widget.task.last30DaysDates = _getLast30DaysDates();
          widget.task.completionCount30days =
              _getCompletionCount(widget.task.last30DaysDates);
          widget.task.streakCount++;
          if (widget.task.streakCount > widget.task.longestStreak) {
            widget.task.longestStreak = widget.task.streakCount;
          }
          previousDate = today;
          nextCompletionDate =
              calculateNextCompletionDate(schedule, previousDate);
          updateTaskSchema();
        }
      }
      if (!widget.task.isStreakContinued) {
        widget.task.streakCount = 0;
        nextCompletionDate =
            calculateNextCompletionDate(schedule, DateTime.now());
        updateTaskSchema();
      }
    } else if (schedule == "weekly") {
      widget.task.isMeantForToday = true;
      widget.task.isStreakContinued = now.isBefore(nextCompletionDate);
      if (widget.task.isStreakContinued && widget.task.isCompleted) {
        if (!completedDates.contains(today)) {
          _getCompletionCount(widget.task.last30DaysDates);
          widget.task.currentCycleCompletions++;
          print("Incrementing cycle comps");
          updateTaskSchema();
          if (widget.task.currentCycleCompletions < widget.task.timesPerWeek) {
            print("Returning");
            return;
          }
          completedDates.add(today);
          widget.task.last30DaysDates = _getLast30DaysDates();
          widget.task.completionCount30days = widget.task.streakCount++;
          widget.task.longestStreak =
              max<int>(widget.task.longestStreak, widget.task.streakCount);
          previousDate = today;
          nextCompletionDate =
              calculateNextCompletionDate(schedule, previousDate);
          updateTaskSchema();
        }
      }
      if (!widget.task.isStreakContinued) {
        widget.task.streakCount = 0;
        nextCompletionDate =
            calculateNextCompletionDate(schedule, DateTime.now());
      }
    } else if (schedule == "monthly") {
      widget.task.isStreakContinued = now.isBefore(nextCompletionDate);
      if (widget.task.isCompleted) {
        print("Set to Completed");
      }
      if (widget.task.isStreakContinued && widget.task.isCompleted) {
        print("completedDates: $completedDates");
        if (!completedDates.contains(today)) {
          print("We in here: $completedDates");
          _getCompletionCount(widget.task.last30DaysDates);
          widget.task.currentCycleCompletions++;
          print("cycle comps${widget.task.currentCycleCompletions}");
          print("times per month${widget.task.timesPerMonth}");
          updateTaskSchema();
          if (widget.task.currentCycleCompletions < widget.task.timesPerMonth) {
            return;
          }
          completedDates.add(today);
          print("added1");
          widget.task.last30DaysDates = _getLast30DaysDates();
          widget.task.completionCount30days = widget.task.streakCount++;
          widget.task.longestStreak =
              max<int>(widget.task.longestStreak, widget.task.streakCount);
          previousDate = today;
          nextCompletionDate =
              calculateNextCompletionDate(schedule, previousDate);
          updateTaskSchema();
        }
      }
      if (!widget.task.isStreakContinued) {
        widget.task.streakCount = 0;
        nextCompletionDate =
            calculateNextCompletionDate(schedule, DateTime.now());
        updateTaskSchema();
      }
    }
  }

  void _completionResetHandler() {
    if (widget.task.isCompleted &&
        !(completedDates.contains(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, 0, 0, 0)))) {
      widget.task.isCompleted = false;
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
        final daysUntilNextDay =
            (7 - (currentDay - getDayOfWeek(startOfWeek))) % 7;
        final nextDay = currentDate.add(Duration(days: daysUntilNextDay));
        final nextDayAtMidnight =
            DateTime(nextDay.year, nextDay.month, nextDay.day);
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

  int _getNextValidDay(int currentDay, String startOfWeek) {
    final daysOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    final startDayIndex = daysOfWeek.indexOf(startOfWeek);
    final nextValidDayIndex = (startDayIndex + 7 - currentDay) % 7;
    return nextValidDayIndex;
  }

  int _getDaysToAdd(int currentDay, int nextValidDay) {
    return nextValidDay >= currentDay
        ? nextValidDay - currentDay
        : (nextValidDay + 7) - currentDay;
  }

  DateTime _getStartOfWeek(DateTime date, String startOfWeek) {
    final daysOfWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    final startDayIndex = daysOfWeek.indexOf(startOfWeek);
    final currentDayIndex = date.weekday - 1;
    final daysToAdd = startDayIndex >= currentDayIndex
        ? startDayIndex - currentDayIndex
        : (startDayIndex + 7) - currentDayIndex;
    return date.add(Duration(days: daysToAdd));
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

    //saves Task to TaskSchema
    widget.service.saveTask(widget.task);
  }

  void updatePiecesInformation() async {
    // Get the current value of totalAnimalPieces from the box
    incrementTotalCollectedPieces();
    widget.task.piecesObtained += 1;
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

  DateTime getTodayAtMidnight() {
    DateTime now = DateTime.now();
    DateTime todayAtMidnight = DateTime(now.year, now.month, now.day);
    return todayAtMidnight;
  }

  Future<void> incrementTotalCollectedPieces() async {
    SharedPreferences prefs = widget.preferenceService.prefs;
    int currentTotalCollectedPieces = prefs.getInt('totalCollectedPieces') ?? 0;
    int newTotalCollectedPieces = currentTotalCollectedPieces + 1;
    widget.preferenceService.setTotalCollectedPieces(newTotalCollectedPieces);
  }

  void addCompletionCountEntry() {
    widget.service.updateDailyCompletionEntry(true);
  }

  TimeOfDay parseTimeFromString(String timeString) {
    print("TimeString: $timeString");
    int hour = int.parse(timeString.substring(10, 12));
    int minute = int.parse(timeString.substring(13, 15));
    return TimeOfDay(hour: hour, minute: minute);
  }
}
