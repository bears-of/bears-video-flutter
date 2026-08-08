// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommend_video.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BannerItem {

 int get id; String get name; String get content; int get reqType; String get reqContent; String get realPackageId;
/// Create a copy of BannerItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerItemCopyWith<BannerItem> get copyWith => _$BannerItemCopyWithImpl<BannerItem>(this as BannerItem, _$identity);

  /// Serializes this BannerItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.content, content) || other.content == content)&&(identical(other.reqType, reqType) || other.reqType == reqType)&&(identical(other.reqContent, reqContent) || other.reqContent == reqContent)&&(identical(other.realPackageId, realPackageId) || other.realPackageId == realPackageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,content,reqType,reqContent,realPackageId);

@override
String toString() {
  return 'BannerItem(id: $id, name: $name, content: $content, reqType: $reqType, reqContent: $reqContent, realPackageId: $realPackageId)';
}


}

/// @nodoc
abstract mixin class $BannerItemCopyWith<$Res>  {
  factory $BannerItemCopyWith(BannerItem value, $Res Function(BannerItem) _then) = _$BannerItemCopyWithImpl;
@useResult
$Res call({
 int id, String name, String content, int reqType, String reqContent, String realPackageId
});




}
/// @nodoc
class _$BannerItemCopyWithImpl<$Res>
    implements $BannerItemCopyWith<$Res> {
  _$BannerItemCopyWithImpl(this._self, this._then);

  final BannerItem _self;
  final $Res Function(BannerItem) _then;

/// Create a copy of BannerItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? content = null,Object? reqType = null,Object? reqContent = null,Object? realPackageId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,reqType: null == reqType ? _self.reqType : reqType // ignore: cast_nullable_to_non_nullable
as int,reqContent: null == reqContent ? _self.reqContent : reqContent // ignore: cast_nullable_to_non_nullable
as String,realPackageId: null == realPackageId ? _self.realPackageId : realPackageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerItem].
extension BannerItemPatterns on BannerItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerItem value)  $default,){
final _that = this;
switch (_that) {
case _BannerItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerItem value)?  $default,){
final _that = this;
switch (_that) {
case _BannerItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String content,  int reqType,  String reqContent,  String realPackageId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerItem() when $default != null:
return $default(_that.id,_that.name,_that.content,_that.reqType,_that.reqContent,_that.realPackageId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String content,  int reqType,  String reqContent,  String realPackageId)  $default,) {final _that = this;
switch (_that) {
case _BannerItem():
return $default(_that.id,_that.name,_that.content,_that.reqType,_that.reqContent,_that.realPackageId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String content,  int reqType,  String reqContent,  String realPackageId)?  $default,) {final _that = this;
switch (_that) {
case _BannerItem() when $default != null:
return $default(_that.id,_that.name,_that.content,_that.reqType,_that.reqContent,_that.realPackageId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerItem implements BannerItem {
  const _BannerItem({required this.id, required this.name, required this.content, required this.reqType, required this.reqContent, required this.realPackageId});
  factory _BannerItem.fromJson(Map<String, dynamic> json) => _$BannerItemFromJson(json);

@override final  int id;
@override final  String name;
@override final  String content;
@override final  int reqType;
@override final  String reqContent;
@override final  String realPackageId;

/// Create a copy of BannerItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerItemCopyWith<_BannerItem> get copyWith => __$BannerItemCopyWithImpl<_BannerItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.content, content) || other.content == content)&&(identical(other.reqType, reqType) || other.reqType == reqType)&&(identical(other.reqContent, reqContent) || other.reqContent == reqContent)&&(identical(other.realPackageId, realPackageId) || other.realPackageId == realPackageId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,content,reqType,reqContent,realPackageId);

@override
String toString() {
  return 'BannerItem(id: $id, name: $name, content: $content, reqType: $reqType, reqContent: $reqContent, realPackageId: $realPackageId)';
}


}

/// @nodoc
abstract mixin class _$BannerItemCopyWith<$Res> implements $BannerItemCopyWith<$Res> {
  factory _$BannerItemCopyWith(_BannerItem value, $Res Function(_BannerItem) _then) = __$BannerItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String content, int reqType, String reqContent, String realPackageId
});




}
/// @nodoc
class __$BannerItemCopyWithImpl<$Res>
    implements _$BannerItemCopyWith<$Res> {
  __$BannerItemCopyWithImpl(this._self, this._then);

  final _BannerItem _self;
  final $Res Function(_BannerItem) _then;

/// Create a copy of BannerItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? content = null,Object? reqType = null,Object? reqContent = null,Object? realPackageId = null,}) {
  return _then(_BannerItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,reqType: null == reqType ? _self.reqType : reqType // ignore: cast_nullable_to_non_nullable
as int,reqContent: null == reqContent ? _self.reqContent : reqContent // ignore: cast_nullable_to_non_nullable
as String,realPackageId: null == realPackageId ? _self.realPackageId : realPackageId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HomeRecommendData {

 List<BannerItem> get banners; List<HomeVideoSection> get videos;
/// Create a copy of HomeRecommendData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeRecommendDataCopyWith<HomeRecommendData> get copyWith => _$HomeRecommendDataCopyWithImpl<HomeRecommendData>(this as HomeRecommendData, _$identity);

  /// Serializes this HomeRecommendData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeRecommendData&&const DeepCollectionEquality().equals(other.banners, banners)&&const DeepCollectionEquality().equals(other.videos, videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(banners),const DeepCollectionEquality().hash(videos));

@override
String toString() {
  return 'HomeRecommendData(banners: $banners, videos: $videos)';
}


}

/// @nodoc
abstract mixin class $HomeRecommendDataCopyWith<$Res>  {
  factory $HomeRecommendDataCopyWith(HomeRecommendData value, $Res Function(HomeRecommendData) _then) = _$HomeRecommendDataCopyWithImpl;
@useResult
$Res call({
 List<BannerItem> banners, List<HomeVideoSection> videos
});




}
/// @nodoc
class _$HomeRecommendDataCopyWithImpl<$Res>
    implements $HomeRecommendDataCopyWith<$Res> {
  _$HomeRecommendDataCopyWithImpl(this._self, this._then);

  final HomeRecommendData _self;
  final $Res Function(HomeRecommendData) _then;

/// Create a copy of HomeRecommendData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? banners = null,Object? videos = null,}) {
  return _then(_self.copyWith(
banners: null == banners ? _self.banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerItem>,videos: null == videos ? _self.videos : videos // ignore: cast_nullable_to_non_nullable
as List<HomeVideoSection>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeRecommendData].
extension HomeRecommendDataPatterns on HomeRecommendData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeRecommendData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeRecommendData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeRecommendData value)  $default,){
final _that = this;
switch (_that) {
case _HomeRecommendData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeRecommendData value)?  $default,){
final _that = this;
switch (_that) {
case _HomeRecommendData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BannerItem> banners,  List<HomeVideoSection> videos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeRecommendData() when $default != null:
return $default(_that.banners,_that.videos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BannerItem> banners,  List<HomeVideoSection> videos)  $default,) {final _that = this;
switch (_that) {
case _HomeRecommendData():
return $default(_that.banners,_that.videos);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BannerItem> banners,  List<HomeVideoSection> videos)?  $default,) {final _that = this;
switch (_that) {
case _HomeRecommendData() when $default != null:
return $default(_that.banners,_that.videos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeRecommendData implements HomeRecommendData {
  const _HomeRecommendData({required final  List<BannerItem> banners, required final  List<HomeVideoSection> videos}): _banners = banners,_videos = videos;
  factory _HomeRecommendData.fromJson(Map<String, dynamic> json) => _$HomeRecommendDataFromJson(json);

 final  List<BannerItem> _banners;
@override List<BannerItem> get banners {
  if (_banners is EqualUnmodifiableListView) return _banners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_banners);
}

 final  List<HomeVideoSection> _videos;
@override List<HomeVideoSection> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}


/// Create a copy of HomeRecommendData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeRecommendDataCopyWith<_HomeRecommendData> get copyWith => __$HomeRecommendDataCopyWithImpl<_HomeRecommendData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeRecommendDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeRecommendData&&const DeepCollectionEquality().equals(other._banners, _banners)&&const DeepCollectionEquality().equals(other._videos, _videos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_banners),const DeepCollectionEquality().hash(_videos));

@override
String toString() {
  return 'HomeRecommendData(banners: $banners, videos: $videos)';
}


}

/// @nodoc
abstract mixin class _$HomeRecommendDataCopyWith<$Res> implements $HomeRecommendDataCopyWith<$Res> {
  factory _$HomeRecommendDataCopyWith(_HomeRecommendData value, $Res Function(_HomeRecommendData) _then) = __$HomeRecommendDataCopyWithImpl;
@override @useResult
$Res call({
 List<BannerItem> banners, List<HomeVideoSection> videos
});




}
/// @nodoc
class __$HomeRecommendDataCopyWithImpl<$Res>
    implements _$HomeRecommendDataCopyWith<$Res> {
  __$HomeRecommendDataCopyWithImpl(this._self, this._then);

  final _HomeRecommendData _self;
  final $Res Function(_HomeRecommendData) _then;

/// Create a copy of HomeRecommendData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? banners = null,Object? videos = null,}) {
  return _then(_HomeRecommendData(
banners: null == banners ? _self._banners : banners // ignore: cast_nullable_to_non_nullable
as List<BannerItem>,videos: null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<HomeVideoSection>,
  ));
}


}


/// @nodoc
mixin _$HomeVideoSection {

 int get id; String get name; int get typeId; bool get hasMore; int get moreReqType; String get moreText; List<RecommendVodItem> get vlist;
/// Create a copy of HomeVideoSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeVideoSectionCopyWith<HomeVideoSection> get copyWith => _$HomeVideoSectionCopyWithImpl<HomeVideoSection>(this as HomeVideoSection, _$identity);

  /// Serializes this HomeVideoSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeVideoSection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.moreReqType, moreReqType) || other.moreReqType == moreReqType)&&(identical(other.moreText, moreText) || other.moreText == moreText)&&const DeepCollectionEquality().equals(other.vlist, vlist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,typeId,hasMore,moreReqType,moreText,const DeepCollectionEquality().hash(vlist));

@override
String toString() {
  return 'HomeVideoSection(id: $id, name: $name, typeId: $typeId, hasMore: $hasMore, moreReqType: $moreReqType, moreText: $moreText, vlist: $vlist)';
}


}

/// @nodoc
abstract mixin class $HomeVideoSectionCopyWith<$Res>  {
  factory $HomeVideoSectionCopyWith(HomeVideoSection value, $Res Function(HomeVideoSection) _then) = _$HomeVideoSectionCopyWithImpl;
@useResult
$Res call({
 int id, String name, int typeId, bool hasMore, int moreReqType, String moreText, List<RecommendVodItem> vlist
});




}
/// @nodoc
class _$HomeVideoSectionCopyWithImpl<$Res>
    implements $HomeVideoSectionCopyWith<$Res> {
  _$HomeVideoSectionCopyWithImpl(this._self, this._then);

  final HomeVideoSection _self;
  final $Res Function(HomeVideoSection) _then;

/// Create a copy of HomeVideoSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? typeId = null,Object? hasMore = null,Object? moreReqType = null,Object? moreText = null,Object? vlist = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,moreReqType: null == moreReqType ? _self.moreReqType : moreReqType // ignore: cast_nullable_to_non_nullable
as int,moreText: null == moreText ? _self.moreText : moreText // ignore: cast_nullable_to_non_nullable
as String,vlist: null == vlist ? _self.vlist : vlist // ignore: cast_nullable_to_non_nullable
as List<RecommendVodItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeVideoSection].
extension HomeVideoSectionPatterns on HomeVideoSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeVideoSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeVideoSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeVideoSection value)  $default,){
final _that = this;
switch (_that) {
case _HomeVideoSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeVideoSection value)?  $default,){
final _that = this;
switch (_that) {
case _HomeVideoSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int typeId,  bool hasMore,  int moreReqType,  String moreText,  List<RecommendVodItem> vlist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeVideoSection() when $default != null:
return $default(_that.id,_that.name,_that.typeId,_that.hasMore,_that.moreReqType,_that.moreText,_that.vlist);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int typeId,  bool hasMore,  int moreReqType,  String moreText,  List<RecommendVodItem> vlist)  $default,) {final _that = this;
switch (_that) {
case _HomeVideoSection():
return $default(_that.id,_that.name,_that.typeId,_that.hasMore,_that.moreReqType,_that.moreText,_that.vlist);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int typeId,  bool hasMore,  int moreReqType,  String moreText,  List<RecommendVodItem> vlist)?  $default,) {final _that = this;
switch (_that) {
case _HomeVideoSection() when $default != null:
return $default(_that.id,_that.name,_that.typeId,_that.hasMore,_that.moreReqType,_that.moreText,_that.vlist);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HomeVideoSection implements HomeVideoSection {
  const _HomeVideoSection({required this.id, required this.name, required this.typeId, required this.hasMore, required this.moreReqType, required this.moreText, required final  List<RecommendVodItem> vlist}): _vlist = vlist;
  factory _HomeVideoSection.fromJson(Map<String, dynamic> json) => _$HomeVideoSectionFromJson(json);

@override final  int id;
@override final  String name;
@override final  int typeId;
@override final  bool hasMore;
@override final  int moreReqType;
@override final  String moreText;
 final  List<RecommendVodItem> _vlist;
@override List<RecommendVodItem> get vlist {
  if (_vlist is EqualUnmodifiableListView) return _vlist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vlist);
}


/// Create a copy of HomeVideoSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeVideoSectionCopyWith<_HomeVideoSection> get copyWith => __$HomeVideoSectionCopyWithImpl<_HomeVideoSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HomeVideoSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeVideoSection&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.moreReqType, moreReqType) || other.moreReqType == moreReqType)&&(identical(other.moreText, moreText) || other.moreText == moreText)&&const DeepCollectionEquality().equals(other._vlist, _vlist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,typeId,hasMore,moreReqType,moreText,const DeepCollectionEquality().hash(_vlist));

@override
String toString() {
  return 'HomeVideoSection(id: $id, name: $name, typeId: $typeId, hasMore: $hasMore, moreReqType: $moreReqType, moreText: $moreText, vlist: $vlist)';
}


}

/// @nodoc
abstract mixin class _$HomeVideoSectionCopyWith<$Res> implements $HomeVideoSectionCopyWith<$Res> {
  factory _$HomeVideoSectionCopyWith(_HomeVideoSection value, $Res Function(_HomeVideoSection) _then) = __$HomeVideoSectionCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int typeId, bool hasMore, int moreReqType, String moreText, List<RecommendVodItem> vlist
});




}
/// @nodoc
class __$HomeVideoSectionCopyWithImpl<$Res>
    implements _$HomeVideoSectionCopyWith<$Res> {
  __$HomeVideoSectionCopyWithImpl(this._self, this._then);

  final _HomeVideoSection _self;
  final $Res Function(_HomeVideoSection) _then;

/// Create a copy of HomeVideoSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? typeId = null,Object? hasMore = null,Object? moreReqType = null,Object? moreText = null,Object? vlist = null,}) {
  return _then(_HomeVideoSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,moreReqType: null == moreReqType ? _self.moreReqType : moreReqType // ignore: cast_nullable_to_non_nullable
as int,moreText: null == moreText ? _self.moreText : moreText // ignore: cast_nullable_to_non_nullable
as String,vlist: null == vlist ? _self._vlist : vlist // ignore: cast_nullable_to_non_nullable
as List<RecommendVodItem>,
  ));
}


}


/// @nodoc
mixin _$RecommendVodItem {

 int get vodId; String get vodName; String get vodPic; String get vodRemarks; int get typeId;
/// Create a copy of RecommendVodItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendVodItemCopyWith<RecommendVodItem> get copyWith => _$RecommendVodItemCopyWithImpl<RecommendVodItem>(this as RecommendVodItem, _$identity);

  /// Serializes this RecommendVodItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecommendVodItem&&(identical(other.vodId, vodId) || other.vodId == vodId)&&(identical(other.vodName, vodName) || other.vodName == vodName)&&(identical(other.vodPic, vodPic) || other.vodPic == vodPic)&&(identical(other.vodRemarks, vodRemarks) || other.vodRemarks == vodRemarks)&&(identical(other.typeId, typeId) || other.typeId == typeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vodId,vodName,vodPic,vodRemarks,typeId);

@override
String toString() {
  return 'RecommendVodItem(vodId: $vodId, vodName: $vodName, vodPic: $vodPic, vodRemarks: $vodRemarks, typeId: $typeId)';
}


}

/// @nodoc
abstract mixin class $RecommendVodItemCopyWith<$Res>  {
  factory $RecommendVodItemCopyWith(RecommendVodItem value, $Res Function(RecommendVodItem) _then) = _$RecommendVodItemCopyWithImpl;
@useResult
$Res call({
 int vodId, String vodName, String vodPic, String vodRemarks, int typeId
});




}
/// @nodoc
class _$RecommendVodItemCopyWithImpl<$Res>
    implements $RecommendVodItemCopyWith<$Res> {
  _$RecommendVodItemCopyWithImpl(this._self, this._then);

  final RecommendVodItem _self;
  final $Res Function(RecommendVodItem) _then;

/// Create a copy of RecommendVodItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vodId = null,Object? vodName = null,Object? vodPic = null,Object? vodRemarks = null,Object? typeId = null,}) {
  return _then(_self.copyWith(
vodId: null == vodId ? _self.vodId : vodId // ignore: cast_nullable_to_non_nullable
as int,vodName: null == vodName ? _self.vodName : vodName // ignore: cast_nullable_to_non_nullable
as String,vodPic: null == vodPic ? _self.vodPic : vodPic // ignore: cast_nullable_to_non_nullable
as String,vodRemarks: null == vodRemarks ? _self.vodRemarks : vodRemarks // ignore: cast_nullable_to_non_nullable
as String,typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecommendVodItem].
extension RecommendVodItemPatterns on RecommendVodItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecommendVodItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecommendVodItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecommendVodItem value)  $default,){
final _that = this;
switch (_that) {
case _RecommendVodItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecommendVodItem value)?  $default,){
final _that = this;
switch (_that) {
case _RecommendVodItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int vodId,  String vodName,  String vodPic,  String vodRemarks,  int typeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecommendVodItem() when $default != null:
return $default(_that.vodId,_that.vodName,_that.vodPic,_that.vodRemarks,_that.typeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int vodId,  String vodName,  String vodPic,  String vodRemarks,  int typeId)  $default,) {final _that = this;
switch (_that) {
case _RecommendVodItem():
return $default(_that.vodId,_that.vodName,_that.vodPic,_that.vodRemarks,_that.typeId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int vodId,  String vodName,  String vodPic,  String vodRemarks,  int typeId)?  $default,) {final _that = this;
switch (_that) {
case _RecommendVodItem() when $default != null:
return $default(_that.vodId,_that.vodName,_that.vodPic,_that.vodRemarks,_that.typeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecommendVodItem implements RecommendVodItem {
  const _RecommendVodItem({required this.vodId, required this.vodName, required this.vodPic, required this.vodRemarks, required this.typeId});
  factory _RecommendVodItem.fromJson(Map<String, dynamic> json) => _$RecommendVodItemFromJson(json);

@override final  int vodId;
@override final  String vodName;
@override final  String vodPic;
@override final  String vodRemarks;
@override final  int typeId;

/// Create a copy of RecommendVodItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendVodItemCopyWith<_RecommendVodItem> get copyWith => __$RecommendVodItemCopyWithImpl<_RecommendVodItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecommendVodItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecommendVodItem&&(identical(other.vodId, vodId) || other.vodId == vodId)&&(identical(other.vodName, vodName) || other.vodName == vodName)&&(identical(other.vodPic, vodPic) || other.vodPic == vodPic)&&(identical(other.vodRemarks, vodRemarks) || other.vodRemarks == vodRemarks)&&(identical(other.typeId, typeId) || other.typeId == typeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,vodId,vodName,vodPic,vodRemarks,typeId);

@override
String toString() {
  return 'RecommendVodItem(vodId: $vodId, vodName: $vodName, vodPic: $vodPic, vodRemarks: $vodRemarks, typeId: $typeId)';
}


}

/// @nodoc
abstract mixin class _$RecommendVodItemCopyWith<$Res> implements $RecommendVodItemCopyWith<$Res> {
  factory _$RecommendVodItemCopyWith(_RecommendVodItem value, $Res Function(_RecommendVodItem) _then) = __$RecommendVodItemCopyWithImpl;
@override @useResult
$Res call({
 int vodId, String vodName, String vodPic, String vodRemarks, int typeId
});




}
/// @nodoc
class __$RecommendVodItemCopyWithImpl<$Res>
    implements _$RecommendVodItemCopyWith<$Res> {
  __$RecommendVodItemCopyWithImpl(this._self, this._then);

  final _RecommendVodItem _self;
  final $Res Function(_RecommendVodItem) _then;

/// Create a copy of RecommendVodItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vodId = null,Object? vodName = null,Object? vodPic = null,Object? vodRemarks = null,Object? typeId = null,}) {
  return _then(_RecommendVodItem(
vodId: null == vodId ? _self.vodId : vodId // ignore: cast_nullable_to_non_nullable
as int,vodName: null == vodName ? _self.vodName : vodName // ignore: cast_nullable_to_non_nullable
as String,vodPic: null == vodPic ? _self.vodPic : vodPic // ignore: cast_nullable_to_non_nullable
as String,vodRemarks: null == vodRemarks ? _self.vodRemarks : vodRemarks // ignore: cast_nullable_to_non_nullable
as String,typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
