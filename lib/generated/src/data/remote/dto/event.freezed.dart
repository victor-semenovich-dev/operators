// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../../../../src/data/remote/dto/event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EventDTO _$EventDTOFromJson(Map<String, dynamic> json) {
  return _EventDTO.fromJson(json);
}

/// @nodoc
mixin _$EventDTO {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'date')
  String get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'note')
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'audio')
  String? get audio => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_desc')
  String? get shortDesc => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_draft')
  int get isDraft => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_archive')
  int get isArchive => throw _privateConstructorUsedError;
  @JsonKey(name: 'music_group_id')
  int? get musicGroupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'video')
  String? get video => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventDTOCopyWith<EventDTO> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDTOCopyWith<$Res> {
  factory $EventDTOCopyWith(EventDTO value, $Res Function(EventDTO) then) =
      _$EventDTOCopyWithImpl<$Res, EventDTO>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'category_id') int categoryId,
      @JsonKey(name: 'date') String date,
      @JsonKey(name: 'note') String? note,
      @JsonKey(name: 'audio') String? audio,
      @JsonKey(name: 'short_desc') String? shortDesc,
      @JsonKey(name: 'is_draft') int isDraft,
      @JsonKey(name: 'is_archive') int isArchive,
      @JsonKey(name: 'music_group_id') int? musicGroupId,
      @JsonKey(name: 'video') String? video});
}

/// @nodoc
class _$EventDTOCopyWithImpl<$Res, $Val extends EventDTO>
    implements $EventDTOCopyWith<$Res> {
  _$EventDTOCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? date = null,
    Object? note = freezed,
    Object? audio = freezed,
    Object? shortDesc = freezed,
    Object? isDraft = null,
    Object? isArchive = null,
    Object? musicGroupId = freezed,
    Object? video = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      audio: freezed == audio
          ? _value.audio
          : audio // ignore: cast_nullable_to_non_nullable
              as String?,
      shortDesc: freezed == shortDesc
          ? _value.shortDesc
          : shortDesc // ignore: cast_nullable_to_non_nullable
              as String?,
      isDraft: null == isDraft
          ? _value.isDraft
          : isDraft // ignore: cast_nullable_to_non_nullable
              as int,
      isArchive: null == isArchive
          ? _value.isArchive
          : isArchive // ignore: cast_nullable_to_non_nullable
              as int,
      musicGroupId: freezed == musicGroupId
          ? _value.musicGroupId
          : musicGroupId // ignore: cast_nullable_to_non_nullable
              as int?,
      video: freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EventDTOCopyWith<$Res> implements $EventDTOCopyWith<$Res> {
  factory _$$_EventDTOCopyWith(
          _$_EventDTO value, $Res Function(_$_EventDTO) then) =
      __$$_EventDTOCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'category_id') int categoryId,
      @JsonKey(name: 'date') String date,
      @JsonKey(name: 'note') String? note,
      @JsonKey(name: 'audio') String? audio,
      @JsonKey(name: 'short_desc') String? shortDesc,
      @JsonKey(name: 'is_draft') int isDraft,
      @JsonKey(name: 'is_archive') int isArchive,
      @JsonKey(name: 'music_group_id') int? musicGroupId,
      @JsonKey(name: 'video') String? video});
}

