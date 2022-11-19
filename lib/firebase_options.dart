// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAoI5fsV_vRHrJfLSHT0U13Cp-bzOc9TMY',
    appId: '1:562136210693:web:0038f5c399a7402433eb6c',
    messagingSenderId: '562136210693',
    projectId: 'operators-5f1b2',
    authDomain: 'operators-5f1b2.firebaseapp.com',
    databaseURL: 'https://operators-5f1b2.firebaseio.com',
    storageBucket: 'operators-5f1b2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCnp2BoGv0iElTqLxW4DWF6tloPDTVHLnk',
    appId: '1:562136210693:android:e4fed2069185e0b433eb6c',
    messagingSenderId: '562136210693',
    projectId: 'operators-5f1b2',
    databaseURL: 'https://operators-5f1b2.firebaseio.com',
    storageBucket: 'operators-5f1b2.appspot.com',
  );
}
