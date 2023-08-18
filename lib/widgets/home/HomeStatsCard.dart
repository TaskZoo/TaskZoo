import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:taskzoo/misc/theme_notifier.dart';
import 'package:taskzoo/widgets/isar_service.dart';
import 'package:taskzoo/widgets/stats/custom_animated_digit_widget.dart'; // Import your ThemeNotifier class

class HomeStatsCard extends StatefulWidget {
  final Stream<int> totalCollectedPiecesStream;
  final Stream<int> Function(String, List<String>) countTasks;
  final Stream<int> Function(String, List<String>) countCompletedTasks;
  final ValueNotifier<String> selectedSchedule;
  final ThemeNotifier themeNotifier;
  final List<String> selectedTags;
  final IsarService service;

  const HomeStatsCard({
    Key? key,
    required this.totalCollectedPiecesStream,
    required this.countTasks,
    required this.countCompletedTasks,
    required this.selectedSchedule,
    required this.selectedTags,
    required this.themeNotifier,
    required this.service,
  }) : super(key: key);

  @override
  _HomeStatsCardState createState() => _HomeStatsCardState();
}

class _HomeStatsCardState extends State<HomeStatsCard> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.selectedSchedule,
      builder: (context, value, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.of(context).insets.medium),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  BorderRadius.circular(Dimensions.of(context).radii.medium),
            ),
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.of(context).insets.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStreamWidget(
                    widget.totalCollectedPiecesStream,
                    SvgPicture.asset("assets/custom_icons/puzzle_piece.svg",
                        color: Theme.of(context).iconTheme.color,
                        semanticsLabel: 'Puzzle Piece')),
                _buildStreamWidget(
                    widget.countTasks(value, widget.selectedTags),
                    SvgPicture.asset("assets/custom_icons/clock.svg",
                        color: Theme.of(context).iconTheme.color,
                        semanticsLabel: 'Clock')),
                _buildStreamWidget(
                    widget.countCompletedTasks(value, widget.selectedTags),
                    SvgPicture.asset("assets/custom_icons/check.svg",
                        color: Theme.of(context).iconTheme.color,
                        semanticsLabel: 'Check')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreamWidget(Stream<int> stream, SvgPicture icon) {
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(); // Return an empty container if there's no data yet
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 5.0),
            if (snapshot.hasData)
              CustomAnimatedDigitWidget(
                  value: snapshot.data!,
                  textColor:
                      widget.themeNotifier.currentTheme == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                  themeNotifier: widget.themeNotifier),
          ],
        );
      },
    );
  }
}
