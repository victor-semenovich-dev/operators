import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stream_transform/stream_transform.dart';

class AuthRepository {
  Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();

  late Stream<bool> isAdminStream = userStream.switchMap((user) =>
      FirebaseDatabase.instance
          .ref('/admins/${user?.uid}/isAdmin')
          .onValue
          .map((event) => (event.snapshot.value as bool?) ?? false));

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
