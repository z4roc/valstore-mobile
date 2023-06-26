import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valstore/models/firebase_skin.dart';

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
    var colRef = _db.collection("skins");
    var qry = colRef.where("skin_id", isEqualTo: uuid);

    final skin = await qry.get();

    return FirebaseSkin.fromJson(skin.docs.first.data());
  }

  Future<void> registerUser(String uuid) async {
    var docRef = _db.collection("users").doc(uuid);

    if ((await docRef.get()).exists) {
      return;
    } else {
      await docRef.set({"wishlist": []});
    }
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
}