/// @nodoc
class __$$_EventDTOCopyWithImpl<$Res>
    extends _$EventDTOCopyWithImpl<$Res, _$_EventDTO>
    implements _$$_EventDTOCopyWith<$Res> {
  __$$_EventDTOCopyWithImpl(
      _$_EventDTO _value, $Res Function(_$_EventDTO) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? date = null,
    Object? note = freezed,
    Object? audio = freezed,
    Object? shortDesc = freezed,
    Object? isDraft = null,
    Object? isArchive = null,
    Object? musicGroupId = freezed,
    Object? video = freezed,
  }) {
    return _then(_$_EventDTO(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == audio
          ? _value.audio
          : audio // ignore: cast_nullable_to_non_nullable
              as String?,
      freezed == shortDesc
          ? _value.shortDesc
          : shortDesc // ignore: cast_nullable_to_non_nullable
              as String?,
      null == isDraft
          ? _value.isDraft
          : isDraft // ignore: cast_nullable_to_non_nullable
              as int,
      null == isArchive
          ? _value.isArchive
          : isArchive // ignore: cast_nullable_to_non_nullable
              as int,
      freezed == musicGroupId
          ? _value.musicGroupId
          : musicGroupId // ignore: cast_nullable_to_non_nullable
              as int?,
      freezed == video
          ? _value.video
          : video // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_EventDTO extends _EventDTO {
  const _$_EventDTO(
      @JsonKey(name: 'id') this.id,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(name: 'date') this.date,
      @JsonKey(name: 'note') this.note,
      @JsonKey(name: 'audio') this.audio,
      @JsonKey(name: 'short_desc') this.shortDesc,
      @JsonKey(name: 'is_draft') this.isDraft,
      @JsonKey(name: 'is_archive') this.isArchive,
      @JsonKey(name: 'music_group_id') this.musicGroupId,
      @JsonKey(name: 'video') this.video)
      : super._();

  factory _$_EventDTO.fromJson(Map<String, dynamic> json) =>
      _$$_EventDTOFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'category_id')
  final int categoryId;
  @override
  @JsonKey(name: 'date')
  final String date;
  @override
  @JsonKey(name: 'note')
  final String? note;
  @override
  @JsonKey(name: 'audio')
  final String? audio;
  @override
  @JsonKey(name: 'short_desc')
  final String? shortDesc;
  @override
  @JsonKey(name: 'is_draft')
  final int isDraft;
  @override
  @JsonKey(name: 'is_archive')
  final int isArchive;
  @override
  @JsonKey(name: 'music_group_id')
  final int? musicGroupId;
  @override
  @JsonKey(name: 'video')
  final String? video;

  @override
  String toString() {
    return 'EventDTO(id: $id, categoryId: $categoryId, date: $date, note: $note, audio: $audio, shortDesc: $shortDesc, isDraft: $isDraft, isArchive: $isArchive, musicGroupId: $musicGroupId, video: $video)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EventDTO &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.audio, audio) || other.audio == audio) &&
            (identical(other.shortDesc, shortDesc) ||
                other.shortDesc == shortDesc) &&
            (identical(other.isDraft, isDraft) || other.isDraft == isDraft) &&
            (identical(other.isArchive, isArchive) ||
                other.isArchive == isArchive) &&
            (identical(other.musicGroupId, musicGroupId) ||
                other.musicGroupId == musicGroupId) &&
            (identical(other.video, video) || other.video == video));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, categoryId, date, note,
      audio, shortDesc, isDraft, isArchive, musicGroupId, video);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EventDTOCopyWith<_$_EventDTO> get copyWith =>
      __$$_EventDTOCopyWithImpl<_$_EventDTO>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EventDTOToJson(
      this,
    );
  }
}

abstract class _EventDTO extends EventDTO {
  const factory _EventDTO(
      @JsonKey(name: 'id') final int id,
      @JsonKey(name: 'category_id') final int categoryId,
      @JsonKey(name: 'date') final String date,
      @JsonKey(name: 'note') final String? note,
      @JsonKey(name: 'audio') final String? audio,
      @JsonKey(name: 'short_desc') final String? shortDesc,
      @JsonKey(name: 'is_draft') final int isDraft,
      @JsonKey(name: 'is_archive') final int isArchive,
      @JsonKey(name: 'music_group_id') final int? musicGroupId,
      @JsonKey(name: 'video') final String? video) = _$_EventDTO;
  const _EventDTO._() : super._();

  factory _EventDTO.fromJson(Map<String, dynamic> json) = _$_EventDTO.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'category_id')
  int get categoryId;
  @override
  @JsonKey(name: 'date')
  String get date;
  @override
  @JsonKey(name: 'note')
  String? get note;
  @override
  @JsonKey(name: 'audio')
  String? get audio;
  @override
  @JsonKey(name: 'short_desc')
  String? get shortDesc;
  @override
  @JsonKey(name: 'is_draft')
  int get isDraft;
  @override
  @JsonKey(name: 'is_archive')
  int get isArchive;
  @override
  @JsonKey(name: 'music_group_id')
  int? get musicGroupId;
  @override
  @JsonKey(name: 'video')
  String? get video;
  @override
  @JsonKey(ignore: true)
  _$$_EventDTOCopyWith<_$_EventDTO> get copyWith =>
      throw _privateConstructorUsedError;
}
