import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:operators/main.dart';

class AuthModel extends ChangeNotifier {
  User? currentUser = FirebaseAuth.instance.currentUser;
  late StreamSubscription authStateSubscription;

  AuthModel() {
    authStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    authStateSubscription.cancel();
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    saveFcmToken();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    saveFcmToken();
  }

  Future<void> resetPassword({String? customEmail}) async {
    final email = customEmail ?? currentUser?.email;
    if (email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
  }
}
