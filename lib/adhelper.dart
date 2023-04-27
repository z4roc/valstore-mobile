import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid && !kDebugMode) {
      return "ca-app-pub-1408435828857197/5849431707";
    } else if (Platform.isAndroid && kDebugMode) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Ads not Configured for Platform");
    }
  }
}
