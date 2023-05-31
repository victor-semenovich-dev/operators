// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../src/data/remote/dto/fcm_topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmSendToTopicDTO _$FcmSendToTopicDTOFromJson(Map<String, dynamic> json) =>
    FcmSendToTopicDTO(
      json['to'] as String,
      FcmNotificationDTO.fromJson(json['notification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FcmSendToTopicDTOToJson(FcmSendToTopicDTO instance) =>
    <String, dynamic>{
      'to': instance.to,
      'notification': instance.notification,
    };
