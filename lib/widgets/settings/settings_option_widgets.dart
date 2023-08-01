import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

class SettingsOptionWithIcon extends StatefulWidget {
  final IconData leftIcon;
  final String optionText;
  final IconData rightActionIcon;
  final void Function() onActionTap;

  SettingsOptionWithIcon({
    required this.leftIcon,
    required this.optionText,
    required this.rightActionIcon,
    required this.onActionTap,
  });

  @override
  _SettingsOptionWithIconState createState() => _SettingsOptionWithIconState();
}

class _SettingsOptionWithIconState extends State<SettingsOptionWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.of(context).insets.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(widget.leftIcon),
              SizedBox(
                width: Dimensions.of(context).insets.medium,
              ),
              Text(widget.optionText, style: TextStyle(fontSize: 16))
            ],
          ),
          GestureDetector(
            child: Icon(widget.rightActionIcon),
            onTap: widget.onActionTap,
          )
        ],
      ),
    );
  }
}

class SettingsOptionWithToggle extends StatefulWidget {
  final IconData leftIcon;
  final String optionText;
  final bool initialValue;
  final ValueChanged<bool> onToggleChanged;

  SettingsOptionWithToggle({
    required this.leftIcon,
    required this.optionText,
    required this.initialValue,
    required this.onToggleChanged,
  });

  @override
  _SettingsOptionWithToggleState createState() =>
      _SettingsOptionWithToggleState();
}

class _SettingsOptionWithToggleState extends State<SettingsOptionWithToggle> {
  late bool _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.of(context).insets.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(widget.leftIcon),
              SizedBox(
                width: Dimensions.of(context).insets.medium,
              ),
              Text(widget.optionText, style: TextStyle(fontSize: 16))
            ],
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: Theme.of(context).iconTheme.size! * 2,
                maxHeight: Theme.of(context).iconTheme.size!),
            child: Switch(
          activeColor: Theme.of(context).indicatorColor,
              value: _currentValue,
              onChanged: (bool value) {
                setState(() {
                  _currentValue = value;
                });
                widget.onToggleChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
