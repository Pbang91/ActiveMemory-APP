// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'body_part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BodyPart _$BodyPartFromJson(Map<String, dynamic> json) {
  return _BodyPart.fromJson(json);
}

/// @nodoc
mixin _$BodyPart {
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this BodyPart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BodyPart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BodyPartCopyWith<BodyPart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BodyPartCopyWith<$Res> {
  factory $BodyPartCopyWith(BodyPart value, $Res Function(BodyPart) then) =
      _$BodyPartCopyWithImpl<$Res, BodyPart>;
  @useResult
  $Res call({String code, String name});
}

/// @nodoc
class _$BodyPartCopyWithImpl<$Res, $Val extends BodyPart>
    implements $BodyPartCopyWith<$Res> {
  _$BodyPartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BodyPart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BodyPartImplCopyWith<$Res>
    implements $BodyPartCopyWith<$Res> {
  factory _$$BodyPartImplCopyWith(
          _$BodyPartImpl value, $Res Function(_$BodyPartImpl) then) =
      __$$BodyPartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String name});
}

/// @nodoc
class __$$BodyPartImplCopyWithImpl<$Res>
    extends _$BodyPartCopyWithImpl<$Res, _$BodyPartImpl>
    implements _$$BodyPartImplCopyWith<$Res> {
  __$$BodyPartImplCopyWithImpl(
      _$BodyPartImpl _value, $Res Function(_$BodyPartImpl) _then)
      : super(_value, _then);

  /// Create a copy of BodyPart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
  }) {
    return _then(_$BodyPartImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BodyPartImpl implements _BodyPart {
  _$BodyPartImpl({required this.code, required this.name});

  factory _$BodyPartImpl.fromJson(Map<String, dynamic> json) =>
      _$$BodyPartImplFromJson(json);

  @override
  final String code;
  @override
  final String name;

  @override
  String toString() {
    return 'BodyPart(code: $code, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BodyPartImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, name);

  /// Create a copy of BodyPart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BodyPartImplCopyWith<_$BodyPartImpl> get copyWith =>
      __$$BodyPartImplCopyWithImpl<_$BodyPartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BodyPartImplToJson(
      this,
    );
  }
}

abstract class _BodyPart implements BodyPart {
  factory _BodyPart({required final String code, required final String name}) =
      _$BodyPartImpl;

  factory _BodyPart.fromJson(Map<String, dynamic> json) =
      _$BodyPartImpl.fromJson;

  @override
  String get code;
  @override
  String get name;

  /// Create a copy of BodyPart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BodyPartImplCopyWith<_$BodyPartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
