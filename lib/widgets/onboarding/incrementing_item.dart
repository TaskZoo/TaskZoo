import 'package:flutter/material.dart';
import 'dart:async';

import 'package:taskzoo/widgets/stats/custom_animated_digit_widget.dart'; // Required for Timer

class IncrementingDigitWidget extends StatefulWidget {
  final themeNotifier; // Assuming this is required for the CustomAnimatedDigitWidget

  IncrementingDigitWidget(this.themeNotifier);

  @override
  _IncrementingDigitWidgetState createState() =>
      _IncrementingDigitWidgetState();
}

class _IncrementingDigitWidgetState extends State<IncrementingDigitWidget> {
  int _currentValue = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentValue < 99) {
        setState(() {
          _currentValue++;
        });
      } else {
        _stopTimer();
      }
    });
  }

  _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedDigitWidget(
      textColor: Theme.of(context).indicatorColor,
      themeNotifier: widget.themeNotifier,
      value: _currentValue,
      textSize: 30,
    );
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

// Your CustomAnimatedDigitWidget goes here
