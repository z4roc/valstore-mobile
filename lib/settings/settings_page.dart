import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valstore/services/notifcation_service.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:workmanager/workmanager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsOn = false;
  bool _nmNotificationsOn = false;
  bool _bundleNotificationsOn = false;

  @override
  void initState() {
    initPref();
    super.initState();
  }

  Future<void> initPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _notificationsOn = prefs.getBool("notify") ?? false;
      _nmNotificationsOn = prefs.getBool("notifyNM") ?? false;
      _bundleNotificationsOn = prefs.getBool("notifyBundle") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                "Notifications (Beta)",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            switchTile(enableWishlistNotification, "Wishlist Notifications",
                _notificationsOn),
            const Divider(
              color: Color.fromARGB(255, 74, 74, 104),
            ),
            switchTile(enableNightmarketNotification,
                "Night Market Notifications", _nmNotificationsOn),
            const Divider(
              color: Color.fromARGB(255, 74, 74, 104),
            ),
            switchTile(
              enableBundleNotifications,
              "Bundle Notifications",
              _bundleNotificationsOn,
            ),
            const Divider(
              color: Color.fromARGB(255, 74, 74, 104),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Links",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8),
              child: ListTile(
                visualDensity: VisualDensity.compact,
                onTap: () async {
                  await launchUrl(
                    Uri.parse("https://github.com/z4roc/valstore-mobile"),
                  );
                },
                title: const Text(
                  "Source Code",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                leading: const Icon(FontAwesomeIcons.github),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 4),
              child: ListTile(
                visualDensity: VisualDensity.compact,
                onTap: () async {
                  await launchUrl(
                    Uri.parse("https://twitter.com/zaroc_dev"),
                  );
                },
                title: const Text(
                  "Follow Me on Twitter/X",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                leading: const Icon(FontAwesomeIcons.xTwitter),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "About",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: const Card(
                color: Color.fromARGB(255, 31, 28, 37),
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Made by ZAROC#0420 (turbointerl9)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      Text("Thank you for using my App!"),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 220,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Card(
                color: const Color.fromARGB(255, 31, 28, 37),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "ValStore is free for use with all features and open source.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        "A donation would be really appreciated if you like the project :)",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await launchUrl(
                                Uri.parse("https://ko-fi.com/zaroc"),
                                mode: LaunchMode.externalApplication);
                          },
                          child: const Text("Donate"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextButton(
                onPressed: () async {
                  await launchUrl(
                    Uri.parse(
                      "https://valostore.zaroc.de/privacy",
                    ),
                  );
                },
                child: const Text("Privacy Policy"),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await RiotService.recheckStore();
              },
              child: const Text("Debug Info"),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text("ValStore 2.0.4"),
            ),
          ],
        ),
      ),
    );
  }

  Padding switchTile(Future<void> Function(bool on) enableNotificationFunction,
      String content, bool state) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        title: Text(content),
        leading: Transform.scale(
          scale: 0.8,
          child: CupertinoSwitch(
            activeColor: Colors.redAccent,
            value: state,
            onChanged: enableNotificationFunction,
          ),
        ),
      ),
    );
  }

  Future<void> enableWishlistNotification(value) async {
    setState(() {
      _notificationsOn = !_notificationsOn;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("notify", _notificationsOn);

    if (_notificationsOn) {
      /*await notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
      */

      await NotificationService.requestPermission();
      Workmanager().registerPeriodicTask(
        "storeCheck${DateTime.now().toString()}",
        "ValStoreStoreRenewal",
        tag: "ValStoreStoreRenewal",
        initialDelay: kDebugMode
            ? const Duration(seconds: 5)
            : Duration(
                minutes: getDelayForSync(),
              ),
        backoffPolicy: BackoffPolicy.linear,
        frequency: const Duration(
          days: 1,
        ),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } else {
      Workmanager().cancelByTag("ValStoreStoreRenewal");
    }
  }

  Future<void> enableNightmarketNotification(value) async {
    setState(() {
      _nmNotificationsOn = !_nmNotificationsOn;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("notifyNM", _nmNotificationsOn);

    if (_nmNotificationsOn) {
      /*await notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
      */
      await NotificationService.requestPermission();
      await prefs.setBool("didNotifyNM", false);

      await Workmanager().registerPeriodicTask(
        "NightMarketRenewal${DateTime.now().toString()}",
        "NightMarketRenewal",
        tag: "NightMarketRenewal",
        initialDelay: Duration(minutes: getDelayForSync()),
        frequency: const Duration(days: 1),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } else {
      await Workmanager().cancelByTag("NightMarketRenewal");
    }
  }

  Future<void> enableBundleNotifications(value) async {
    setState(() {
      _bundleNotificationsOn = !_bundleNotificationsOn;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("notifyBundle", _bundleNotificationsOn);

    if (_bundleNotificationsOn) {
      /*await notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
      */
      await NotificationService.requestPermission();
      final currentBundle = (await RiotService.getUserOffers())
          .featuredBundle
          ?.bundle
          ?.dataAssetID;

      prefs.setString(
        "currentBundle",
        currentBundle ?? "",
      );

      await Workmanager().registerPeriodicTask(
        "BundleRecheck${DateTime.now().toString()}",
        "ValStoreBundleRenewal",
        tag: "ValStoreBundleRenewal",
        initialDelay: Duration(minutes: getDelayForSync()),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } else {
      await Workmanager().cancelByTag("ValStoreBundleRenewal");
    }
  }
}

int getDelayForSync() {
  DateTime date = DateTime.now();

  date.toUtc();

  final tomorrow = DateTime.utc(date.year, date.month, date.day + 1);

  return tomorrow.difference(date).inMinutes + 60;
}
