import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthTotalTasksCompletedCard extends StatelessWidget {
  final List<int> data;

  MonthTotalTasksCompletedCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = data
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList();

    double maxX = data.length.toDouble() - 1;
    double maxY =
        data.reduce((curr, next) => curr > next ? curr : next).toDouble() + 1;

    LinearGradient lineChartGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black,
        Colors.white,
      ].map((color) => color.withOpacity(1)).toList(),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).cardColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Tasks Completed',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: maxX,
                        minY: -1,
                        maxY: maxY,
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            color: Theme.of(context).indicatorColor,
                            spots: spots,
                            isCurved: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(context).indicatorColor,
                            ),
                          ),
                        ],
                        gridData: FlGridData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${data.length} Day History',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).cardColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
