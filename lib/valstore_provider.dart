import 'package:flutter/material.dart';
import 'package:valstore/models/valstore.dart';
import 'package:valstore/services/riot_service.dart';

import 'services/firestore_service.dart';

class ValstoreProvider extends ChangeNotifier {
  static late Valstore _instance;

  Valstore get getInstance => _instance;

  Future<Valstore> initValstore() async {
    RiotService.userOffers = await RiotService.getUserOffers();

    _instance = Valstore(
      playerShop: await RiotService.getStore(),
      player: await RiotService.getUserData(),
      bundles: await RiotService.getCurrentBundle(),
      playerInventory: await RiotService.getUserOwnedItems(),
      localOffers: await RiotService.getLocalOffers(),
    );
    await initWishlist();
    notifyListeners();

    return _instance;
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
