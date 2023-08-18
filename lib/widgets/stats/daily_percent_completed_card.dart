import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

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
      padding: EdgeInsets.fromLTRB(Dimensions.of(context).insets.medium, 0,
          Dimensions.of(context).insets.medium, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Dimensions.of(context).radii.medium),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Weekly Productivity',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).indicatorColor,
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

  BarChartPainter({
    required this.context,
    required this.data,
    required this.barWidth,
    required this.barHeight,
    required this.availableWidth,
    this.cornerRadius = 8.0,
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
        ..strokeWidth = Dimensions.of(context).borderWidths.medium;
      canvas.drawRRect(backgroundRect, backgroundStrokePaint);

      // Draw bar
      canvas.drawRRect(rect, paint);

      // Draw label
      textPainter.text = TextSpan(
        text: entry.key[0].toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).indicatorColor,
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
