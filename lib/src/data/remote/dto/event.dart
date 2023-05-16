// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../../generated/src/data/remote/dto/event.freezed.dart';
part '../../../../generated/src/data/remote/dto/event.g.dart';

@freezed
class EventDTO with _$EventDTO {
  const EventDTO._();

  const factory EventDTO(
    @JsonKey(name: 'id') int id,
    @JsonKey(name: 'category_id') int categoryId,
    @JsonKey(name: 'date') String date,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'audio') String? audio,
    @JsonKey(name: 'short_desc') String? shortDesc,
    @JsonKey(name: 'is_draft') int isDraft,
    @JsonKey(name: 'is_archive') int isArchive,
    @JsonKey(name: 'music_group_id') int? musicGroupId,
    @JsonKey(name: 'video') String? video,
  ) = _EventDTO;

  factory EventDTO.fromJson(Map<String, dynamic> json) =>
      _$EventDTOFromJson(json);

  static const fromJsonFactory = _$EventDTOFromJson;
}
