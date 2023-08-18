import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:dimensions_theme/dimensions_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskzoo/misc/haptic_notifier.dart';
import 'package:taskzoo/misc/sound_notifier.dart';

import 'package:taskzoo/pages/home_page.dart';
import 'package:taskzoo/pages/zoo_page.dart';
import 'package:taskzoo/pages/stats_page.dart';
import 'package:taskzoo/pages/settings_page.dart';

import 'package:taskzoo/widgets/home/navbar.dart';

import 'package:taskzoo/misc/zoo_notifier.dart';
import 'package:taskzoo/misc/theme_notifier.dart';
import 'package:taskzoo/widgets/isar_service.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taskzoo/widgets/onboarding/onboarding_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('is_first_time') ?? true;

  printKey();

  tz.initializeTimeZones();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          'app_icon'); // Replace 'app_icon' with the app's icon name also make sure to add the icon to android/app/src/main/res/drawable

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) async {},
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => HapticNotifier()),
        ChangeNotifierProvider(create: (_) => SoundNotifer())
      ],
      child: MyApp(isFirstTime: isFirstTime),
    ),
  );

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({Key? key, required this.isFirstTime}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'TaskZoo',

      // getting info for how to do ThemeData at https://stackoverflow.com/questions/60232070/how-to-implement-dark-mode-and-light-mode-in-flutter
      theme: ThemeData(
        // Light theme settings
        brightness: Brightness.light,

        // darker white that is background of all pages besides zoo
        scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
        // solid white that is color of any card
        cardColor: Colors.white,
        // black color for icons
        indicatorColor: Colors.black,
        // gray color used throughout the app
        dividerColor: const Color.fromARGB(255, 123, 123, 123),

        // set theme data for icons
        iconTheme: const IconThemeData(size: 24),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),

        extensions: [
          // the Dimensions extension allows us to use inset/radii/border with like a theme
          // for our use case, we define the medium value as below and use this throughout the app
          Dimensions(
              insets: InsetDimensions.fromMedium(15),
              radii: RadiusDimensions.fromMedium(15),
              borderWidths: BorderWidthDimensions.fromMedium(2)),
        ],
      ),

      darkTheme: ThemeData(
        // dark theme settings
        brightness: Brightness.dark,

        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),

        // solid black that is background of all pages besides zoo
        scaffoldBackgroundColor: Colors.black,
        // gray that is color of any card
        cardColor: const Color.fromARGB(255, 35, 35, 35),
        // black color for icons
        indicatorColor: Colors.white,
        // gray color used throughout the app
        dividerColor: const Color.fromARGB(255, 123, 123, 123),

        // set theme data for icons
        iconTheme: const IconThemeData(color: Colors.white, size: 24),

        extensions: [
          // the Dimensions extension allows us to use inset/radii/border with like a theme
          // for our use case, we define the medium value as below and use this throughout the app
          Dimensions(
              insets: InsetDimensions.fromMedium(15),
              radii: RadiusDimensions.fromMedium(15),
              borderWidths: BorderWidthDimensions.fromMedium(2)),
        ],
      ),

      themeMode: themeNotifier.currentTheme,
      home: isFirstTime
          ? OnboardingScreen(isFirstTime, themeNotifier)
          : MyHomePage(title: 'TaskZoo Task Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final IsarService service = IsarService();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _navBarIndex = 1;
  late PageController _pageController;
  late ThemeNotifier themeNotifier;
  late HapticNotifier hapticNotifier;
  late SoundNotifer soundNotifier;

  @override
  void initState() {
    super.initState();
    widget.service.initalizeTotalCollectedPieces();
    widget.service.initalizeThemeSetting();
    widget.service.initalizeHapticSetting();
    widget.service.initalizeSoundSetting();

    _pageController =
        PageController(initialPage: _navBarIndex - 1); // Adjust the initialPage
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    hapticNotifier = Provider.of<HapticNotifier>(context, listen: false);
    soundNotifier = Provider.of<SoundNotifer>(context, listen: false);

    setThemeNotifier(themeNotifier);
    setHapticNotifier(hapticNotifier);
    setSoundNotifier(soundNotifier);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    hapticNotifier = Provider.of<HapticNotifier>(context, listen: false);
    soundNotifier = Provider.of<SoundNotifer>(context, listen: false);

    final pages = [
      HomePage(
        service: widget.service,
        themeNotifier: themeNotifier,
      ),
      ChangeNotifierProvider(
        create: (context) => ZooNotifier(),
        child: ZooPage(
          service: widget.service,
        ),
      ),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _navBarIndex = index + 1;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _navBarIndex,
        onTap: (index) {
          if (index == 0 || index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => index == 0
                      ? StatsPage(service: widget.service)
                      : SettingsPage(
                          service: widget.service,
                          themeNotifier: themeNotifier,
                          hapticNotifier: hapticNotifier,
                          soundNotifier: soundNotifier)),
            );
          } else {
            _pageController.jumpToPage(index - 1);
          }
        },
      ),
    );
  }

  Future<void> setThemeNotifier(ThemeNotifier themeNotifier) async {
    bool darkMode =
        await widget.service.getPreference("theme").then((value) => value != 0);
    setState(() {
      if (darkMode == true && themeNotifier.currentTheme == ThemeMode.light) {
        themeNotifier.toggleTheme();
      }
    });
  }

  Future<void> setHapticNotifier(HapticNotifier hapticNotifier) async {
    bool hapticEnabled = await widget.service
        .getPreference("hapticFeedback")
        .then((value) => value != 0);
    setState(() {
      if (hapticEnabled == true && hapticNotifier.hapticStatus == 0) {
        hapticNotifier.toggleHaptic();
      }
    });
  }

  Future<void> setSoundNotifier(SoundNotifer soundNotifer) async {
    bool soundEnabled =
        await widget.service.getPreference("sound").then((value) => value != 0);
    setState(() {
      if (soundEnabled == true && soundNotifer.soundValue == 0) {
        soundNotifer.toggleSound();
      }
    });
  }
}

void printKey() {
  print("theme: ${"theme".hashCode.abs()}");
  print("hapticFeedback: ${"hapticFeedback".hashCode.abs()}");
  print("totalCollectedPieces: ${"totalCollectedPieces".hashCode.abs()}");
  print("sound: ${"sound".hashCode.abs()}");
}
