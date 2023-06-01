import 'package:operators/src/data/remote/dto/fcm_token_data.dart';

class FcmToken {
  final String token;
  final DateTime dateTime;
  final DevicePlatform platform;
  final String? uid;

  FcmToken(this.token, this.dateTime, this.platform, this.uid);

  @override
  String toString() {
    return 'FcmToken{token: $token, dateTime: $dateTime, platform: $platform, uid: $uid}';
  }
}
