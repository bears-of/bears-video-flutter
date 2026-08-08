// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchRequest {

 BigInt get pg; BigInt? get tid; String get text; String get token;
/// Create a copy of SearchRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchRequestCopyWith<SearchRequest> get copyWith => _$SearchRequestCopyWithImpl<SearchRequest>(this as SearchRequest, _$identity);

  /// Serializes this SearchRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchRequest&&(identical(other.pg, pg) || other.pg == pg)&&(identical(other.tid, tid) || other.tid == tid)&&(identical(other.text, text) || other.text == text)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pg,tid,text,token);

@override
String toString() {
  return 'SearchRequest(pg: $pg, tid: $tid, text: $text, token: $token)';
}


}

/// @nodoc
abstract mixin class $SearchRequestCopyWith<$Res>  {
  factory $SearchRequestCopyWith(SearchRequest value, $Res Function(SearchRequest) _then) = _$SearchRequestCopyWithImpl;
@useResult
$Res call({
 BigInt pg, BigInt? tid, String text, String token
});




}
/// @nodoc
class _$SearchRequestCopyWithImpl<$Res>
    implements $SearchRequestCopyWith<$Res> {
  _$SearchRequestCopyWithImpl(this._self, this._then);

  final SearchRequest _self;
  final $Res Function(SearchRequest) _then;

/// Create a copy of SearchRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pg = null,Object? tid = freezed,Object? text = null,Object? token = null,}) {
  return _then(_self.copyWith(
pg: null == pg ? _self.pg : pg // ignore: cast_nullable_to_non_nullable
as BigInt,tid: freezed == tid ? _self.tid : tid // ignore: cast_nullable_to_non_nullable
as BigInt?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchRequest].
extension SearchRequestPatterns on SearchRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchRequest value)  $default,){
final _that = this;
switch (_that) {
case _SearchRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SearchRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BigInt pg,  BigInt? tid,  String text,  String token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchRequest() when $default != null:
return $default(_that.pg,_that.tid,_that.text,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BigInt pg,  BigInt? tid,  String text,  String token)  $default,) {final _that = this;
switch (_that) {
case _SearchRequest():
return $default(_that.pg,_that.tid,_that.text,_that.token);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BigInt pg,  BigInt? tid,  String text,  String token)?  $default,) {final _that = this;
switch (_that) {
case _SearchRequest() when $default != null:
return $default(_that.pg,_that.tid,_that.text,_that.token);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchRequest implements SearchRequest {
  const _SearchRequest({required this.pg, this.tid, required this.text, required this.token});
  factory _SearchRequest.fromJson(Map<String, dynamic> json) => _$SearchRequestFromJson(json);

@override final  BigInt pg;
@override final  BigInt? tid;
@override final  String text;
@override final  String token;

/// Create a copy of SearchRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchRequestCopyWith<_SearchRequest> get copyWith => __$SearchRequestCopyWithImpl<_SearchRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchRequest&&(identical(other.pg, pg) || other.pg == pg)&&(identical(other.tid, tid) || other.tid == tid)&&(identical(other.text, text) || other.text == text)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pg,tid,text,token);

@override
String toString() {
  return 'SearchRequest(pg: $pg, tid: $tid, text: $text, token: $token)';
}


}

/// @nodoc
abstract mixin class _$SearchRequestCopyWith<$Res> implements $SearchRequestCopyWith<$Res> {
  factory _$SearchRequestCopyWith(_SearchRequest value, $Res Function(_SearchRequest) _then) = __$SearchRequestCopyWithImpl;
@override @useResult
$Res call({
 BigInt pg, BigInt? tid, String text, String token
});




}
/// @nodoc
class __$SearchRequestCopyWithImpl<$Res>
    implements _$SearchRequestCopyWith<$Res> {
  __$SearchRequestCopyWithImpl(this._self, this._then);

  final _SearchRequest _self;
  final $Res Function(_SearchRequest) _then;

/// Create a copy of SearchRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pg = null,Object? tid = freezed,Object? text = null,Object? token = null,}) {
  return _then(_SearchRequest(
pg: null == pg ? _self.pg : pg // ignore: cast_nullable_to_non_nullable
as BigInt,tid: freezed == tid ? _self.tid : tid // ignore: cast_nullable_to_non_nullable
as BigInt?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SearchVodItem {

 int get typeId; PlatformInt64 get vodId; String get vodName; String get vodActor; String get vodArea; String get vodLang; String get vodPic; String get vodRemarks; String get vodYear;
/// Create a copy of SearchVodItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchVodItemCopyWith<SearchVodItem> get copyWith => _$SearchVodItemCopyWithImpl<SearchVodItem>(this as SearchVodItem, _$identity);

  /// Serializes this SearchVodItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchVodItem&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.vodId, vodId) || other.vodId == vodId)&&(identical(other.vodName, vodName) || other.vodName == vodName)&&(identical(other.vodActor, vodActor) || other.vodActor == vodActor)&&(identical(other.vodArea, vodArea) || other.vodArea == vodArea)&&(identical(other.vodLang, vodLang) || other.vodLang == vodLang)&&(identical(other.vodPic, vodPic) || other.vodPic == vodPic)&&(identical(other.vodRemarks, vodRemarks) || other.vodRemarks == vodRemarks)&&(identical(other.vodYear, vodYear) || other.vodYear == vodYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typeId,vodId,vodName,vodActor,vodArea,vodLang,vodPic,vodRemarks,vodYear);

@override
String toString() {
  return 'SearchVodItem(typeId: $typeId, vodId: $vodId, vodName: $vodName, vodActor: $vodActor, vodArea: $vodArea, vodLang: $vodLang, vodPic: $vodPic, vodRemarks: $vodRemarks, vodYear: $vodYear)';
}


}

/// @nodoc
abstract mixin class $SearchVodItemCopyWith<$Res>  {
  factory $SearchVodItemCopyWith(SearchVodItem value, $Res Function(SearchVodItem) _then) = _$SearchVodItemCopyWithImpl;
@useResult
$Res call({
 int typeId, PlatformInt64 vodId, String vodName, String vodActor, String vodArea, String vodLang, String vodPic, String vodRemarks, String vodYear
});




}
/// @nodoc
class _$SearchVodItemCopyWithImpl<$Res>
    implements $SearchVodItemCopyWith<$Res> {
  _$SearchVodItemCopyWithImpl(this._self, this._then);

  final SearchVodItem _self;
  final $Res Function(SearchVodItem) _then;

/// Create a copy of SearchVodItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? typeId = null,Object? vodId = null,Object? vodName = null,Object? vodActor = null,Object? vodArea = null,Object? vodLang = null,Object? vodPic = null,Object? vodRemarks = null,Object? vodYear = null,}) {
  return _then(_self.copyWith(
typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,vodId: null == vodId ? _self.vodId : vodId // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodName: null == vodName ? _self.vodName : vodName // ignore: cast_nullable_to_non_nullable
as String,vodActor: null == vodActor ? _self.vodActor : vodActor // ignore: cast_nullable_to_non_nullable
as String,vodArea: null == vodArea ? _self.vodArea : vodArea // ignore: cast_nullable_to_non_nullable
as String,vodLang: null == vodLang ? _self.vodLang : vodLang // ignore: cast_nullable_to_non_nullable
as String,vodPic: null == vodPic ? _self.vodPic : vodPic // ignore: cast_nullable_to_non_nullable
as String,vodRemarks: null == vodRemarks ? _self.vodRemarks : vodRemarks // ignore: cast_nullable_to_non_nullable
as String,vodYear: null == vodYear ? _self.vodYear : vodYear // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchVodItem].
extension SearchVodItemPatterns on SearchVodItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchVodItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchVodItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchVodItem value)  $default,){
final _that = this;
switch (_that) {
case _SearchVodItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchVodItem value)?  $default,){
final _that = this;
switch (_that) {
case _SearchVodItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int typeId,  PlatformInt64 vodId,  String vodName,  String vodActor,  String vodArea,  String vodLang,  String vodPic,  String vodRemarks,  String vodYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchVodItem() when $default != null:
return $default(_that.typeId,_that.vodId,_that.vodName,_that.vodActor,_that.vodArea,_that.vodLang,_that.vodPic,_that.vodRemarks,_that.vodYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int typeId,  PlatformInt64 vodId,  String vodName,  String vodActor,  String vodArea,  String vodLang,  String vodPic,  String vodRemarks,  String vodYear)  $default,) {final _that = this;
switch (_that) {
case _SearchVodItem():
return $default(_that.typeId,_that.vodId,_that.vodName,_that.vodActor,_that.vodArea,_that.vodLang,_that.vodPic,_that.vodRemarks,_that.vodYear);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int typeId,  PlatformInt64 vodId,  String vodName,  String vodActor,  String vodArea,  String vodLang,  String vodPic,  String vodRemarks,  String vodYear)?  $default,) {final _that = this;
switch (_that) {
case _SearchVodItem() when $default != null:
return $default(_that.typeId,_that.vodId,_that.vodName,_that.vodActor,_that.vodArea,_that.vodLang,_that.vodPic,_that.vodRemarks,_that.vodYear);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchVodItem implements SearchVodItem {
  const _SearchVodItem({required this.typeId, required this.vodId, required this.vodName, required this.vodActor, required this.vodArea, required this.vodLang, required this.vodPic, required this.vodRemarks, required this.vodYear});
  factory _SearchVodItem.fromJson(Map<String, dynamic> json) => _$SearchVodItemFromJson(json);

@override final  int typeId;
@override final  PlatformInt64 vodId;
@override final  String vodName;
@override final  String vodActor;
@override final  String vodArea;
@override final  String vodLang;
@override final  String vodPic;
@override final  String vodRemarks;
@override final  String vodYear;

/// Create a copy of SearchVodItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchVodItemCopyWith<_SearchVodItem> get copyWith => __$SearchVodItemCopyWithImpl<_SearchVodItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchVodItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchVodItem&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.vodId, vodId) || other.vodId == vodId)&&(identical(other.vodName, vodName) || other.vodName == vodName)&&(identical(other.vodActor, vodActor) || other.vodActor == vodActor)&&(identical(other.vodArea, vodArea) || other.vodArea == vodArea)&&(identical(other.vodLang, vodLang) || other.vodLang == vodLang)&&(identical(other.vodPic, vodPic) || other.vodPic == vodPic)&&(identical(other.vodRemarks, vodRemarks) || other.vodRemarks == vodRemarks)&&(identical(other.vodYear, vodYear) || other.vodYear == vodYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typeId,vodId,vodName,vodActor,vodArea,vodLang,vodPic,vodRemarks,vodYear);

@override
String toString() {
  return 'SearchVodItem(typeId: $typeId, vodId: $vodId, vodName: $vodName, vodActor: $vodActor, vodArea: $vodArea, vodLang: $vodLang, vodPic: $vodPic, vodRemarks: $vodRemarks, vodYear: $vodYear)';
}


}

/// @nodoc
abstract mixin class _$SearchVodItemCopyWith<$Res> implements $SearchVodItemCopyWith<$Res> {
  factory _$SearchVodItemCopyWith(_SearchVodItem value, $Res Function(_SearchVodItem) _then) = __$SearchVodItemCopyWithImpl;
@override @useResult
$Res call({
 int typeId, PlatformInt64 vodId, String vodName, String vodActor, String vodArea, String vodLang, String vodPic, String vodRemarks, String vodYear
});




}
/// @nodoc
class __$SearchVodItemCopyWithImpl<$Res>
    implements _$SearchVodItemCopyWith<$Res> {
  __$SearchVodItemCopyWithImpl(this._self, this._then);

  final _SearchVodItem _self;
  final $Res Function(_SearchVodItem) _then;

/// Create a copy of SearchVodItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? typeId = null,Object? vodId = null,Object? vodName = null,Object? vodActor = null,Object? vodArea = null,Object? vodLang = null,Object? vodPic = null,Object? vodRemarks = null,Object? vodYear = null,}) {
  return _then(_SearchVodItem(
typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,vodId: null == vodId ? _self.vodId : vodId // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodName: null == vodName ? _self.vodName : vodName // ignore: cast_nullable_to_non_nullable
as String,vodActor: null == vodActor ? _self.vodActor : vodActor // ignore: cast_nullable_to_non_nullable
as String,vodArea: null == vodArea ? _self.vodArea : vodArea // ignore: cast_nullable_to_non_nullable
as String,vodLang: null == vodLang ? _self.vodLang : vodLang // ignore: cast_nullable_to_non_nullable
as String,vodPic: null == vodPic ? _self.vodPic : vodPic // ignore: cast_nullable_to_non_nullable
as String,vodRemarks: null == vodRemarks ? _self.vodRemarks : vodRemarks // ignore: cast_nullable_to_non_nullable
as String,vodYear: null == vodYear ? _self.vodYear : vodYear // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
