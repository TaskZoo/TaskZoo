import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget _settingsOptionRow({
    required IconData leftIcon,
    required String optionText,
    required IconData rightActionIcon,
    required void Function() onActionTap,
  }) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.of(context).insets.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(leftIcon),
              SizedBox(
                width: Dimensions.of(context).insets.medium,
              ),
              Text(optionText, style: TextStyle(fontSize: 16))
            ],
          ),
          GestureDetector(
            child: Icon(rightActionIcon),
            onTap: onActionTap,
          )
        ],
      ),
    );
  }

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
            _settingsOptionRow(
              leftIcon: Icons.public,
              optionText: 'App Icon',
              rightActionIcon: Icons.expand_less,
              onActionTap: () => print('App icon pressed!'),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            _settingsOptionRow(
              leftIcon: Icons.notifications,
              optionText: 'Notifications',
              rightActionIcon: Icons.expand_less,
              onActionTap: () => print('Notifications icon pressed!'),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            _settingsOptionRow(
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
            _settingsOptionRow(
              leftIcon: Icons.public,
              optionText: 'App Icon',
              rightActionIcon: Icons.expand_less,
              onActionTap: () => print('App icon pressed!'),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            _settingsOptionRow(
              leftIcon: Icons.notifications,
              optionText: 'Notifications',
              rightActionIcon: Icons.expand_less,
              onActionTap: () => print('Notifications icon pressed!'),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            _settingsOptionRow(
              leftIcon: Icons.help_outline,
              optionText: 'Help',
              rightActionIcon: Icons.expand_less,
              onActionTap: () => print('Help icon pressed!'),
            )
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
