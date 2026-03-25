// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'idea_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$IdeaCategory {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  int get colorValue => throw _privateConstructorUsedError;
  int get iconCodePoint => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;

  /// Create a copy of IdeaCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IdeaCategoryCopyWith<IdeaCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IdeaCategoryCopyWith<$Res> {
  factory $IdeaCategoryCopyWith(
          IdeaCategory value, $Res Function(IdeaCategory) then) =
      _$IdeaCategoryCopyWithImpl<$Res, IdeaCategory>;
  @useResult
  $Res call(
      {int id,
      String name,
      String displayName,
      int colorValue,
      int iconCodePoint,
      int sortOrder,
      bool isDefault});
}

/// @nodoc
class _$IdeaCategoryCopyWithImpl<$Res, $Val extends IdeaCategory>
    implements $IdeaCategoryCopyWith<$Res> {
  _$IdeaCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IdeaCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? colorValue = null,
    Object? iconCodePoint = null,
    Object? sortOrder = null,
    Object? isDefault = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IdeaCategoryImplCopyWith<$Res>
    implements $IdeaCategoryCopyWith<$Res> {
  factory _$$IdeaCategoryImplCopyWith(
          _$IdeaCategoryImpl value, $Res Function(_$IdeaCategoryImpl) then) =
      __$$IdeaCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String displayName,
      int colorValue,
      int iconCodePoint,
      int sortOrder,
      bool isDefault});
}

/// @nodoc
class __$$IdeaCategoryImplCopyWithImpl<$Res>
    extends _$IdeaCategoryCopyWithImpl<$Res, _$IdeaCategoryImpl>
    implements _$$IdeaCategoryImplCopyWith<$Res> {
  __$$IdeaCategoryImplCopyWithImpl(
      _$IdeaCategoryImpl _value, $Res Function(_$IdeaCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of IdeaCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? colorValue = null,
    Object? iconCodePoint = null,
    Object? sortOrder = null,
    Object? isDefault = null,
  }) {
    return _then(_$IdeaCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$IdeaCategoryImpl extends _IdeaCategory {
  const _$IdeaCategoryImpl(
      {required this.id,
      required this.name,
      required this.displayName,
      required this.colorValue,
      required this.iconCodePoint,
      required this.sortOrder,
      this.isDefault = false})
      : super._();

  @override
  final int id;
  @override
  final String name;
  @override
  final String displayName;
  @override
  final int colorValue;
  @override
  final int iconCodePoint;
  @override
  final int sortOrder;
  @override
  @JsonKey()
  final bool isDefault;

  @override
  String toString() {
    return 'IdeaCategory(id: $id, name: $name, displayName: $displayName, colorValue: $colorValue, iconCodePoint: $iconCodePoint, sortOrder: $sortOrder, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdeaCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            (identical(other.iconCodePoint, iconCodePoint) ||
                other.iconCodePoint == iconCodePoint) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, displayName,
      colorValue, iconCodePoint, sortOrder, isDefault);

  /// Create a copy of IdeaCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IdeaCategoryImplCopyWith<_$IdeaCategoryImpl> get copyWith =>
      __$$IdeaCategoryImplCopyWithImpl<_$IdeaCategoryImpl>(this, _$identity);
}

abstract class _IdeaCategory extends IdeaCategory {
  const factory _IdeaCategory(
      {required final int id,
      required final String name,
      required final String displayName,
      required final int colorValue,
      required final int iconCodePoint,
      required final int sortOrder,
      final bool isDefault}) = _$IdeaCategoryImpl;
  const _IdeaCategory._() : super._();

  @override
  int get id;
  @override
  String get name;
  @override
  String get displayName;
  @override
  int get colorValue;
  @override
  int get iconCodePoint;
  @override
  int get sortOrder;
  @override
  bool get isDefault;

  /// Create a copy of IdeaCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IdeaCategoryImplCopyWith<_$IdeaCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
