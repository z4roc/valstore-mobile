import 'package:flutter/material.dart';
import 'package:valstore/services/firestore_service.dart';
import 'package:valstore/services/riot_service.dart';

class WishlistProvider extends ChangeNotifier {
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
  }
}
