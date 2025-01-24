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
    if (Platform.isIOS) {
      // iOS is not supported for now
      return;
    }

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

  @Deprecated('Not working anymore')
  Future<SendNotificationResult> sendNotification(
    String title,
    String body,
  ) async {
    try {
      final service = _chopper.getService<FcmService>();
      final responseForTopic = await service.send(
        FcmSendToTopicDTO(
          kDebugMode ? '/topics/debug' : '/topics/release',
          FcmNotificationDTO(title, body, 'default'),
        ).toJson(),
      );

      final fcmTokens = await _getAndClearTokens();
      final webTokens = fcmTokens
          .where((token) => token.platform == DevicePlatform.WEB)
          .where((token) =>
              kDebugMode ? token.uid == 'Ng0JWZrxfahk6qDFdflGL0HDVQz1' : true)
          .map((token) => token.token)
          .toList();

      final responseForTokens = await service.send(
        FcmSendToTokensDTO(
          webTokens,
          FcmNotificationDTO(title, body, 'default'),
        ).toJson(),
      );

      if (responseForTopic.isSuccessful && responseForTokens.isSuccessful) {
        return SendNotificationResult.SUCCESS;
      } else if (responseForTopic.isSuccessful &&
          !responseForTokens.isSuccessful) {
        return SendNotificationResult.FAILURE_WEB;
      } else if (!responseForTopic.isSuccessful &&
          responseForTokens.isSuccessful) {
        return SendNotificationResult.FAILURE_TOPIC;
      } else {
        return SendNotificationResult.FAILURE;
      }
    } catch (e) {
      debugPrint(e.toString());
      return SendNotificationResult.FAILURE;
    }
  }

  @Deprecated('Not working anymore')
  Future<SendNotificationResult> sendNotificationToUsers(
    String title,
    String body,
    List<String> uids,
  ) async {
    try {
      final service = _chopper.getService<FcmService>();
      final tokens = (await _getAndClearTokens())
          .where((token) => uids.contains(token.uid))
          .map((e) => e.token)
          .toList();
      final response = await service.send(
        FcmSendToTokensDTO(
          tokens,
          FcmNotificationDTO(title, body, 'default'),
        ).toJson(),
      );
      if (response.isSuccessful) {
        return SendNotificationResult.SUCCESS;
      } else {
        return SendNotificationResult.FAILURE;
      }
    } catch (e) {
      debugPrint(e.toString());
      return SendNotificationResult.FAILURE;
    }
  }

  /// get FCM tokens and remove old tokens
  Future<List<FcmToken>> _getAndClearTokens() async {
    List<FcmToken> resultList = [];
    final snapshot =
        (await FirebaseDatabase.instance.ref('fcm').once()).snapshot;
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

enum SendNotificationResult { SUCCESS, FAILURE, FAILURE_TOPIC, FAILURE_WEB }
