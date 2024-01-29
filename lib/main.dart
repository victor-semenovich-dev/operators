import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:operators/firebase_options.dart';
import 'package:operators/firebase_options_eu.dart';
import 'package:operators/src/app.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

late StreamingSharedPreferences preferences;

late FirebaseApp euFirebaseApp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await StreamingSharedPreferences.instance;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  euFirebaseApp = await Firebase.initializeApp(
    name: 'eu',
    options: EuFirebaseOptions.currentPlatform,
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
