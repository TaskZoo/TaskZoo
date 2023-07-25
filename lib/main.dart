import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dimensions_theme/dimensions_theme.dart';

import 'package:taskzoo/pages/home_page.dart';
import 'package:taskzoo/pages/zoo_page.dart';
import 'package:taskzoo/pages/stats_page.dart';
import 'package:taskzoo/pages/settings_page.dart';

import 'package:taskzoo/widgets/home/navbar.dart';

import 'package:taskzoo/misc/zoo_notifier.dart';
import 'package:taskzoo/widgets/isar_service.dart';
import 'package:taskzoo/widgets/preference_service.dart';

const maxCharLimit = 20;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  addDefaultTotalCollectedPieces();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskZoo',

      // getting info for how to do ThemeData at https://stackoverflow.com/questions/60232070/how-to-implement-dark-mode-and-light-mode-in-flutter
      theme: ThemeData(
        // What brightness we are defining
        brightness: Brightness.light,

        // darker white that is background of all pages besides zoo
        scaffoldBackgroundColor: Color.fromARGB(255, 245, 245, 245),
        // solid white that is color of any card
        cardColor: Colors.white,
        // black color for icons
        indicatorColor: Colors.black,
        // gray color used throughout the app
        dividerColor: Color.fromARGB(255, 123, 123, 123),

        extensions: [
          // the Dimensions extension allows us to use inset/radii/border with like a theme
          // for our use case, we define the medium value as below and use this throughout the app
          Dimensions(
            insets: InsetDimensions.fromMedium(15),
            radii: RadiusDimensions.fromMedium(15),
            borderWidths: BorderWidthDimensions.fromMedium(2)
          ),
        ],
      ),
      home: MyHomePage(title: 'TaskZoo Task Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final IsarService service = IsarService();
  final PreferenceService preferenceService = PreferenceService();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _navBarIndex = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _navBarIndex - 1); // Adjust the initialPage
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
          service: widget.service, preferenceService: widget.preferenceService),
      ChangeNotifierProvider(
        create: (context) => ZooNotifier(),
        child: ZooPage(
          preferenceService: widget.preferenceService,
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
                  builder: (context) =>
                      index == 0 ? const StatsPage() : const SettingsPage()),
            );
          } else {
            _pageController.jumpToPage(index - 1);
          }
        },
      ),
    );
  }
}

Future<void> addDefaultTotalCollectedPieces() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the preference "totalCollectedPieces" exists
  if (!prefs.containsKey('totalCollectedPieces')) {
    // If it doesn't exist, add it with the default value of 0
    await prefs.setInt('totalCollectedPieces', 0);
  }
}
