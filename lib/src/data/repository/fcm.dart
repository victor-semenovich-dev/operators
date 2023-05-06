import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class FcmRepository {
  Future<void> updateUserFcmData() async {
    final fcmToken = await FirebaseMessaging.instance.getToken(
      vapidKey: kIsWeb
          ? 'BNzLWzfJdWtA7l6uAfDkqDwX-I00QjykYZ5un3Zta7yeFGTgUUZyKZvbGpAoLmmpUSudghe0qW-lqxmqNyGh1W0'
          : null,
    );
    debugPrint('fcm token - $fcmToken');
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
}