import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../../generated/src/data/remote/dto/fcm_notification.g.dart';

@JsonSerializable()
class FcmNotificationDTO {
  final String title;
  final String body;
  final String sound;

  FcmNotificationDTO(this.title, this.body, this.sound);

  factory FcmNotificationDTO.fromJson(Map<String, dynamic> json) =>
      _$FcmNotificationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FcmNotificationDTOToJson(this);
}
