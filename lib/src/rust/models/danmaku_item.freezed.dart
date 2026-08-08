// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'danmaku_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DanmakuItem {

 int get id; int get userId; String get content; String get color; String get vTime;
/// Create a copy of DanmakuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DanmakuItemCopyWith<DanmakuItem> get copyWith => _$DanmakuItemCopyWithImpl<DanmakuItem>(this as DanmakuItem, _$identity);

  /// Serializes this DanmakuItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DanmakuItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.content, content) || other.content == content)&&(identical(other.color, color) || other.color == color)&&(identical(other.vTime, vTime) || other.vTime == vTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,content,color,vTime);

@override
String toString() {
  return 'DanmakuItem(id: $id, userId: $userId, content: $content, color: $color, vTime: $vTime)';
}


}

/// @nodoc
abstract mixin class $DanmakuItemCopyWith<$Res>  {
  factory $DanmakuItemCopyWith(DanmakuItem value, $Res Function(DanmakuItem) _then) = _$DanmakuItemCopyWithImpl;
@useResult
$Res call({
 int id, int userId, String content, String color, String vTime
});




}
/// @nodoc
class _$DanmakuItemCopyWithImpl<$Res>
    implements $DanmakuItemCopyWith<$Res> {
  _$DanmakuItemCopyWithImpl(this._self, this._then);

  final DanmakuItem _self;
  final $Res Function(DanmakuItem) _then;

/// Create a copy of DanmakuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? content = null,Object? color = null,Object? vTime = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,vTime: null == vTime ? _self.vTime : vTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DanmakuItem].
extension DanmakuItemPatterns on DanmakuItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DanmakuItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DanmakuItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DanmakuItem value)  $default,){
final _that = this;
switch (_that) {
case _DanmakuItem():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DanmakuItem value)?  $default,){
final _that = this;
switch (_that) {
case _DanmakuItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int userId,  String content,  String color,  String vTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DanmakuItem() when $default != null:
return $default(_that.id,_that.userId,_that.content,_that.color,_that.vTime);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int userId,  String content,  String color,  String vTime)  $default,) {final _that = this;
switch (_that) {
case _DanmakuItem():
return $default(_that.id,_that.userId,_that.content,_that.color,_that.vTime);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int userId,  String content,  String color,  String vTime)?  $default,) {final _that = this;
switch (_that) {
case _DanmakuItem() when $default != null:
return $default(_that.id,_that.userId,_that.content,_that.color,_that.vTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DanmakuItem implements DanmakuItem {
  const _DanmakuItem({required this.id, required this.userId, required this.content, required this.color, required this.vTime});
  factory _DanmakuItem.fromJson(Map<String, dynamic> json) => _$DanmakuItemFromJson(json);

@override final  int id;
@override final  int userId;
@override final  String content;
@override final  String color;
@override final  String vTime;

/// Create a copy of DanmakuItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DanmakuItemCopyWith<_DanmakuItem> get copyWith => __$DanmakuItemCopyWithImpl<_DanmakuItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DanmakuItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DanmakuItem&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.content, content) || other.content == content)&&(identical(other.color, color) || other.color == color)&&(identical(other.vTime, vTime) || other.vTime == vTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,content,color,vTime);

@override
String toString() {
  return 'DanmakuItem(id: $id, userId: $userId, content: $content, color: $color, vTime: $vTime)';
}


}

/// @nodoc
abstract mixin class _$DanmakuItemCopyWith<$Res> implements $DanmakuItemCopyWith<$Res> {
  factory _$DanmakuItemCopyWith(_DanmakuItem value, $Res Function(_DanmakuItem) _then) = __$DanmakuItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int userId, String content, String color, String vTime
});




}
/// @nodoc
class __$DanmakuItemCopyWithImpl<$Res>
    implements _$DanmakuItemCopyWith<$Res> {
  __$DanmakuItemCopyWithImpl(this._self, this._then);

  final _DanmakuItem _self;
  final $Res Function(_DanmakuItem) _then;

/// Create a copy of DanmakuItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? content = null,Object? color = null,Object? vTime = null,}) {
  return _then(_DanmakuItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,vTime: null == vTime ? _self.vTime : vTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
