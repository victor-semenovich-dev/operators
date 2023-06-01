import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:operators/src/data/remote/dto/fcm_notification.dart';

part '../../../../generated/src/data/remote/dto/fcm_tokens.g.dart';

@JsonSerializable()
class FcmSendToTokensDTO {
  @JsonKey(name: 'registration_ids')
  final List<String> registrationIds;
  final FcmNotificationDTO notification;

  FcmSendToTokensDTO(this.registrationIds, this.notification);

  factory FcmSendToTokensDTO.fromJson(Map<String, dynamic> json) =>
      _$FcmSendToTokensDTOFromJson(json);

  Map<String, dynamic> toJson() => _$FcmSendToTokensDTOToJson(this);
}
