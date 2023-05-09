// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../../../../src/ui/home/home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeState {
  User? get currentFirebaseUser => throw _privateConstructorUsedError;
  bool get isResetPasswordCompleted => throw _privateConstructorUsedError;
  TableData? get tableData => throw _privateConstructorUsedError;
  bool get isAdmin => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeStateCopyWith<HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
  @useResult
  $Res call(
      {User? currentFirebaseUser,
      bool isResetPasswordCompleted,
      TableData? tableData,
      bool isAdmin});
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentFirebaseUser = freezed,
    Object? isResetPasswordCompleted = null,
    Object? tableData = freezed,
    Object? isAdmin = null,
  }) {
    return _then(_value.copyWith(
      currentFirebaseUser: freezed == currentFirebaseUser
          ? _value.currentFirebaseUser
          : currentFirebaseUser // ignore: cast_nullable_to_non_nullable
              as User?,
      isResetPasswordCompleted: null == isResetPasswordCompleted
          ? _value.isResetPasswordCompleted
          : isResetPasswordCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      tableData: freezed == tableData
          ? _value.tableData
          : tableData // ignore: cast_nullable_to_non_nullable
              as TableData?,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$$_HomeStateCopyWith(
          _$_HomeState value, $Res Function(_$_HomeState) then) =
      __$$_HomeStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {User? currentFirebaseUser,
      bool isResetPasswordCompleted,
      TableData? tableData,
      bool isAdmin});
}

/// @nodoc
class __$$_HomeStateCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$_HomeState>
    implements _$$_HomeStateCopyWith<$Res> {
  __$$_HomeStateCopyWithImpl(
      _$_HomeState _value, $Res Function(_$_HomeState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentFirebaseUser = freezed,
    Object? isResetPasswordCompleted = null,
    Object? tableData = freezed,
    Object? isAdmin = null,
  }) {
    return _then(_$_HomeState(
      currentFirebaseUser: freezed == currentFirebaseUser
          ? _value.currentFirebaseUser
          : currentFirebaseUser // ignore: cast_nullable_to_non_nullable
              as User?,
      isResetPasswordCompleted: null == isResetPasswordCompleted
          ? _value.isResetPasswordCompleted
          : isResetPasswordCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      tableData: freezed == tableData
          ? _value.tableData
          : tableData // ignore: cast_nullable_to_non_nullable
              as TableData?,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_HomeState extends _HomeState {
  const _$_HomeState(
      {this.currentFirebaseUser = null,
      this.isResetPasswordCompleted = false,
      this.tableData = null,
      this.isAdmin = false})
      : super._();

  @override
  @JsonKey()
  final User? currentFirebaseUser;
  @override
  @JsonKey()
  final bool isResetPasswordCompleted;
  @override
  @JsonKey()
  final TableData? tableData;
  @override
  @JsonKey()
  final bool isAdmin;

  @override
  String toString() {
    return 'HomeState(currentFirebaseUser: $currentFirebaseUser, isResetPasswordCompleted: $isResetPasswordCompleted, tableData: $tableData, isAdmin: $isAdmin)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HomeState &&
            (identical(other.currentFirebaseUser, currentFirebaseUser) ||
                other.currentFirebaseUser == currentFirebaseUser) &&
            (identical(
                    other.isResetPasswordCompleted, isResetPasswordCompleted) ||
                other.isResetPasswordCompleted == isResetPasswordCompleted) &&
            (identical(other.tableData, tableData) ||
                other.tableData == tableData) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentFirebaseUser,
      isResetPasswordCompleted, tableData, isAdmin);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HomeStateCopyWith<_$_HomeState> get copyWith =>
      __$$_HomeStateCopyWithImpl<_$_HomeState>(this, _$identity);
}

abstract class _HomeState extends HomeState {
  const factory _HomeState(
      {final User? currentFirebaseUser,
      final bool isResetPasswordCompleted,
      final TableData? tableData,
      final bool isAdmin}) = _$_HomeState;
  const _HomeState._() : super._();

  @override
  User? get currentFirebaseUser;
  @override
  bool get isResetPasswordCompleted;
  @override
  TableData? get tableData;
  @override
  bool get isAdmin;
  @override
  @JsonKey(ignore: true)
  _$$_HomeStateCopyWith<_$_HomeState> get copyWith =>
      throw _privateConstructorUsedError;
}
