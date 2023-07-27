import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget _modalSettingsCard() {
    return Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Dimensions.of(context).radii.medium),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.of(context).insets.medium),
          child: Column(children: [
            SettingsOptionWithIcon(
              leftIcon: Icons.public,
              optionText: 'App Icon',
              rightActionIcon: Icons.expand_less,
              onActionTap: () => print('App icon pressed!'),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithIcon(
              leftIcon: Icons.notifications,
              optionText: 'Notifications',
              rightActionIcon: Icons.expand_less,
              onActionTap: () => print('Notifications icon pressed!'),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithIcon(
              leftIcon: Icons.help_outline,
              optionText: 'Help',
              rightActionIcon: Icons.expand_less,
              onActionTap: () => print('Help icon pressed!'),
            )
          ]),
        ));
  }

  Widget _toggleSettingsCard() {
    return Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(Dimensions.of(context).radii.medium),
          color: Theme.of(context).cardColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.of(context).insets.medium),
          child: Column(children: [
            SettingsOptionWithToggle(
              leftIcon: Icons.tonality,
              optionText: 'Theme',
              initialValue: true,
              onToggleChanged: (bool value) {
                print('Theme toggled: $value');
              },
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithToggle(
              leftIcon: Icons.volume_up,
              optionText: 'Sounds',
              initialValue: true,
              onToggleChanged: (bool value) {
                print('Sounds toggled: $value');
              },
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithToggle(
              leftIcon: Icons.edgesensor_low,
              optionText: 'Haptics',
              initialValue: true,
              onToggleChanged: (bool value) {
                print('Haptics toggled: $value');
              },
            ),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimensions.of(context).insets.medium),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _modalSettingsCard(),
          SizedBox(
            height: Dimensions.of(context).insets.medium,
          ),
          _toggleSettingsCard()
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
            constraints: BoxConstraints(maxWidth: Theme.of(context).iconTheme.size!*2, maxHeight: Theme.of(context).iconTheme.size!),
            child: Switch(
              activeColor: Colors.black,
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
