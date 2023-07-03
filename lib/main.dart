import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
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
import 'package:valstore/v2/valstore_provider.dart';
import 'package:valstore/wishlist_provider.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
Future<void> onBackgroundMessage(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  RiotService.recheckStore();
}

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    /*await showNotification(
      title: "Store check executed",
      body: "Store checked",
    );*/
    try {
      if (notifications == null) notifications.initialize(initSettings);
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      await RiotService.recheckStore();

      return Future.value(true);
    } catch (e) {
      showNotification(title: "Task failed", body: e.toString());
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notifications.initialize(initSettings);
  MobileAds.instance.initialize();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);

  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ValstoreProvider(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: routes,
          navigatorKey: navigatorKey,
          theme: light,
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

  late Future<void> _loadPrefs;

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool('login');
    prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString("cookie");
    String? region = prefs.getString("region");
    if (cookie != null && region != null && login != null && login) {
      await RiotService.reuathenticateUser();
      navigatorKey.currentState!.pushNamed("/store");
    } else if (login != null && login) {
      navigatorKey.currentState!.pushNamed("/login");
    } else if (region == null) {
      navigatorKey.currentState!.pushNamed("/region");
    }
    setState(() {
      isChecked = login ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs = loadPrefs();
  }

  bool isChecked = false;

  String selectedRegion = "eu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0x090909),
      body: FutureBuilder(
        future: _loadPrefs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
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
                  const CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            return Container(
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
                      String? region = prefs.getString("region");

                      if (region == null) {
                        navigatorKey.currentState!.pushNamed("/region");
                      } else {
                        navigatorKey.currentState!.pushNamed('/login');
                      }
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
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.red),
                      ),
                      const Text('Automatically sign me in next time'),
                    ],
                  )
                ],
              ),
            );
          }
        },
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

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  late Future<void> _loadPrefs;

  Future<void> initMessaging() async {
    await FirebaseMessaging.instance.requestPermission();
    String token = await FirebaseMessaging.instance.getToken() ?? "";
    //print("token");
  }

  @override
  void initState() {
    super.initState();
    initMessaging();
    _loadPrefs = loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    "assets/Valstore_Icon.png",
                    height: 120,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CircularProgressIndicator(
                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Container(
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      "assets/Valstore_Icon.png",
                      height: 120,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Loading..."),
                    const SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

Future<void> loadPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs = await SharedPreferences.getInstance();
  bool? login = prefs.getBool('login');
  String? cookie = prefs.getString("cookie");
  String? region = prefs.getString("region");

  if (cookie != null && region != null) {
    await RiotService.reuathenticateUser();
    navigatorKey.currentState!.pushNamed("/store");
  } else if (region == null) {
    navigatorKey.currentState!.pushNamed("/region");
  } else if (login != null && login) {
    navigatorKey.currentState!.pushNamed('/login');
  }
}
