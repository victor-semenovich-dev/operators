// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../../../src/ui/authorization/authorization_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthorizationState {
  String? get error => throw _privateConstructorUsedError;
  bool get isLoggedIn => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthorizationStateCopyWith<AuthorizationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthorizationStateCopyWith<$Res> {
  factory $AuthorizationStateCopyWith(
          AuthorizationState value, $Res Function(AuthorizationState) then) =
      _$AuthorizationStateCopyWithImpl<$Res, AuthorizationState>;
  @useResult
  $Res call({String? error, bool isLoggedIn});
}

/// @nodoc
class _$AuthorizationStateCopyWithImpl<$Res, $Val extends AuthorizationState>
    implements $AuthorizationStateCopyWith<$Res> {
  _$AuthorizationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? isLoggedIn = null,
  }) {
    return _then(_value.copyWith(
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoggedIn: null == isLoggedIn
          ? _value.isLoggedIn
          : isLoggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AuthorizationStateCopyWith<$Res>
    implements $AuthorizationStateCopyWith<$Res> {
  factory _$$_AuthorizationStateCopyWith(_$_AuthorizationState value,
          $Res Function(_$_AuthorizationState) then) =
      __$$_AuthorizationStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? error, bool isLoggedIn});
}

/// @nodoc
class __$$_AuthorizationStateCopyWithImpl<$Res>
    extends _$AuthorizationStateCopyWithImpl<$Res, _$_AuthorizationState>
    implements _$$_AuthorizationStateCopyWith<$Res> {
  __$$_AuthorizationStateCopyWithImpl(
      _$_AuthorizationState _value, $Res Function(_$_AuthorizationState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = freezed,
    Object? isLoggedIn = null,
  }) {
    return _then(_$_AuthorizationState(
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoggedIn: null == isLoggedIn
          ? _value.isLoggedIn
          : isLoggedIn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_AuthorizationState implements _AuthorizationState {
  const _$_AuthorizationState({this.error = null, this.isLoggedIn = false});

  @override
  @JsonKey()
  final String? error;
  @override
  @JsonKey()
  final bool isLoggedIn;

  @override
  String toString() {
    return 'AuthorizationState(error: $error, isLoggedIn: $isLoggedIn)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AuthorizationState &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoggedIn, isLoggedIn) ||
                other.isLoggedIn == isLoggedIn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error, isLoggedIn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AuthorizationStateCopyWith<_$_AuthorizationState> get copyWith =>
      __$$_AuthorizationStateCopyWithImpl<_$_AuthorizationState>(
          this, _$identity);
}

abstract class _AuthorizationState implements AuthorizationState {
  const factory _AuthorizationState(
      {final String? error, final bool isLoggedIn}) = _$_AuthorizationState;

  @override
  String? get error;
  @override
  bool get isLoggedIn;
  @override
  @JsonKey(ignore: true)
  _$$_AuthorizationStateCopyWith<_$_AuthorizationState> get copyWith =>
      throw _privateConstructorUsedError;
}
