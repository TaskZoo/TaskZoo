import 'package:isar/isar.dart';
import 'package:taskzoo/widgets/home/taskzoo_preferences.dart';
import 'package:taskzoo/widgets/notifications/active_notifications.dart';
import 'package:taskzoo/widgets/stats/dailycompletions.dart';
import 'package:taskzoo/widgets/tasks/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taskzoo/widgets/zoo/animalpieces.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [
          TaskSchema,
          AnimalPiecesSchema,
          DailyCompletionEntrySchema,
          ActiveNotificationsSchema,
          TaskzooPreferencesSchema
        ],
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }

  //ANIMAL PIECE INFO

  Future<int> getNumShapesFromAnimalPieces(String svgPath) async {
    final isar = await db;
    int svgPathId = svgPath.hashCode.abs();

    // Find the AnimalPieces item with the matching ID
    AnimalPieces? animalPieces = await isar.animalPieces
        .where()
        .filter()
        .idEqualTo(svgPathId)
        .findFirst();

    // If the AnimalPieces item exists, set the _numShapes variable to its 'pieces' value
    if (animalPieces != null) {
      animalPieces.pieces;
      return animalPieces.pieces;
      // Return the updated _numShapes value
    } else {
      // If the AnimalPieces item does not exist, return 0 or any other appropriate default value
      return 0;
    }
  }

  Future<void> saveAnimalPieces(AnimalPieces tuple) async {
    final isar = await db;
    //Return type int -> id of the inserted object
    await isar.writeTxn<void>(() async {
      await isar.animalPieces.put(tuple);
    });
  }

  //TASK INFO

  Stream<List<Task>> listenToTasks() async* {
    final isar = await db;
    // Yield an initial event with the current state of the database
    yield await isar.tasks.where().findAll();

    // Set up a watcher that yields new data every time something changes in the database
    await for (var _ in isar.tasks.where().watch()) {
      yield await isar.tasks.where().findAll();
    }
  }

  Stream<List<Task>> getAllTasks() async* {
    final isar = await db;
    // Yield an initial event with the current state of the database
    yield await isar.tasks.where().findAll();

    // Set up a watcher that yields new data every time something changes in the database
    await for (var _ in isar.tasks.where().watch()) {
      yield await isar.tasks.where().findAll();
    }
  }

  Stream<int> countAllTasks() async* {
    final isar = await db;

    // Initial task count
    yield await isar.tasks.where().findAll().then((tasks) => tasks.length);

    // Watch for changes in the tasks and yield the updated count
    await for (var _ in isar.tasks.where().watch()) {
      yield await isar.tasks.where().findAll().then((tasks) => tasks.length);
    }
  }

  Stream<int> countAllCompletedTasks() async* {
    // Listen to the stream of tasks obtained from getAllTasks()
    await for (var tasks in getAllTasks()) {
      // When the stream emits new data, update the completedTaskCount
      yield await tasks.where((task) => task.isCompleted).length;
    }
  }

  Stream<int> countTasks(String schedule, List<String> selectedTags) async* {
    // Watch for changes in the tasks and yield the updated count
    await for (var tasks
        in filterTasksByScheduleAndSelectedTags(schedule, selectedTags)) {
      yield tasks.length;
    }
  }

  Stream<int> countTaskNotCompleted(
      String schedule, List<String> selectedTags) async* {
    // Watch for changes in the tasks
    await for (var tasks
        in filterTasksByScheduleAndSelectedTags(schedule, selectedTags)) {
      // Calculate the count of not completed tasks
      int count = tasks
          .where((task) => !task.isCompleted && task.isMeantForToday)
          .length;
      yield count; // Yield the updated count
    }
  }

  Stream<int> countCompletedTasks(
      String schedule, List<String> selectedTags) async* {
    // Listen to the stream of tasks obtained from getAllTasks()
    await for (var tasks
        in filterTasksByScheduleAndSelectedTags(schedule, selectedTags)) {
      // When the stream emits new data, update the completedTaskCount
      yield tasks.where((task) => task.isCompleted).length;
    }
  }

  //If Task id not found in Schema Table, it will be added else replace value
  Future<void> saveTask(Task task) async {
    final isar = await db;
    //Return type int -> id of the inserted object
    await isar.writeTxn<void>(() async {
      await isar.tasks.put(task);
    });
  }

  Stream<List<Task>> filterTasksByScheduleAndSelectedTags(
      String schedule, List<String> selectedTags) async* {
    final isar = await db;

    // Yield the current state of the database filtered by schedule
    var allTasks =
        await isar.tasks.where().filter().scheduleEqualTo(schedule).findAll();

    // pain there is no filtering by list of values >:(
    // Filter tasks by tags only if there are any selected tags
    var filteredTasks = selectedTags.isEmpty
        ? allTasks
        : allTasks.where((task) => selectedTags.contains(task.tag)).toList();
    yield filteredTasks;

    // Set up a watcher that yields new data every time something changes in the database
    await for (var _
        in isar.tasks.where().filter().scheduleEqualTo(schedule).watch()) {
      allTasks =
          await isar.tasks.where().filter().scheduleEqualTo(schedule).findAll();
      filteredTasks = selectedTags.isEmpty
          ? allTasks
          : allTasks.where((task) => selectedTags.contains(task.tag)).toList();
      yield filteredTasks;
    }
  }

  Future<void> deleteTask(Task task) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.tasks.delete(task.id); // deletes based off of id
    });
  }

  //STATS AND INFO

  Future<void> saveDailyCompletionEntry(
      DailyCompletionEntry dailycompletion) async {
    final isar = await db;
    //Return type int -> id of the inserted object
    await isar.writeTxn<void>(() async {
      await isar.dailyCompletionEntrys.put(dailycompletion);
    });
  }

  Stream<double> percentTasksCompleted() async* {
    // Get the stream of tasks
    Stream<List<Task>> tasksStream = getAllTasks();

    int totalTaskCount = 0;
    int completedTaskCount = 0;

    // Listen to the stream of tasks
    await for (var tasks in tasksStream) {
      // When the stream emits new data, update the totalTaskCount and completedTaskCount
      totalTaskCount = tasks.where((task) => task.isMeantForToday).length;
      completedTaskCount = tasks
          .where((task) => task.isCompleted && task.isMeantForToday)
          .length;

      // Calculate the percentage and yield it
      if (totalTaskCount == 0) {
        yield 0;
        continue;
      }
      double percentage = (completedTaskCount / totalTaskCount) * 100;
      yield percentage;
    }
  }

  Future<void> updateDailyCompletionEntry(bool shouldIncrement) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    final isar = await db;
    int encodedDate = encodeDate(today);

    DailyCompletionEntry? existingEntry = await isar.dailyCompletionEntrys
        .where()
        .idEqualTo(encodedDate)
        .findFirst();

    if (existingEntry != null) {
      // Entry already exists, increment the completion count
      double percent = await getCompletionPercentage();
      existingEntry.completionPercent = percent;
      if (shouldIncrement) {
        existingEntry.completionCount += 1;
      }
      await saveDailyCompletionEntry(existingEntry);
    } else {
      // Entry doesn't exist, create a new one with completionCount as 1
      double percent = await getCompletionPercentage();
      int startingCount = 0;
      if (shouldIncrement) {
        startingCount = 1;
      }
      DailyCompletionEntry newEntry = DailyCompletionEntry(
          id: encodedDate,
          date: today.toIso8601String(),
          completionCount: startingCount,
          completionPercent: percent);
      await saveDailyCompletionEntry(newEntry);
    }
  }

  Future<void> validateDailyCompletionEntry() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    final isar = await db;
    int encodedDate = encodeDate(today);

    DailyCompletionEntry? existingEntry = await isar.dailyCompletionEntrys
        .where()
        .idEqualTo(encodedDate)
        .findFirst();

    if (existingEntry != null) {
      // Entry already exists, increment the completion count
      double percent = await getCompletionPercentage();
      existingEntry.completionPercent = percent;
      await saveDailyCompletionEntry(existingEntry);
    } else {
      // Entry doesn't exist, create a new one with completionCount as 1
      double percent = await getCompletionPercentage();
      int startingCount = 0;
      DailyCompletionEntry newEntry = DailyCompletionEntry(
          id: encodedDate,
          date: today.toIso8601String(),
          completionCount: startingCount,
          completionPercent: percent);
      await saveDailyCompletionEntry(newEntry);
    }
  }

  Stream<List<int>> getCompletionCountsLast30Days() async* {
    final isar = await db;
    DateTime today = DateTime.now();

    // Calculate the cutoff date which is 30 days ago from today
    DateTime cutoffDate = today.subtract(Duration(days: 30));
    int cutoffEncodedDate = encodeDate(cutoffDate);

    // Query all entries with encodedDate greater than the cutoff date
    var entries = await isar.dailyCompletionEntrys
        .where()
        .idGreaterThan(cutoffEncodedDate)
        .findAll();

    // Extract the completionCount values from the entries
    List<int> completionCounts =
        entries.map((entry) => entry.completionCount).toList();

    // Yield the completionCounts list
    yield completionCounts;
  }

  //Function used to encode a specific date into a numerical value
  int encodeDate(DateTime date) {
    DateTime referenceDate = DateTime(0);
    int differenceInDays = date.difference(referenceDate).inDays;
    return differenceInDays;
  }

  //Function used to support stats Stream
  String formatDateToMonthDay(String isoString) {
    DateTime dateTime = DateTime.parse(isoString).toLocal();
    String formattedDate = "${dateTime.month}/${dateTime.day}";
    return formattedDate;
  }

  Future<double> getCompletionPercentage() async {
    List<Task> allTasks = await getAllTasks().first;
    int completedTaskCount = allTasks
        .where((task) => task.isCompleted && task.isMeantForToday)
        .length;
    int tasksForToday = allTasks.where((task) => task.isMeantForToday).length;

    double completionPercent =
        allTasks.isEmpty ? 0 : completedTaskCount / tasksForToday;
    return completionPercent;
  }

  List<String> getEncodedDatesForPastWeek() {
    DateTime now = DateTime.now().toLocal();
    DateTime previousMonday = now.subtract(Duration(days: now.weekday - 1));
    DateTime nextSunday = previousMonday.add(Duration(days: 6));
    List<String> dateStrings = [];

    for (DateTime currentDate = previousMonday;
        currentDate.isBefore(nextSunday) ||
            currentDate.isAtSameMomentAs(nextSunday);
        currentDate = currentDate.add(Duration(days: 1))) {
      DateTime dateAtMidnight = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        0, // Hour
        0, // Minute
        0, // Second
      );
      String dateString = dateAtMidnight.toIso8601String();
      dateStrings.add(dateString);
    }

    return dateStrings;
  }

  List<String> getDecodedDatesForPastWeek() {
    DateTime now = DateTime.now().toLocal();
    DateTime previousMonday = now.subtract(Duration(days: now.weekday - 1));
    DateTime nextSunday = previousMonday.add(Duration(days: 6));
    List<String> decodedDates = [];

    for (DateTime currentDate = previousMonday;
        currentDate.isBefore(nextSunday) ||
            currentDate.isAtSameMomentAs(nextSunday);
        currentDate = currentDate.add(Duration(days: 1))) {
      decodedDates.add(currentDate.toIso8601String());
    }

    return decodedDates;
  }

  String getWeekday(String isoString) {
    DateTime dateTime = DateTime.parse(isoString).toLocal();
    String weekday = '';

    switch (dateTime.weekday) {
      case DateTime.monday:
        weekday = 'Monday';
        break;
      case DateTime.tuesday:
        weekday = 'Tuesday';
        break;
      case DateTime.wednesday:
        weekday = 'Wednesday';
        break;
      case DateTime.thursday:
        weekday = 'Thursday';
        break;
      case DateTime.friday:
        weekday = 'Friday';
        break;
      case DateTime.saturday:
        weekday = 'Saturday';
        break;
      case DateTime.sunday:
        weekday = 'Sunday';
        break;
    }
    return weekday;
  }

