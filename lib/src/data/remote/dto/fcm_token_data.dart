import 'package:intl/intl.dart';

class FcmTokenData {
  final DateTime dateTime;
  final DevicePlatform platform;
  final String? uid;

  FcmTokenData(this.dateTime, this.platform, this.uid);

  factory FcmTokenData.fromJson(Map json) => FcmTokenData(
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['dateTime']),
        _platformFromString(json['platform']),
        json['uid'],
      );

  static DevicePlatform _platformFromString(String str) {
    switch (str) {
      case 'android':
        return DevicePlatform.ANDROID;
      case 'ios':
        return DevicePlatform.IOS;
      case 'web':
        return DevicePlatform.WEB;
      default:
        return DevicePlatform.UNKNOWN;
    }
  }
}

enum DevicePlatform { ANDROID, IOS, WEB, UNKNOWN }
