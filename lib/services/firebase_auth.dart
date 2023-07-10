import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  Future<void> signInAnonymous() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        FirebaseAuth.instance.signInAnonymously();
      }
    } catch (e) {}
  }

  Future<void> signOut() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
    }
  }
}
