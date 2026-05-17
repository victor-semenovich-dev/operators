// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../src/data/remote/dto/event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventDTO _$EventDTOFromJson(Map<String, dynamic> json) => EventDTO(
      (json['id'] as num).toInt(),
      EventDTO._categoryById((json['category_id'] as num).toInt()),
      DateTime.parse(json['date'] as String),
      json['note'] as String?,
      json['audio'] as String?,
      json['short_desc'] as String?,
      EventDTO._boolFromInt((json['is_draft'] as num).toInt()),
      EventDTO._boolFromInt((json['is_archive'] as num).toInt()),
      (json['music_group_id'] as num?)?.toInt(),
      json['video'] as String?,
    );