// Function to compute completion percentage for past 7 days
  Stream<Map<String, double>> getCompletionPercentForPast7Days() async* {
    List<String> encodedDates = getEncodedDatesForPastWeek();
    List<String> decodedDates = getDecodedDatesForPastWeek();

    Map<String, double> completionData = {};

    final isar = await db;

    int i = 0;
    for (String encodedDate in encodedDates) {
      DailyCompletionEntry? entry = await isar.dailyCompletionEntrys
          .where()
          .dateEqualTo(encodedDate)
          .findFirst();

      //String key = formatDateToMonthDay(decodedDates[i]);
      String key = getWeekday(decodedDates[i]);
      double completionPercent = entry?.completionPercent ?? 0.0;

      completionData[key] = completionPercent;
      i += 1;
    }

    // Yield the completion data map
    yield completionData;
  }

  //NOTIFICATIONS

  //Add notification instance
  Future<void> saveActiveNotificationForTask(
      ActiveNotifications notification) async {
    final isar = await db;
    //Return type int -> id of the inserted object
    await isar.writeTxn(() async {
      await isar.activeNotifications
          .put(notification); // deletes based off of id
    });
  }

  Future<void> deleteActiveNotificationsForTaskEntry(int taskID) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.activeNotifications.delete(taskID); // deletes based off of id
    });
  }

  Future<Set<String>> getNotificationIdsForTaskID(int taskId) async {
    final isar = await db;
    ActiveNotifications? activeNotifications = await isar.activeNotifications
        .where()
        .taskidEqualTo(taskId)
        .findFirst();

    if (activeNotifications != null) {
      return activeNotifications.notificationIds.toSet();
    } else {
      // If no matching taskid is found, return an empty set.
      return Set<String>();
    }
  }

  //SETTINGS AND PREFERENCES

  Future<void> savePersonalPreferences(TaskzooPreferences preference) async {
    final isar = await db;
    //Return type int -> id of the inserted object
    await isar.writeTxn<void>(() async {
      await isar.taskzooPreferences.put(preference);
    });
  }

  Future<void> initalizeTotalCollectedPieces() async {
    final isar = await db;
    final int id = "totalCollectedPieces".hashCode.abs();

    // Check if the entry with the given ID exists in the taskzooPreferences table
    final existingPreference =
        await isar.taskzooPreferences.where().taskidEqualTo(id).findFirst();

    // If the entry doesn't exist, add a new entry with the ID and value of 0
    if (existingPreference == null) {
      final newPreference = TaskzooPreferences(taskid: id, value: 0);

      await isar.writeTxn<void>(() async {
        await isar.taskzooPreferences.put(newPreference);
      });
    }
  }

  Future<void> setPreference(
      String preference, int newTotalCollectedPieces) async {
    final isar = await db;
    final int id = preference.hashCode.abs();

    // Use an asynchronous write transaction to update or add the entry
    await isar.writeTxn<void>(() async {
      final newPreference =
          TaskzooPreferences(taskid: id, value: newTotalCollectedPieces);
      await isar.taskzooPreferences.put(newPreference);
    });
  }

  Stream<List<TaskzooPreferences>> getPreferencesStreamHelper(
      String preference) async* {
    final isar = await db;
    // Yield an initial event with the current state of the database
    final int id = preference.hashCode.abs();
    yield await isar.taskzooPreferences.where().taskidEqualTo(id).findAll();

    // Set up a watcher that yields new data every time something changes in the database
    await for (var _ in isar.taskzooPreferences.where().watch()) {
      yield await isar.taskzooPreferences.where().findAll();
    }
  }

  Stream<int> preferenceStream(String preference) async* {
    Stream<List<TaskzooPreferences>> preferencesStream =
        getPreferencesStreamHelper(preference);

    await for (var prefs in preferencesStream) {
      // When the stream emits new data, update the totalTaskCount and completedTaskCount
      var filteredPrefs =
          prefs.where((setting) => setting.taskid == preference.hashCode.abs());

      if (filteredPrefs.isNotEmpty) {
        yield filteredPrefs.first.value;
      } else {
        yield 0;
      }
    }
  }

  Future<void> initalizeThemeSetting() async {
    final isar = await db;
    final int id = "theme".hashCode.abs();

    // Check if the entry with the given ID exists in the taskzooPreferences table
    final existingPreference =
        await isar.taskzooPreferences.where().taskidEqualTo(id).findFirst();

    // If the entry doesn't exist, add a new entry with the ID and value of 0
    if (existingPreference == null) {
      final newPreference = TaskzooPreferences(taskid: id, value: 0);
      await isar.writeTxn<void>(() async {
        await isar.taskzooPreferences.put(newPreference);
      });
    }
  }

  Future<void> initalizeHapticSetting() async {
    final isar = await db;
    final int id = "hapticFeedback".hashCode.abs();

    // Check if the entry with the given ID exists in the taskzooPreferences table
    final existingPreference =
        await isar.taskzooPreferences.where().taskidEqualTo(id).findFirst();

    // If the entry doesn't exist, add a new entry with the ID and value of 0
    if (existingPreference == null) {
      final newPreference = TaskzooPreferences(taskid: id, value: 1);

      await isar.writeTxn<void>(() async {
        await isar.taskzooPreferences.put(newPreference);
      });
    }
  }

  Future<void> initalizeSoundSetting() async {
    final isar = await db;
    final int id = "sound".hashCode.abs();

    // Check if the entry with the given ID exists in the taskzooPreferences table
    final existingPreference =
        await isar.taskzooPreferences.where().taskidEqualTo(id).findFirst();

    // If the entry doesn't exist, add a new entry with the ID and value of 0
    if (existingPreference == null) {
      final newPreference = TaskzooPreferences(taskid: id, value: 1);
      await isar.writeTxn<void>(() async {
        await isar.taskzooPreferences.put(newPreference);
      });
    }
  }

  Future<int> getPreference(String preferenceName) async {
    final isar = await db;
    final int id = preferenceName.hashCode.abs();

    // Find the TaskZooPreference entry with the given ID
    final preference =
        await isar.taskzooPreferences.where().taskidEqualTo(id).findFirst();

    // If the entry exists, return its value; otherwise, return null
    return preference?.value ?? 0;
  }

  Future<void> deleteAllTasks() async {
    final isar = await db;

    final tasks = isar.tasks; // Assuming you have a 'tasks' collection

    // Open a write transaction
    await isar.writeTxn(() async {
      // Query for all objects of the type you want to delete
      final allTasks = await tasks.where().findAll();

      // Delete each object in the collection
      for (var task in allTasks) {
        await tasks.delete(task.id);
      }
    });
  }

  Future<void> deleteAllAnimalPieces() async {
    final isar = await db;

    final animals = isar.animalPieces; // Assuming you have a 'tasks' collection

    // Open a write transaction
    await isar.writeTxn(() async {
      // Query for all objects of the type you want to delete
      final allTasks = await animals.where().findAll();

      // Delete each object in the collection
      for (var animal in allTasks) {
        await animals.delete(animal.id);
      }
    });
  }

  Future<void> deleteAllNotifications() async {
    final isar = await db;

    final notifications =
        isar.activeNotifications; // Assuming you have a 'tasks' collection

    // Open a write transaction
    await isar.writeTxn(() async {
      // Query for all objects of the type you want to delete
      final allNotifications = await notifications.where().findAll();

      // Delete each object in the collection
      for (var notif in allNotifications) {
        await notifications.delete(notif.taskid);
      }
    });
  }

  Future<void> deleteAllDailyCompletionEntries() async {
    final isar = await db;

    final completionEntries =
        isar.dailyCompletionEntrys; // Assuming you have a 'tasks' collection

    // Open a write transaction
    await isar.writeTxn(() async {
      // Query for all objects of the type you want to delete
      final entries = await completionEntries.where().findAll();

      // Delete each object in the collection
      for (var entry in entries) {
        await completionEntries.delete(entry.id);
      }
    });
  }
}
