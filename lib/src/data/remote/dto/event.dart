// ignore_for_file: invalid_annotation_target

import 'package:json_annotation/json_annotation.dart';

part '../../../../generated/src/data/remote/dto/event.g.dart';

@JsonSerializable(createToJson: false)
class EventDTO {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'category_id', fromJson: _categoryById)
  final CategoryDTO category;
  @JsonKey(name: 'date')
  final DateTime date;
  @JsonKey(name: 'note')
  final String? note;
  @JsonKey(name: 'audio')
  final String? audio;
  @JsonKey(name: 'short_desc')
  final String? shortDesc;
  @JsonKey(name: 'is_draft', fromJson: _boolFromInt)
  final bool isDraft;
  @JsonKey(name: 'is_archive', fromJson: _boolFromInt)
  final bool isArchive;
  @JsonKey(name: 'music_group_id')
  final int? musicGroupId;
  @JsonKey(name: 'video')
  final String? video;

  EventDTO(
    this.id,
    this.category,
    this.date,
    this.note,
    this.audio,
    this.shortDesc,
    this.isDraft,
    this.isArchive,
    this.musicGroupId,
    this.video,
  );

  factory EventDTO.fromJson(Map<String, dynamic> json) =>
      _$EventDTOFromJson(json);

  static const fromJsonFactory = _$EventDTOFromJson;

  static bool _boolFromInt(int value) => value > 0;

  static CategoryDTO _categoryById(int id) {
    switch (id) {
      case 10:
        return CategoryDTO.WORSHIP;
      default:
        return CategoryDTO.OTHER;
    }
  }

  @override
  String toString() {
    return 'EventDTO{id: $id, category: $category, date: $date, note: $note, audio: $audio, shortDesc: $shortDesc, isDraft: $isDraft, isArchive: $isArchive, musicGroupId: $musicGroupId, video: $video}';
  }
}

enum CategoryDTO {
  WORSHIP,
  OTHER,
}
