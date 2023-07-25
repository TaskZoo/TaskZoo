import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/widgets/stats/current_productivity_card.dart';

import 'package:taskzoo/widgets/stats/daily_percent_completed_card.dart';
import 'package:taskzoo/widgets/stats/month_total_tasks_completed_card.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dailyPercentCompletedTestData = {
      "Mon": 0.3,
      "Tue": 0.1,
      "Wed": 0.0,
      "Thu": 0.5,
      "Fri": 1.0,
      "Sat": 0.6,
      "Sun": 0.1,
    };

    List<int> monthTotalCompletedTestData = [
      10,
      15,
      16,
      4,
      19,
      9,
      8,
      5,
      7,
      16,
      0,
      11,
      12,
      17,
      11,
      5,
      8,
      3,
      17,
      8,
      11,
      2,
      10
    ];

    return Scaffold(
  body: SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: Dimensions.of(context).insets.medium,
        ),
        Expanded(
          child: CurrentProductivityCard(
            currentProductivity: 0.75,
            circularProgressStroke: 15,
            outlineStrokeWidth: Dimensions.of(context).borderWidths.medium,
          ),
        ),
        SizedBox(
          height: Dimensions.of(context).insets.medium,
        ),
        Expanded(
          child: DailyPercentCompletedCard(
            data: dailyPercentCompletedTestData,
            barWidth: 15,
          ),
        ),
        SizedBox(
          height: Dimensions.of(context).insets.medium,
        ),
        Expanded(
          child: MonthTotalTasksCompletedCard(
            data: monthTotalCompletedTestData,
          ),
        ),
        SizedBox(
          height: Dimensions.of(context).insets.medium,
        ),
      ]),
  ),
  bottomNavigationBar: BottomAppBar(
    height: 50,
    color: Theme.of(context).cardColor,
    child: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  ),
);

  }
}
