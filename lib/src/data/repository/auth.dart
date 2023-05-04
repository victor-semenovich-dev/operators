import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();

  Future<void> login(String email, String password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }

  Future<void> resetPassword({String? customEmail}) async {
    final email = customEmail ?? FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
  }
}
