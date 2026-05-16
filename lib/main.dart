import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:operators/firebase_options.dart';
import 'package:operators/firebase_options_eu.dart';
import 'package:operators/src/app.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

late StreamingSharedPreferences preferences;

late FirebaseDatabase usaFirebaseDatabase;
FirebaseDatabase? euFirebaseDatabase = null;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Запускаем асинхронные задачи одновременно
  final futureResults = await Future.wait([
    StreamingSharedPreferences.instance,
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);

  preferences = futureResults[0] as StreamingSharedPreferences;

  Firebase.initializeApp(
    name: 'eu',
    options: EuFirebaseOptions.currentPlatform,
  ).then((app) {
    euFirebaseDatabase = FirebaseDatabase.instanceFor(app: app);
  });

  usaFirebaseDatabase = FirebaseDatabase.instance;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(OperatorsApp());
}
