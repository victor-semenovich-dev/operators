import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
