import 'package:flutter/material.dart';

class DailyPercentCompletedCard extends StatelessWidget {
  final Map<String, double> data;
  final double barWidth;

  DailyPercentCompletedCard({
    required this.data,
    required this.barWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Percent Tasks Completed',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                      size: Size(barWidth * data.length, constraints.maxHeight),
                      painter: BarChartPainter(
                        context: context,
                        data: data,
                        barWidth: barWidth,
                        barHeight: constraints.maxHeight,
                        availableWidth: MediaQuery.of(context).size.width - 55,
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final BuildContext context;
  final Map<String, double> data;
  final double barWidth;
  final double availableWidth; // Total available width
  final double barHeight;
  final double cornerRadius;
  final double strokeWidth;

  BarChartPainter({
    required this.context,
    required this.data,
    required this.barWidth,
    required this.barHeight,
    required this.availableWidth,
    this.cornerRadius = 8.0,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double maxBarHeight = barHeight - 20;
    double totalBarWidth = barWidth * data.length;

    // Total available width for the spaces
    double totalSpacingWidth = availableWidth - totalBarWidth;

    // Width of each space
    double spaceWidth = totalSpacingWidth / (data.length - 1);

    var textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    int i = 0;
    for (var entry in data.entries) {
      double actualBarHeight = maxBarHeight * entry.value;
      double left = i * (barWidth + spaceWidth);
      double top = maxBarHeight - actualBarHeight;

      var backgroundRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 0, barWidth, maxBarHeight),
        Radius.circular(cornerRadius),
      );

      var paint = Paint()..color = Theme.of(context).indicatorColor;
      var rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, actualBarHeight),
        Radius.circular(cornerRadius),
      );

      // Draw background
      var backgroundStrokePaint = Paint()
        ..color = Theme.of(context).dividerColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawRRect(backgroundRect, backgroundStrokePaint);

      // Draw bar
      canvas.drawRRect(rect, paint);

      // Draw label
      textPainter.text = TextSpan(
        text: entry.key[0].toUpperCase(),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          left + barWidth / 2 - textPainter.width / 2,
          size.height - textPainter.height,
        ),
      );

      i++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
