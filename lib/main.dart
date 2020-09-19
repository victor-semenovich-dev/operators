import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:operators/src/app.dart';

void main() {
  if (firebase.apps.isEmpty) {
    firebase.initializeApp(
        apiKey: "AIzaSyAoI5fsV_vRHrJfLSHT0U13Cp-bzOc9TMY",
        authDomain: "operators-5f1b2.firebaseapp.com",
        databaseURL: "https://operators-5f1b2.firebaseio.com",
        projectId: "operators-5f1b2",
        storageBucket: "operators-5f1b2.appspot.com",
        messagingSenderId: "562136210693",
        appId: "1:562136210693:web:0038f5c399a7402433eb6c"
    );
  }
  runApp(OperatorsApp());
}
