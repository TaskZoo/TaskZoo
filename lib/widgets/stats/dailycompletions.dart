import 'package:isar/isar.dart';

part 'dailycompletions.g.dart'; // This line will generate the adapter

@Collection()
class DailyCompletionEntry {
  @Index()
  Id id;

  @Index()
  String date;

  int completionCount;

  double completionPercent;

  DailyCompletionEntry(
      {required this.id,
      required this.date,
      required this.completionCount,
      required this.completionPercent});
}
