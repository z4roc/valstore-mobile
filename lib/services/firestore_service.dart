import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/inofficial_api_models.dart';
import 'package:valstore/services/inofficial_valorant_api.dart';
import 'package:valstore/services/riot_service.dart';

import "package:valstore/models/storefront.dart";

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<FirebaseSkin?> getSkin(String? uuid) async {
    if (uuid == null) return null;
    var docRef = _db.collection("skins").doc(uuid);

    var snapshot = await docRef.get();

    if (!snapshot.exists) return null;

    return FirebaseSkin.fromJson(snapshot.data()!);
  }

  Future<FirebaseSkin?> getSkinById(String uuid) async {
    var colRef = _db.collection("skins").doc(uuid);
    var doc = await colRef.get();

    return doc.data() != null ? FirebaseSkin.fromJson(doc.data()!) : null;
  }

  Future<void> registerUser(String uuid) async {
    var docRef = _db.collection("users").doc(uuid);

    if ((await docRef.get()).exists) {
      return;
    } else {
      await docRef.set({"wishlist": []});
    }
  }

  Future<FirebaseSkin?> getSkinBySkinId(String skinId) async {
    var docRef = _db.collection("skins").where("skin_id", isEqualTo: skinId);

    var snapshot = await docRef.get();

    if (snapshot.docs.isEmpty) {
      return null;
    } else {
      return FirebaseSkin.fromJson(snapshot.docs.first.data());
    }
  }

  Future<void> registerFullSkin(FirebaseSkin skin) async {
    final docRef = _db.collection("skins").doc(skin.offerId);

    await docRef.set(skin.toJson());
  }

  Future<FirebaseSkin> registerSkin(FirebaseSkin skin) async {
    final allSkin = await RiotService.getAllSkins();

    final match = allSkin?.data
        ?.where((adSkin) => adSkin.uuid == skin.skinId)
        .firstOrNull;

    if (match != null) {
      skin.offerId = match.levels?[0].uuid;
      skin.levels = match.levels
          /*?.map((e) => Level(
                uuid: e.uuid,
                displayIcon: e.displayIcon,
                displayName: e.displayName,
                assetPath: e.assetPath,
                levelItem: e.levelItem,
                streamedVideo: e.streamedVideo,
              ))
          .toList();*/
          ;
      skin.chromas = match.chromas
          /* ?.map(
            (e) => Chroma(
              uuid: e.uuid,
              displayIcon: e.displayIcon,
              displayName: e.displayName,
              assetPath: e.assetPath,
              fullRender: e.fullRender,
              swatch: e.swatch,
              streamedVideo: e.streamedVideo,
            ),
          )
          .toList()*/
          ;
      final docRef = _db.collection("skins").doc(skin.offerId);

      await docRef.set(skin.toJson());
    }

    return skin;
  }

  Future<void> addSkinToUserWishlist(String uuid, String offerId) async {
    var docRef = _db.collection("users").doc(uuid);

    docRef.update({
      "wishlist": FieldValue.arrayUnion([offerId])
    });
  }

  Future<List<String>> getUserWishlist(String uuid) async {
    var docRef = _db.collection("users").doc(uuid);

    var userDoc = await docRef.get();

    final data = ((await userDoc.data()?["wishlist"]) as List)
        .map((e) => e as String)
        .toList();

    return data;
  }

  Future<void> removeSkinFromWishlist(String userId, String uuid) async {
    var docRef = _db.collection("users").doc(userId);

    await docRef.update({
      "wishlist": FieldValue.arrayRemove([uuid])
    });
  }

  Future<List<FirebaseSkin>> getSkinsById(
      List<AccessoryStoreOffer>? uuids) async {
    List<FirebaseSkin> skins = [];

    if (uuids == null) {
      return skins;
    }

    for (var element in uuids) {
      final docRef =
          _db.collection("skins").doc(element.offer.rewards[0].itemID);

      var doc = (await docRef.get());

      if (!doc.exists) {
        final accessories =
            await InofficialValorantAPI().getAllDisplayableItems();

        final matches = accessories
            .where(
              (item) =>
                  item.uuid == element.offer?.rewards?[0].itemID ||
                  (item.runtimeType == Gunbuddie &&
                      (item as Gunbuddie).levels?[0].uuid ==
                          element.offer?.rewards?[0].itemID),
            )
            .toList();
        for (var match in matches) {
          if (match.runtimeType == Gunbuddie) {
            await _db
                .collection("skins")
                .doc((match as Gunbuddie).levels?[0].uuid)
                .set({
              "offerId": match.uuid,
              "name": match.displayName,
              "icon": match.displayIcon,
            });
          } else {
            await _db.collection("skins").doc(match.uuid).set({
              "offerId": match.uuid,
              "name": match.displayName,
              "icon": match.displayIcon,
            });
          }
        }

        doc = (await docRef.get());
      }

      if (doc.data() != null) {
        skins.add(FirebaseSkin.fromJson(doc.data()!));
      }
    }

    for (int i = 0; i < skins.length; i++) {
      if (skins[i].cost == null) {
        skins[i].cost =
            uuids[i].offer?.cost?["i85ad13f73d1b51289eb27cd8ee0b5741"] ?? 0;
      }
    }

    return skins;
  }
}
