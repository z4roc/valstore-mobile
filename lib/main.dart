import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:valstore/firebase_options.dart';
import 'package:valstore/routes.dart';
import 'package:valstore/services/notifcation_service.dart';
import 'package:valstore/services/riot_service.dart';
import 'package:valstore/theme.dart';
import 'package:valstore/valstore_provider.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          name: "notification",
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } else {
        Firebase.app();
      }

      switch (taskName) {
        case "ValStoreStoreRenewal":
          await RiotService.recheckStore();
          break;
        case "NightMarketRenewal":
          await RiotService.recheckNightmarket();
          break;
        case "ValStoreBundleRenewal":
          await RiotService.recheckBundle();
          break;
        default:
      }
      return Future.value(true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    Firebase.app();
  }

  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  }

  await NotificationService.initialize();

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
          theme: themeData,
        );
      },
    );
  }
}
