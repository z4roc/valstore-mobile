import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valstore/main.dart';
import 'package:valstore/models/bundle_display_data.dart';
import 'package:valstore/models/player.dart';
import 'package:valstore/models/valstore.dart';
import 'package:valstore/services/inofficial_valorant_api.dart';
import 'package:valstore/services/riot_service.dart';

import 'services/firestore_service.dart';

class ValstoreProvider extends ChangeNotifier {
  static late Valstore _instance;
  static bool _shouldNotify = false;

  Valstore get getInstance => _instance;

  bool get shouldNotify => _shouldNotify;

  Future<List<BundleDisplayData?>?> getBundles() async {
    _instance.bundles = await RiotService.getCurrentBundle();
    return _instance.bundles;
  }

  Future<bool> getNightMarket() async {
    _instance.nightMarket = await RiotService.getNightMarket();
    if (_instance.nightMarket != null) {
      return true;
    }
    return false;
  }

  Future<Player?> getPlayerInfo() async {
    _instance.player = await RiotService.getUserData();

    return _instance.player;
  }

  Future<Valstore> initValstore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? region = prefs.getString("region");

      if (region == null) {
        navigatorKey.currentState!.pushNamed("/region");
      }

      RiotService.playerShop = null;
      RiotService.region = region!;
      RiotService.platformHeaders["X-Riot-ClientVersion"] =
          (await InofficialValorantAPI()
              .getCurrentVersion())["riotClientVersion"];
      RiotService.userOffers = await RiotService.getUserOffers();

      _instance = Valstore();

      _instance.playerShop = await RiotService.getStore();
      _instance.player = await RiotService.getUserData();

      /*
    _instance = Valstore();

    _instance.playerShop = await RiotService.getStore();
    _instance.player = await RiotService.getUserData();

    /*
    _instance = Valstore(
      playerShop: await RiotService.getStore(),
      player: await RiotService.getUserData(),
      bundles: await RiotService.getCurrentBundle(),
      nightMarket: await RiotService.getNightMarket(),
      nightMarket: await RiotService.getNightMarket(),
      playerInventory: await RiotService.getUserOwnedItems(),
      localOffers: await RiotService.getLocalOffers(),
    );*/
    );*/
      await initWishlist();
      notifyListeners();

      return _instance;
    } catch (e) {
      rethrow;
      // return _instance;
    }
  }

  static List<String> _skins = [];

  List<String> get skins => _skins;

  void toggleWishlist(String uuid) {
    final isWished = _skins.contains(uuid);

    if (isWished) {
      FireStoreService()
          .removeSkinFromWishlist(RiotService.userId, uuid)
          .then((value) => null);
      _skins.remove(uuid);
    } else {
      FireStoreService()
          .addSkinToUserWishlist(RiotService.userId, uuid)
          .then((value) => null);
      _skins.add(uuid);
    }
    notifyListeners();
  }

  bool isInWishlist(String uuid) => _skins.contains(uuid);

  void clearWishlist() {
    _skins = [];
  }

  Future<void> initWishlist() async {
    _skins = await FireStoreService().getUserWishlist(RiotService.userId);
    notifyListeners();
  }
}
