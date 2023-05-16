// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../src/data/remote/dto/event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EventDTO _$$_EventDTOFromJson(Map<String, dynamic> json) => _$_EventDTO(
      json['id'] as int,
      json['category_id'] as int,
      json['date'] as String,
      json['note'] as String?,
      json['audio'] as String?,
      json['short_desc'] as String?,
      json['is_draft'] as int,
      json['is_archive'] as int,
      json['music_group_id'] as int?,
      json['video'] as String?,
    );

Map<String, dynamic> _$$_EventDTOToJson(_$_EventDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'date': instance.date,
      'note': instance.note,
      'audio': instance.audio,
      'short_desc': instance.shortDesc,
      'is_draft': instance.isDraft,
      'is_archive': instance.isArchive,
      'music_group_id': instance.musicGroupId,
      'video': instance.video,
    };
