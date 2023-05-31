import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:operators/src/data/remote/dto/fcm_notification.dart';
import 'package:operators/src/data/remote/dto/fcm_topic.dart';
import 'package:operators/src/data/remote/interceptor/fcm.dart';
import 'package:operators/src/data/remote/service/fcm.dart';

class FcmRepository {
  final _chopper = ChopperClient(
    baseUrl: Uri.parse('https://fcm.googleapis.com/fcm'),
    converter: JsonConverter(),
    services: [FcmService.create()],
    interceptors: [HttpLoggingInterceptor(), FcmInterceptor()],
  );

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

  Future<bool> sendNotification(String title, String body) async {
    final service = _chopper.getService<FcmService>();
    final response = await service.send(
      FcmSendToTopicDTO(
        '/topics/release',
        FcmNotificationDTO(title, body, 'default'),
      ).toJson(),
    );
    return response.isSuccessful;
  }
}
