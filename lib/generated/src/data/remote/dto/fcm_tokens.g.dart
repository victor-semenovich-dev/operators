// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../src/data/remote/dto/fcm_tokens.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmSendToTokensDTO _$FcmSendToTokensDTOFromJson(Map<String, dynamic> json) =>
    FcmSendToTokensDTO(
      (json['registration_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      FcmNotificationDTO.fromJson(json['notification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FcmSendToTokensDTOToJson(FcmSendToTokensDTO instance) =>
    <String, dynamic>{
      'registration_ids': instance.registrationIds,
      'notification': instance.notification,
    };
