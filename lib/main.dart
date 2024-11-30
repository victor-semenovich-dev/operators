import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:operators/src/app.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

late StreamingSharedPreferences preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await StreamingSharedPreferences.instance;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(OperatorsApp());
}
