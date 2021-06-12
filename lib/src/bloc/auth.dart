import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  String errorMessage;
  User currentUser = auth().currentUser;
  StreamSubscription authStateSubscription;

  AuthModel() {
    authStateSubscription = auth().onAuthStateChanged.listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    authStateSubscription.cancel();
  }

  void login(String email, String password) async {
    try {
      await auth().signInWithEmailAndPassword(email, password);
      errorMessage = null;
    } on FirebaseError catch (e) {
      errorMessage = e.message;
      notifyListeners();
    }
  }

  void logout() async {
    await auth().signOut();
  }

  void resetPassword() {
    auth().sendPasswordResetEmail(currentUser.email);
  }
}
