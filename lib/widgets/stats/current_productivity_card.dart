import 'package:flutter/material.dart';
import 'package:curved_progress_bar/curved_progress_bar.dart';

class Circle extends CustomPainter {
  final double outlineStrokeWidth;
  final Color outlineColor;

  Circle({this.outlineStrokeWidth = 3, this.outlineColor = Colors.grey});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = outlineColor
      ..strokeWidth = outlineStrokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CurrentProductivityCard extends StatelessWidget {
  final double currentProductivity;
  final double circularProgressStroke;
  final double outlineStrokeWidth;

  CurrentProductivityCard({
    required this.currentProductivity,
    this.circularProgressStroke = 20,
    this.outlineStrokeWidth = 3,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double circularProgressDiameter = constraints.maxHeight -
              40; // 40 accounts for padding and any extra spacing you might want

          return Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CustomPaint(
                        painter: Circle(
                            outlineStrokeWidth: outlineStrokeWidth,
                            outlineColor: Theme.of(context).dividerColor),
                        child: Container(
                          height: (circularProgressDiameter +
                                  circularProgressStroke) -
                              outlineStrokeWidth,
                          width: (circularProgressDiameter +
                                  circularProgressStroke) -
                              outlineStrokeWidth,
                        ),
                      ),
                      CustomPaint(
                        painter: Circle(
                            outlineStrokeWidth: outlineStrokeWidth,
                            outlineColor: Theme.of(context).dividerColor),
                        child: Container(
                          height: (circularProgressDiameter -
                                  circularProgressStroke) +
                              outlineStrokeWidth,
                          width: (circularProgressDiameter -
                                  circularProgressStroke) +
                              outlineStrokeWidth,
                        ),
                      ),
                      Container(
                        height: circularProgressDiameter,
                        width: circularProgressDiameter,
                        child: CurvedCircularProgressIndicator(
                          value: currentProductivity,
                          strokeWidth: circularProgressStroke,
                          color: Theme.of(context).indicatorColor,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '${(currentProductivity * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).indicatorColor),
                          ),
                          Text(
                            'Current \nProductivity',
                            style:
                                TextStyle(fontSize: 16, color: Theme.of(context).dividerColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
