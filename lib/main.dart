import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valstore/firebase_options.dart';
import 'package:valstore/routes.dart';
import 'package:valstore/services/notifcation_service.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/theme.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await notifications.initialize(initSettings);
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.local);
  FirebaseMessaging.onBackgroundMessage(
    (message) => onBackgroundMessage(message),
  );
  runApp(const MyApp());
}

@pragma("vm:entry-point")
Future<void> onBackgroundMessage(RemoteMessage message) async {
  RiotService.recheckStore();
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        ThemeProvider().initTheme();
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: routes,
          navigatorKey: navigatorKey,
          theme: light,
          darkTheme: dark,
          themeMode: themeProvider.themeMode,
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;

  Future<void> initMessaging() async {
    await FirebaseMessaging.instance.requestPermission();
    String token = await FirebaseMessaging.instance.getToken() ?? "";
    //print("token");
  }

  @override
  void initState() {
    initMessaging();
    loadPrefs();
    super.initState();
  }

  void loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool('login');
    if (login != null && login) {
      navigatorKey.currentState!.pushNamed('/login');
    }
  }

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x090909),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Valstore_Icon.png",
              height: 120,
            ),
            const Text(
              'ValStore',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "A way to check all your Valorant Store offers everyday, without starting the game.",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                navigatorKey.currentState!.pushNamed('/login');
              },
              child: const Text(
                'Login at Riot games',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                    prefs.setBool('login', value!);
                  },
                  fillColor:
                      MaterialStateProperty.resolveWith((states) => Colors.red),
                ),
                const Text('Automatically sign me in next time'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Restarter extends StatefulWidget {
  const Restarter({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestarterState>()?.restartApp();
  }

  @override
  State<Restarter> createState() => _RestarterState();
}

class _RestarterState extends State<Restarter> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
