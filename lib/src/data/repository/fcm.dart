import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:operators/src/data/model/fcm_token.dart';
import 'package:operators/src/data/remote/dto/fcm_notification.dart';
import 'package:operators/src/data/remote/dto/fcm_token_data.dart';
import 'package:operators/src/data/remote/dto/fcm_tokens.dart';
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
    final responseForTopic = await service.send(
      FcmSendToTopicDTO(
        '/topics/release',
        FcmNotificationDTO(title, body, 'default'),
      ).toJson(),
    );

    final fcmTokens = await _getAndClearTokens();
    final webTokens = fcmTokens
        .where((token) => token.platform == DevicePlatform.WEB)
        // .where((token) => token.uid == 'Ng0JWZrxfahk6qDFdflGL0HDVQz1')
        .map((token) => token.token)
        .toList();
    debugPrint('${webTokens.length} tokens: $webTokens');

    final responseForTokens = await service.send(
      FcmSendToTokensDTO(
        webTokens,
        FcmNotificationDTO(title, body, 'default'),
      ).toJson(),
    );

    return responseForTopic.isSuccessful && responseForTokens.isSuccessful;
  }

  /// get FCM tokens and remove old tokens
  Future<List<FcmToken>> _getAndClearTokens() async {
    List<FcmToken> resultList = [];
    final snapshot = await FirebaseDatabase.instance.ref('fcm').get();
    if (snapshot.value is Map) {
      final fcmMap = snapshot.value as Map;
      fcmMap.forEach((token, data) {
        if (data is Map) {
          final tokenData = FcmTokenData.fromJson(data);
          if (DateTime.now().difference(tokenData.dateTime) >
              Duration(days: 60)) {
            // token is too old
            FirebaseDatabase.instance.ref('fcm/$token').remove();
          } else {
            resultList.add(FcmToken(
                token, tokenData.dateTime, tokenData.platform, tokenData.uid));
          }
        }
      });
    }
    return resultList;
  }
}
