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

  // Запускаем только критически важные задачи для старта
  final futureResults = await Future.wait([
    StreamingSharedPreferences.instance,
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
  ]);

  preferences = futureResults[0] as StreamingSharedPreferences;
  usaFirebaseDatabase = FirebaseDatabase.instance;

  // Инициализируем EU в фоне или лениво, не дожидаясь здесь
  _initEuFirebase();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(OperatorsApp());
}

Future<void> _initEuFirebase() async {
  try {
    final euApp = await Firebase.initializeApp(
      name: 'eu',
      options: EuFirebaseOptions.currentPlatform,
    );
    euFirebaseDatabase = FirebaseDatabase.instanceFor(app: euApp);
  } catch (e) {
    debugPrint('Error initializing EU Firebase: $e');
  }
}
