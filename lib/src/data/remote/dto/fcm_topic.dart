import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:operators/src/data/remote/dto/fcm_notification.dart';

part '../../../../generated/src/data/remote/dto/fcm_topic.g.dart';

@JsonSerializable()
class FcmSendToTopicDTO {
  final String to;
  final FcmNotificationDTO notification;

  FcmSendToTopicDTO(this.to, this.notification);

  factory FcmSendToTopicDTO.fromJson(Map<String, dynamic> json) =>
      _$FcmSendToTopicDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FcmSendToTopicDTOToJson(this);
}
