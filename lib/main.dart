import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:operators/firebase_options.dart';
import 'package:operators/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    if (kDebugMode) {
      await FirebaseMessaging.instance.subscribeToTopic('debug');
    } else {
      await FirebaseMessaging.instance.subscribeToTopic('release');
    }
  }
  FirebaseMessaging.instance.requestPermission();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(OperatorsApp());
}

void saveFcmToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  final format = DateFormat('yyyy-MM-dd HH:mm:ss');
  final dateTime = format.format(DateTime.now());
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final String platform;
  if (kIsWeb) {
    platform = 'web';
  } else if (Platform.isAndroid) {
    platform = 'android';
  } else if (Platform.isIOS) {
    platform = 'ios';
  } else {
    platform = 'unknown';
  }

  if (fcmToken != null) {
    FirebaseDatabase.instance.ref('fcm/$fcmToken').set({
      'dateTime': dateTime,
      'uid': uid,
      'platform': platform,
    });
  }
}
