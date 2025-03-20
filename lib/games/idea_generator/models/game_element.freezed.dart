// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameElement {
  String get id => throw _privateConstructorUsedError;
  ElementType get type => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;

  /// Create a copy of GameElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameElementCopyWith<GameElement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameElementCopyWith<$Res> {
  factory $GameElementCopyWith(
          GameElement value, $Res Function(GameElement) then) =
      _$GameElementCopyWithImpl<$Res, GameElement>;
  @useResult
  $Res call({String id, ElementType type, String? value});
}

/// @nodoc
class _$GameElementCopyWithImpl<$Res, $Val extends GameElement>
    implements $GameElementCopyWith<$Res> {
  _$GameElementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ElementType,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameElementImplCopyWith<$Res>
    implements $GameElementCopyWith<$Res> {
  factory _$$GameElementImplCopyWith(
          _$GameElementImpl value, $Res Function(_$GameElementImpl) then) =
      __$$GameElementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, ElementType type, String? value});
}

/// @nodoc
class __$$GameElementImplCopyWithImpl<$Res>
    extends _$GameElementCopyWithImpl<$Res, _$GameElementImpl>
    implements _$$GameElementImplCopyWith<$Res> {
  __$$GameElementImplCopyWithImpl(
      _$GameElementImpl _value, $Res Function(_$GameElementImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? value = freezed,
  }) {
    return _then(_$GameElementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ElementType,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$GameElementImpl implements _GameElement {
  const _$GameElementImpl({required this.id, required this.type, this.value});

  @override
  final String id;
  @override
  final ElementType type;
  @override
  final String? value;

  @override
  String toString() {
    return 'GameElement(id: $id, type: $type, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameElementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, type, value);

  /// Create a copy of GameElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameElementImplCopyWith<_$GameElementImpl> get copyWith =>
      __$$GameElementImplCopyWithImpl<_$GameElementImpl>(this, _$identity);
}

abstract class _GameElement implements GameElement {
  const factory _GameElement(
      {required final String id,
      required final ElementType type,
      final String? value}) = _$GameElementImpl;

  @override
  String get id;
  @override
  ElementType get type;
  @override
  String? get value;

  /// Create a copy of GameElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameElementImplCopyWith<_$GameElementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
