import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../services/notifcation_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsOn = false;

  @override
  void initState() {
    initPref();
    super.initState();
  }

  Future<void> initPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _notificationsOn = prefs.getBool("notify") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: const Text("Enable Wishlist notifications"),
            leading: CupertinoSwitch(
              activeColor: Colors.redAccent,
              value: _notificationsOn,
              onChanged: (value) async {
                setState(() {
                  _notificationsOn = !_notificationsOn;
                });

                final prefs = await SharedPreferences.getInstance();
                prefs.setBool("notify", _notificationsOn);

                if (_notificationsOn) {
                  notifications
                      .resolvePlatformSpecificImplementation<
                          AndroidFlutterLocalNotificationsPlugin>()
                      ?.requestPermission();

                  Workmanager().registerPeriodicTask(
                    "storeCheck${DateTime.now().toString()}",
                    "ValStoreStoreRenewal",
                    initialDelay: const Duration(
                      seconds: 5,
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
                  Workmanager().cancelAll();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
