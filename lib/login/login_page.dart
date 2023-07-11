import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valstore/services/riot_service.dart';

import '../main.dart';

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
    if (!(login ?? false)) {
      return;
    }

    if (cookie != null && region != null && login != null && login) {
      try {
        await RiotService.reuathenticateUser();
        navigatorKey.currentState!.pushNamed("/store");
      } catch (e) {
        navigatorKey.currentState!.pushNamed("/login");
      }
    } else if (login != null && !login) {
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
                          (states) => const Color.fromARGB(255, 255, 70, 85),
                        ),
                        checkColor: Colors.white,
                      ),
                      const Text('Automatically sign me in next time'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () async {
                            await launchUrl(Uri.parse(
                                "https://github.com/z4roc/valstore-mobile"));
                          },
                          child: const Row(
                            children: [
                              Icon(FontAwesomeIcons.github, size: 22),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Source code"),
                            ],
                          ),
                          style: TextButton.styleFrom(
                            iconColor: Colors.grey,
                            foregroundColor: Colors.grey,
                          ),
                        ),
                      ),
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
