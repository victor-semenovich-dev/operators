// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../src/data/remote/dto/fcm_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmNotificationDTO _$FcmNotificationDTOFromJson(Map<String, dynamic> json) =>
    FcmNotificationDTO(
      json['title'] as String,
      json['body'] as String,
      json['sound'] as String,
    );

Map<String, dynamic> _$FcmNotificationDTOToJson(FcmNotificationDTO instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'sound': instance.sound,
    };
