// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoListRequest {

 BigInt get pg; BigInt get tid; String get class_; String get area; String get lang; String get year; String get order; String get token;
/// Create a copy of VideoListRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoListRequestCopyWith<VideoListRequest> get copyWith => _$VideoListRequestCopyWithImpl<VideoListRequest>(this as VideoListRequest, _$identity);

  /// Serializes this VideoListRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoListRequest&&(identical(other.pg, pg) || other.pg == pg)&&(identical(other.tid, tid) || other.tid == tid)&&(identical(other.class_, class_) || other.class_ == class_)&&(identical(other.area, area) || other.area == area)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.year, year) || other.year == year)&&(identical(other.order, order) || other.order == order)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pg,tid,class_,area,lang,year,order,token);

@override
String toString() {
  return 'VideoListRequest(pg: $pg, tid: $tid, class_: $class_, area: $area, lang: $lang, year: $year, order: $order, token: $token)';
}


}

/// @nodoc
abstract mixin class $VideoListRequestCopyWith<$Res>  {
  factory $VideoListRequestCopyWith(VideoListRequest value, $Res Function(VideoListRequest) _then) = _$VideoListRequestCopyWithImpl;
@useResult
$Res call({
 BigInt pg, BigInt tid, String class_, String area, String lang, String year, String order, String token
});




}
/// @nodoc
class _$VideoListRequestCopyWithImpl<$Res>
    implements $VideoListRequestCopyWith<$Res> {
  _$VideoListRequestCopyWithImpl(this._self, this._then);

  final VideoListRequest _self;
  final $Res Function(VideoListRequest) _then;

/// Create a copy of VideoListRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pg = null,Object? tid = null,Object? class_ = null,Object? area = null,Object? lang = null,Object? year = null,Object? order = null,Object? token = null,}) {
  return _then(_self.copyWith(
pg: null == pg ? _self.pg : pg // ignore: cast_nullable_to_non_nullable
as BigInt,tid: null == tid ? _self.tid : tid // ignore: cast_nullable_to_non_nullable
as BigInt,class_: null == class_ ? _self.class_ : class_ // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoListRequest].
extension VideoListRequestPatterns on VideoListRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoListRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoListRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoListRequest value)  $default,){
final _that = this;
switch (_that) {
case _VideoListRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoListRequest value)?  $default,){
final _that = this;
switch (_that) {
case _VideoListRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BigInt pg,  BigInt tid,  String class_,  String area,  String lang,  String year,  String order,  String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoListRequest() when $default != null:
return $default(_that.pg,_that.tid,_that.class_,_that.area,_that.lang,_that.year,_that.order,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BigInt pg,  BigInt tid,  String class_,  String area,  String lang,  String year,  String order,  String token)  $default,) {final _that = this;
switch (_that) {
case _VideoListRequest():
return $default(_that.pg,_that.tid,_that.class_,_that.area,_that.lang,_that.year,_that.order,_that.token);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BigInt pg,  BigInt tid,  String class_,  String area,  String lang,  String year,  String order,  String token)?  $default,) {final _that = this;
switch (_that) {
case _VideoListRequest() when $default != null:
return $default(_that.pg,_that.tid,_that.class_,_that.area,_that.lang,_that.year,_that.order,_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoListRequest implements VideoListRequest {
  const _VideoListRequest({required this.pg, required this.tid, required this.class_, required this.area, required this.lang, required this.year, required this.order, required this.token});
  factory _VideoListRequest.fromJson(Map<String, dynamic> json) => _$VideoListRequestFromJson(json);

@override final  BigInt pg;
@override final  BigInt tid;
@override final  String class_;
@override final  String area;
@override final  String lang;
@override final  String year;
@override final  String order;
@override final  String token;

/// Create a copy of VideoListRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoListRequestCopyWith<_VideoListRequest> get copyWith => __$VideoListRequestCopyWithImpl<_VideoListRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoListRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoListRequest&&(identical(other.pg, pg) || other.pg == pg)&&(identical(other.tid, tid) || other.tid == tid)&&(identical(other.class_, class_) || other.class_ == class_)&&(identical(other.area, area) || other.area == area)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.year, year) || other.year == year)&&(identical(other.order, order) || other.order == order)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pg,tid,class_,area,lang,year,order,token);

@override
String toString() {
  return 'VideoListRequest(pg: $pg, tid: $tid, class_: $class_, area: $area, lang: $lang, year: $year, order: $order, token: $token)';
}


}

/// @nodoc
abstract mixin class _$VideoListRequestCopyWith<$Res> implements $VideoListRequestCopyWith<$Res> {
  factory _$VideoListRequestCopyWith(_VideoListRequest value, $Res Function(_VideoListRequest) _then) = __$VideoListRequestCopyWithImpl;
@override @useResult
$Res call({
 BigInt pg, BigInt tid, String class_, String area, String lang, String year, String order, String token
});




}
/// @nodoc
class __$VideoListRequestCopyWithImpl<$Res>
    implements _$VideoListRequestCopyWith<$Res> {
  __$VideoListRequestCopyWithImpl(this._self, this._then);

  final _VideoListRequest _self;
  final $Res Function(_VideoListRequest) _then;

/// Create a copy of VideoListRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pg = null,Object? tid = null,Object? class_ = null,Object? area = null,Object? lang = null,Object? year = null,Object? order = null,Object? token = null,}) {
  return _then(_VideoListRequest(
pg: null == pg ? _self.pg : pg // ignore: cast_nullable_to_non_nullable
as BigInt,tid: null == tid ? _self.tid : tid // ignore: cast_nullable_to_non_nullable
as BigInt,class_: null == class_ ? _self.class_ : class_ // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$VodListItem {

 int get typeId; PlatformInt64 get vodId; String get vodName; String get vodPic; String get vodRemarks;
/// Create a copy of VodListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VodListItemCopyWith<VodListItem> get copyWith => _$VodListItemCopyWithImpl<VodListItem>(this as VodListItem, _$identity);

  /// Serializes this VodListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VodListItem&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.vodId, vodId) || other.vodId == vodId)&&(identical(other.vodName, vodName) || other.vodName == vodName)&&(identical(other.vodPic, vodPic) || other.vodPic == vodPic)&&(identical(other.vodRemarks, vodRemarks) || other.vodRemarks == vodRemarks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typeId,vodId,vodName,vodPic,vodRemarks);

@override
String toString() {
  return 'VodListItem(typeId: $typeId, vodId: $vodId, vodName: $vodName, vodPic: $vodPic, vodRemarks: $vodRemarks)';
}


}

/// @nodoc
abstract mixin class $VodListItemCopyWith<$Res>  {
  factory $VodListItemCopyWith(VodListItem value, $Res Function(VodListItem) _then) = _$VodListItemCopyWithImpl;
@useResult
$Res call({
 int typeId, PlatformInt64 vodId, String vodName, String vodPic, String vodRemarks
});




}
/// @nodoc
class _$VodListItemCopyWithImpl<$Res>
    implements $VodListItemCopyWith<$Res> {
  _$VodListItemCopyWithImpl(this._self, this._then);

  final VodListItem _self;
  final $Res Function(VodListItem) _then;

/// Create a copy of VodListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? typeId = null,Object? vodId = null,Object? vodName = null,Object? vodPic = null,Object? vodRemarks = null,}) {
  return _then(_self.copyWith(
typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,vodId: null == vodId ? _self.vodId : vodId // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodName: null == vodName ? _self.vodName : vodName // ignore: cast_nullable_to_non_nullable
as String,vodPic: null == vodPic ? _self.vodPic : vodPic // ignore: cast_nullable_to_non_nullable
as String,vodRemarks: null == vodRemarks ? _self.vodRemarks : vodRemarks // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VodListItem].
extension VodListItemPatterns on VodListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VodListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VodListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VodListItem value)  $default,){
final _that = this;
switch (_that) {
case _VodListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VodListItem value)?  $default,){
final _that = this;
switch (_that) {
case _VodListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int typeId,  PlatformInt64 vodId,  String vodName,  String vodPic,  String vodRemarks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VodListItem() when $default != null:
return $default(_that.typeId,_that.vodId,_that.vodName,_that.vodPic,_that.vodRemarks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int typeId,  PlatformInt64 vodId,  String vodName,  String vodPic,  String vodRemarks)  $default,) {final _that = this;
switch (_that) {
case _VodListItem():
return $default(_that.typeId,_that.vodId,_that.vodName,_that.vodPic,_that.vodRemarks);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int typeId,  PlatformInt64 vodId,  String vodName,  String vodPic,  String vodRemarks)?  $default,) {final _that = this;
switch (_that) {
case _VodListItem() when $default != null:
return $default(_that.typeId,_that.vodId,_that.vodName,_that.vodPic,_that.vodRemarks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VodListItem implements VodListItem {
  const _VodListItem({required this.typeId, required this.vodId, required this.vodName, required this.vodPic, required this.vodRemarks});
  factory _VodListItem.fromJson(Map<String, dynamic> json) => _$VodListItemFromJson(json);

@override final  int typeId;
@override final  PlatformInt64 vodId;
@override final  String vodName;
@override final  String vodPic;
@override final  String vodRemarks;

/// Create a copy of VodListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VodListItemCopyWith<_VodListItem> get copyWith => __$VodListItemCopyWithImpl<_VodListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VodListItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VodListItem&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.vodId, vodId) || other.vodId == vodId)&&(identical(other.vodName, vodName) || other.vodName == vodName)&&(identical(other.vodPic, vodPic) || other.vodPic == vodPic)&&(identical(other.vodRemarks, vodRemarks) || other.vodRemarks == vodRemarks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typeId,vodId,vodName,vodPic,vodRemarks);

@override
String toString() {
  return 'VodListItem(typeId: $typeId, vodId: $vodId, vodName: $vodName, vodPic: $vodPic, vodRemarks: $vodRemarks)';
}


}

/// @nodoc
abstract mixin class _$VodListItemCopyWith<$Res> implements $VodListItemCopyWith<$Res> {
  factory _$VodListItemCopyWith(_VodListItem value, $Res Function(_VodListItem) _then) = __$VodListItemCopyWithImpl;
@override @useResult
$Res call({
 int typeId, PlatformInt64 vodId, String vodName, String vodPic, String vodRemarks
});




}
/// @nodoc
class __$VodListItemCopyWithImpl<$Res>
    implements _$VodListItemCopyWith<$Res> {
  __$VodListItemCopyWithImpl(this._self, this._then);

  final _VodListItem _self;
  final $Res Function(_VodListItem) _then;

/// Create a copy of VodListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? typeId = null,Object? vodId = null,Object? vodName = null,Object? vodPic = null,Object? vodRemarks = null,}) {
  return _then(_VodListItem(
typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,vodId: null == vodId ? _self.vodId : vodId // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodName: null == vodName ? _self.vodName : vodName // ignore: cast_nullable_to_non_nullable
as String,vodPic: null == vodPic ? _self.vodPic : vodPic // ignore: cast_nullable_to_non_nullable
as String,vodRemarks: null == vodRemarks ? _self.vodRemarks : vodRemarks // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
