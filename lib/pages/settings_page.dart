import 'package:flutter/material.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:taskzoo/misc/haptic_notifier.dart';
import 'package:taskzoo/misc/sound_notifier.dart';

import 'package:taskzoo/misc/theme_notifier.dart';
import 'package:taskzoo/widgets/isar_service.dart';
import 'package:taskzoo/widgets/notifications/notification_service.dart';
import 'package:taskzoo/widgets/settings/app_icon_modal.dart';
import 'package:taskzoo/widgets/settings/settings_option_widgets.dart';
import 'package:taskzoo/widgets/onboarding/onboarding_screen.dart';

class SettingsPage extends StatefulWidget {
  final IsarService service;
  final ThemeNotifier themeNotifier;
  final HapticNotifier hapticNotifier;
  final SoundNotifer soundNotifier;

  const SettingsPage(
      {Key? key,
      required this.service,
      required this.themeNotifier,
      required this.hapticNotifier,
      required this.soundNotifier})
      : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            SettingsOptionWithIcon(
              leftIconPath: "assets/custom_icons/help.svg",
              optionText: 'App Icon',
              rightActionIcon: Icons.expand_less,
              onActionTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top:
                          Radius.circular(Dimensions.of(context).radii.largest),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return AppIconModal(
                        iconsDataPath: 'assets/icons_data.json');
                  },
                );
              },
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithIcon(
              leftIconPath: "assets/custom_icons/help.svg",
              optionText: 'Help',
              rightActionIcon: Icons.expand_less,
              onActionTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                );
              },
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
              leftIconPath: "assets/custom_icons/theme.svg",
              optionText: 'Theme',
              initialValue: widget.themeNotifier.currentTheme !=
                  ThemeMode.light, // Using the result of the stream
              onToggleChanged: (bool value) {
                //Update Isar DB
                widget.themeNotifier.toggleTheme();
                widget.service.setPreference(
                    "theme",
                    (widget.themeNotifier.currentTheme == ThemeMode.light)
                        ? 0
                        : 1);
              },
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithToggle(
              leftIconPath: "assets/custom_icons/sound.svg",
              optionText: 'Sounds',
              initialValue: widget.soundNotifier.soundStatus != 0,
              onToggleChanged: (bool value) {
                widget.soundNotifier.toggleSound();
                widget.service.setPreference("sound", value ? 1 : 0);
                print('Sounds toggled: $value');
              },
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithToggle(
              leftIconPath: "assets/custom_icons/haptic.svg",
              optionText: 'Haptics',
              initialValue: widget.hapticNotifier.hapticValue != 0,
              onToggleChanged: (bool value) {
                widget.hapticNotifier.toggleHaptic();
                widget.service
                    .setPreference("hapticFeedback", (value == true) ? 1 : 0);
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
              leftIconPath: "assets/custom_icons/share.svg",
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
              leftIconPath: "assets/custom_icons/rate.svg",
              optionText: 'Leave a Review',
              rightActionIcon: Icons.chevron_right,
              onActionTap: () => _inAppReview.requestReview(),
            ),
            Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            ),
            SettingsOptionWithIcon(
              leftIconPath: "assets/custom_icons/trash.svg",
              optionText: 'Clean Slate Protocol',
              rightActionIcon: Icons.chevron_right,
              onActionTap: () => cleanSlateProtocol(),
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

  void cleanSlateProtocol() async {
    //Delete All Tasks
    widget.service.deleteAllTasks();
    //Delete and Unschedule Notifications
    cancelAllNotifications();
    //Delete all Animal Pieces
    widget.service.deleteAllAnimalPieces();
    //Delete all Daily Completion Entries - data for stats card
    widget.service.deleteAllDailyCompletionEntries();
    //Set the total number of pieces to zero
    await widget.service.setPreference("totalCollectedPieces", 0);
    print('Clean slate protocol completed!');
  }
}

// Asynchronous function to fetch the preferenc
