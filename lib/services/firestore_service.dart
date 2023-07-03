import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valstore/models/firebase_skin.dart';
import 'package:valstore/models/local_offers.dart';
import 'package:valstore/models/store_models.dart';
import 'package:valstore/services/inofficial_valorant_api.dart';
import 'package:valstore/services/riot_service.dart';

import '../models/user_offers.dart';

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

  Future<void> registerSkin(Offers? offer) async {
    if (offer == null) {
      return;
    }

    final allItems = await RiotService.getAllSkins();

    final match = allItems!.data!.where((item) {
      return item.levels?.first.uuid == offer.offerID!;
    }).first;

    FirebaseSkin newSkin = FirebaseSkin(
        icon: match.displayIcon,
        chromas: match.chromas as List<Chroma>,
        contentTier: ContentTier());
  }

  final contentiers = {
    875: {
      "name": "Select",
      "icon":
          "https://media.valorant-api.com/contenttiers/12683d76-48d7-84a3-4e09-6985794f0445/displayicon.png",
    },
    1275: {
      "name": "Deluxe",
      "icon":
          "https://media.valorant-api.com/contenttiers/0cebb8be-46d7-c12a-d306-e9907bfc5a25/displayicon.png"
    },
    1775: {
      "name": "Premium",
      "icon":
          "https://media.valorant-api.com/contenttiers/60bca009-4182-7998-dee7-b8a2558dc369/displayicon.png"
    },
    2175: {
      "name": "Exclusive",
      "icon":
          "https://media.valorant-api.com/weaponskinlevels/09fded5d-4add-00e7-d3c4-32b8f21c7944/displayicon.png"
    },
  };

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
        .map((e) => "$e" as String)
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
      List<AccessoryStoreOffers>? uuids) async {
    List<FirebaseSkin> skins = [];

    if (uuids == null) {
      return skins;
    }

    for (var element in uuids) {
      final docRef =
          _db.collection("skins").doc(element.offer?.rewards?[0].itemID);

      var doc = (await docRef.get());

      if (!doc.exists) {
        final accessories =
            await InofficialValorantAPI().getAllDisplayableItems();

        final matches = accessories
            .where(
              (item) => item.uuid == element.offer?.rewards?[0].itemID,
            )
            .toList();
        for (var match in matches) {
          await _db.collection("skins").doc(match.uuid).set({
            "offerId": match.uuid,
            "name": match.displayName,
            "icon": match.displayIcon,
          });
        }
        doc = (await docRef.get());
      }

      if (doc.data() != null) {
        skins.add(FirebaseSkin.fromJson(doc.data()!));
      }
      print(element.offer?.rewards?[0].itemID);
    }

    for (int i = 0; i < skins.length; i++) {
      if (skins[i].cost == null) {
        skins[i].cost =
            uuids[i].offer?.cost?.i85ad13f73d1b51289eb27cd8ee0b5741 ?? 0;
      }
    }

    return skins;
  }
}
