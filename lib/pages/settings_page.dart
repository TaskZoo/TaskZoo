import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

import 'package:taskzoo/misc/theme_notifier.dart';
import 'package:taskzoo/widgets/settings/settings_option_widgets.dart';

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

  Widget _buttonSettingsCard() {
    // var for requesting an in app review
    final InAppReview _inAppReview = InAppReview.instance;

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
              leftIcon: Icons.send,
              optionText: 'Share',
              rightActionIcon: Icons.chevron_right,
              onActionTap: () => Share.share(
                  'Check out TaskZoo... you can build a zoo of cute animals! https://example.com'),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithIcon(
              leftIcon: Icons.star_rate,
              optionText: 'Leave a Review',
              rightActionIcon: Icons.chevron_right,
              onActionTap: () => _inAppReview.requestReview(),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithIcon(
              leftIcon: Icons.delete,
              optionText: 'Clean Slate Protocol',
              rightActionIcon: Icons.chevron_right,
              onActionTap: () => print('Clean icon pressed!'),
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
          _toggleSettingsCard(),
          SizedBox(
            height: Dimensions.of(context).insets.medium,
          ),
          _buttonSettingsCard()
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

