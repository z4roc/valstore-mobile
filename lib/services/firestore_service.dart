import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:valstore/models/firebase_skin.dart';

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<FirebaseSkin?> getSkin(String uuid) async {
    var docRef = _db.collection("skins").doc(uuid);

    var snapshot = await docRef.get();

    return FirebaseSkin.fromJson(snapshot.data()!);
  }
}
