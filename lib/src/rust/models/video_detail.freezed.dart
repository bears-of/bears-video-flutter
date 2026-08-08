// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackendVideoDetail {

 int get commentCount; int get isCollect; VodInfo get vodInfo;
/// Create a copy of BackendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackendVideoDetailCopyWith<BackendVideoDetail> get copyWith => _$BackendVideoDetailCopyWithImpl<BackendVideoDetail>(this as BackendVideoDetail, _$identity);

  /// Serializes this BackendVideoDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackendVideoDetail&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.isCollect, isCollect) || other.isCollect == isCollect)&&(identical(other.vodInfo, vodInfo) || other.vodInfo == vodInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,commentCount,isCollect,vodInfo);

@override
String toString() {
  return 'BackendVideoDetail(commentCount: $commentCount, isCollect: $isCollect, vodInfo: $vodInfo)';
}


}

/// @nodoc
abstract mixin class $BackendVideoDetailCopyWith<$Res>  {
  factory $BackendVideoDetailCopyWith(BackendVideoDetail value, $Res Function(BackendVideoDetail) _then) = _$BackendVideoDetailCopyWithImpl;
@useResult
$Res call({
 int commentCount, int isCollect, VodInfo vodInfo
});


$VodInfoCopyWith<$Res> get vodInfo;

}
/// @nodoc
class _$BackendVideoDetailCopyWithImpl<$Res>
    implements $BackendVideoDetailCopyWith<$Res> {
  _$BackendVideoDetailCopyWithImpl(this._self, this._then);

  final BackendVideoDetail _self;
  final $Res Function(BackendVideoDetail) _then;

/// Create a copy of BackendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? commentCount = null,Object? isCollect = null,Object? vodInfo = null,}) {
  return _then(_self.copyWith(
commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,isCollect: null == isCollect ? _self.isCollect : isCollect // ignore: cast_nullable_to_non_nullable
as int,vodInfo: null == vodInfo ? _self.vodInfo : vodInfo // ignore: cast_nullable_to_non_nullable
as VodInfo,
  ));
}
/// Create a copy of BackendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VodInfoCopyWith<$Res> get vodInfo {
  
  return $VodInfoCopyWith<$Res>(_self.vodInfo, (value) {
    return _then(_self.copyWith(vodInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackendVideoDetail].
extension BackendVideoDetailPatterns on BackendVideoDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackendVideoDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackendVideoDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackendVideoDetail value)  $default,){
final _that = this;
switch (_that) {
case _BackendVideoDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackendVideoDetail value)?  $default,){
final _that = this;
switch (_that) {
case _BackendVideoDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int commentCount,  int isCollect,  VodInfo vodInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackendVideoDetail() when $default != null:
return $default(_that.commentCount,_that.isCollect,_that.vodInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int commentCount,  int isCollect,  VodInfo vodInfo)  $default,) {final _that = this;
switch (_that) {
case _BackendVideoDetail():
return $default(_that.commentCount,_that.isCollect,_that.vodInfo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int commentCount,  int isCollect,  VodInfo vodInfo)?  $default,) {final _that = this;
switch (_that) {
case _BackendVideoDetail() when $default != null:
return $default(_that.commentCount,_that.isCollect,_that.vodInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackendVideoDetail implements BackendVideoDetail {
  const _BackendVideoDetail({required this.commentCount, required this.isCollect, required this.vodInfo});
  factory _BackendVideoDetail.fromJson(Map<String, dynamic> json) => _$BackendVideoDetailFromJson(json);

@override final  int commentCount;
@override final  int isCollect;
@override final  VodInfo vodInfo;

/// Create a copy of BackendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackendVideoDetailCopyWith<_BackendVideoDetail> get copyWith => __$BackendVideoDetailCopyWithImpl<_BackendVideoDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackendVideoDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackendVideoDetail&&(identical(other.commentCount, commentCount) || other.commentCount == commentCount)&&(identical(other.isCollect, isCollect) || other.isCollect == isCollect)&&(identical(other.vodInfo, vodInfo) || other.vodInfo == vodInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,commentCount,isCollect,vodInfo);

@override
String toString() {
  return 'BackendVideoDetail(commentCount: $commentCount, isCollect: $isCollect, vodInfo: $vodInfo)';
}


}

/// @nodoc
abstract mixin class _$BackendVideoDetailCopyWith<$Res> implements $BackendVideoDetailCopyWith<$Res> {
  factory _$BackendVideoDetailCopyWith(_BackendVideoDetail value, $Res Function(_BackendVideoDetail) _then) = __$BackendVideoDetailCopyWithImpl;
@override @useResult
$Res call({
 int commentCount, int isCollect, VodInfo vodInfo
});


@override $VodInfoCopyWith<$Res> get vodInfo;

}
/// @nodoc
class __$BackendVideoDetailCopyWithImpl<$Res>
    implements _$BackendVideoDetailCopyWith<$Res> {
  __$BackendVideoDetailCopyWithImpl(this._self, this._then);

  final _BackendVideoDetail _self;
  final $Res Function(_BackendVideoDetail) _then;

/// Create a copy of BackendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? commentCount = null,Object? isCollect = null,Object? vodInfo = null,}) {
  return _then(_BackendVideoDetail(
commentCount: null == commentCount ? _self.commentCount : commentCount // ignore: cast_nullable_to_non_nullable
as int,isCollect: null == isCollect ? _self.isCollect : isCollect // ignore: cast_nullable_to_non_nullable
as int,vodInfo: null == vodInfo ? _self.vodInfo : vodInfo // ignore: cast_nullable_to_non_nullable
as VodInfo,
  ));
}

/// Create a copy of BackendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VodInfoCopyWith<$Res> get vodInfo {
  
  return $VodInfoCopyWith<$Res>(_self.vodInfo, (value) {
    return _then(_self.copyWith(vodInfo: value));
  });
}
}


/// @nodoc
mixin _$FrontendVideoDetail {

 List<PlaySource> get playSources; BackendVideoDetail get videoInfo;
/// Create a copy of FrontendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FrontendVideoDetailCopyWith<FrontendVideoDetail> get copyWith => _$FrontendVideoDetailCopyWithImpl<FrontendVideoDetail>(this as FrontendVideoDetail, _$identity);

  /// Serializes this FrontendVideoDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FrontendVideoDetail&&const DeepCollectionEquality().equals(other.playSources, playSources)&&(identical(other.videoInfo, videoInfo) || other.videoInfo == videoInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(playSources),videoInfo);

@override
String toString() {
  return 'FrontendVideoDetail(playSources: $playSources, videoInfo: $videoInfo)';
}


}

/// @nodoc
abstract mixin class $FrontendVideoDetailCopyWith<$Res>  {
  factory $FrontendVideoDetailCopyWith(FrontendVideoDetail value, $Res Function(FrontendVideoDetail) _then) = _$FrontendVideoDetailCopyWithImpl;
@useResult
$Res call({
 List<PlaySource> playSources, BackendVideoDetail videoInfo
});


$BackendVideoDetailCopyWith<$Res> get videoInfo;

}
/// @nodoc
class _$FrontendVideoDetailCopyWithImpl<$Res>
    implements $FrontendVideoDetailCopyWith<$Res> {
  _$FrontendVideoDetailCopyWithImpl(this._self, this._then);

  final FrontendVideoDetail _self;
  final $Res Function(FrontendVideoDetail) _then;

/// Create a copy of FrontendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playSources = null,Object? videoInfo = null,}) {
  return _then(_self.copyWith(
playSources: null == playSources ? _self.playSources : playSources // ignore: cast_nullable_to_non_nullable
as List<PlaySource>,videoInfo: null == videoInfo ? _self.videoInfo : videoInfo // ignore: cast_nullable_to_non_nullable
as BackendVideoDetail,
  ));
}
/// Create a copy of FrontendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackendVideoDetailCopyWith<$Res> get videoInfo {
  
  return $BackendVideoDetailCopyWith<$Res>(_self.videoInfo, (value) {
    return _then(_self.copyWith(videoInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [FrontendVideoDetail].
extension FrontendVideoDetailPatterns on FrontendVideoDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FrontendVideoDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FrontendVideoDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FrontendVideoDetail value)  $default,){
final _that = this;
switch (_that) {
case _FrontendVideoDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FrontendVideoDetail value)?  $default,){
final _that = this;
switch (_that) {
case _FrontendVideoDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PlaySource> playSources,  BackendVideoDetail videoInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FrontendVideoDetail() when $default != null:
return $default(_that.playSources,_that.videoInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PlaySource> playSources,  BackendVideoDetail videoInfo)  $default,) {final _that = this;
switch (_that) {
case _FrontendVideoDetail():
return $default(_that.playSources,_that.videoInfo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PlaySource> playSources,  BackendVideoDetail videoInfo)?  $default,) {final _that = this;
switch (_that) {
case _FrontendVideoDetail() when $default != null:
return $default(_that.playSources,_that.videoInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FrontendVideoDetail implements FrontendVideoDetail {
  const _FrontendVideoDetail({required final  List<PlaySource> playSources, required this.videoInfo}): _playSources = playSources;
  factory _FrontendVideoDetail.fromJson(Map<String, dynamic> json) => _$FrontendVideoDetailFromJson(json);

 final  List<PlaySource> _playSources;
@override List<PlaySource> get playSources {
  if (_playSources is EqualUnmodifiableListView) return _playSources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playSources);
}

@override final  BackendVideoDetail videoInfo;

/// Create a copy of FrontendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FrontendVideoDetailCopyWith<_FrontendVideoDetail> get copyWith => __$FrontendVideoDetailCopyWithImpl<_FrontendVideoDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FrontendVideoDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FrontendVideoDetail&&const DeepCollectionEquality().equals(other._playSources, _playSources)&&(identical(other.videoInfo, videoInfo) || other.videoInfo == videoInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_playSources),videoInfo);

@override
String toString() {
  return 'FrontendVideoDetail(playSources: $playSources, videoInfo: $videoInfo)';
}


}

/// @nodoc
abstract mixin class _$FrontendVideoDetailCopyWith<$Res> implements $FrontendVideoDetailCopyWith<$Res> {
  factory _$FrontendVideoDetailCopyWith(_FrontendVideoDetail value, $Res Function(_FrontendVideoDetail) _then) = __$FrontendVideoDetailCopyWithImpl;
@override @useResult
$Res call({
 List<PlaySource> playSources, BackendVideoDetail videoInfo
});


@override $BackendVideoDetailCopyWith<$Res> get videoInfo;

}
/// @nodoc
class __$FrontendVideoDetailCopyWithImpl<$Res>
    implements _$FrontendVideoDetailCopyWith<$Res> {
  __$FrontendVideoDetailCopyWithImpl(this._self, this._then);

  final _FrontendVideoDetail _self;
  final $Res Function(_FrontendVideoDetail) _then;

/// Create a copy of FrontendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playSources = null,Object? videoInfo = null,}) {
  return _then(_FrontendVideoDetail(
playSources: null == playSources ? _self._playSources : playSources // ignore: cast_nullable_to_non_nullable
as List<PlaySource>,videoInfo: null == videoInfo ? _self.videoInfo : videoInfo // ignore: cast_nullable_to_non_nullable
as BackendVideoDetail,
  ));
}

/// Create a copy of FrontendVideoDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackendVideoDetailCopyWith<$Res> get videoInfo {
  
  return $BackendVideoDetailCopyWith<$Res>(_self.videoInfo, (value) {
    return _then(_self.copyWith(videoInfo: value));
  });
}
}


/// @nodoc
mixin _$VodInfo {

 int get groupId; int get typeId; int get typeId1; PlatformInt64 get vodId; String get vodName; String get vodEn; String get vodSub; String get vodActor; String get vodDirector; String get vodWriter; String get vodArea; String get vodLang; String get vodYear; String get vodClass; String get vodPic; String get vodPicThumb; String get vodPicSlide; String? get vodPicScreenshot; String get vodBlurb; String get vodContent; String get vodRemarks; String get vodPubdate; int get vodTotal; String get vodSerial; String get vodDuration; String get vodScore; int get vodScoreAll; int get vodScoreNum; PlatformInt64 get vodDoubanId; String get vodDoubanScore; PlatformInt64 get vodHits; PlatformInt64 get vodHitsDay; PlatformInt64 get vodHitsWeek; PlatformInt64 get vodHitsMonth; PlatformInt64 get vodUp; PlatformInt64 get vodDown; int get vodStatus; int get vodIsend; int get vodLock; int get vodLevel; int get vodCopyright; int get vodPoints; int get vodPointsPlay; int get vodPointsDown; int get vodTrysee; int get vodPlot; String get vodPlotName; String get vodPlotDetail; String get vodPlayFrom; String get vodPlayServer; String get vodPlayNote; String get vodPlayUrl; String get vodDownFrom; String get vodDownServer; String get vodDownNote; String get vodDownUrl; String get vodJumpurl; String get vodPwd; String get vodPwdUrl; String get vodPwdPlay; String get vodPwdPlayUrl; String get vodPwdDown; String get vodPwdDownUrl; String get vodRelVod; String get vodRelArt; String get vodTag; String get vodLetter; String get vodColor; String get vodAuthor; String get vodBehind; String get vodState; String get vodVersion; String get vodWeekday; String get vodTv; String get vodTpl; String get vodTplPlay; String get vodTplDown; String get vodReurl; PlatformInt64 get vodTime; PlatformInt64 get vodTimeAdd; PlatformInt64 get vodTimeHits; PlatformInt64 get vodTimeMake; List<VodPlayer>? get vodUrlWithPlayer;
/// Create a copy of VodInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VodInfoCopyWith<VodInfo> get copyWith => _$VodInfoCopyWithImpl<VodInfo>(this as VodInfo, _$identity);

  /// Serializes this VodInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VodInfo&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.typeId1, typeId1) || other.typeId1 == typeId1)&&(identical(other.vodId, vodId) || other.vodId == vodId)&&(identical(other.vodName, vodName) || other.vodName == vodName)&&(identical(other.vodEn, vodEn) || other.vodEn == vodEn)&&(identical(other.vodSub, vodSub) || other.vodSub == vodSub)&&(identical(other.vodActor, vodActor) || other.vodActor == vodActor)&&(identical(other.vodDirector, vodDirector) || other.vodDirector == vodDirector)&&(identical(other.vodWriter, vodWriter) || other.vodWriter == vodWriter)&&(identical(other.vodArea, vodArea) || other.vodArea == vodArea)&&(identical(other.vodLang, vodLang) || other.vodLang == vodLang)&&(identical(other.vodYear, vodYear) || other.vodYear == vodYear)&&(identical(other.vodClass, vodClass) || other.vodClass == vodClass)&&(identical(other.vodPic, vodPic) || other.vodPic == vodPic)&&(identical(other.vodPicThumb, vodPicThumb) || other.vodPicThumb == vodPicThumb)&&(identical(other.vodPicSlide, vodPicSlide) || other.vodPicSlide == vodPicSlide)&&(identical(other.vodPicScreenshot, vodPicScreenshot) || other.vodPicScreenshot == vodPicScreenshot)&&(identical(other.vodBlurb, vodBlurb) || other.vodBlurb == vodBlurb)&&(identical(other.vodContent, vodContent) || other.vodContent == vodContent)&&(identical(other.vodRemarks, vodRemarks) || other.vodRemarks == vodRemarks)&&(identical(other.vodPubdate, vodPubdate) || other.vodPubdate == vodPubdate)&&(identical(other.vodTotal, vodTotal) || other.vodTotal == vodTotal)&&(identical(other.vodSerial, vodSerial) || other.vodSerial == vodSerial)&&(identical(other.vodDuration, vodDuration) || other.vodDuration == vodDuration)&&(identical(other.vodScore, vodScore) || other.vodScore == vodScore)&&(identical(other.vodScoreAll, vodScoreAll) || other.vodScoreAll == vodScoreAll)&&(identical(other.vodScoreNum, vodScoreNum) || other.vodScoreNum == vodScoreNum)&&(identical(other.vodDoubanId, vodDoubanId) || other.vodDoubanId == vodDoubanId)&&(identical(other.vodDoubanScore, vodDoubanScore) || other.vodDoubanScore == vodDoubanScore)&&(identical(other.vodHits, vodHits) || other.vodHits == vodHits)&&(identical(other.vodHitsDay, vodHitsDay) || other.vodHitsDay == vodHitsDay)&&(identical(other.vodHitsWeek, vodHitsWeek) || other.vodHitsWeek == vodHitsWeek)&&(identical(other.vodHitsMonth, vodHitsMonth) || other.vodHitsMonth == vodHitsMonth)&&(identical(other.vodUp, vodUp) || other.vodUp == vodUp)&&(identical(other.vodDown, vodDown) || other.vodDown == vodDown)&&(identical(other.vodStatus, vodStatus) || other.vodStatus == vodStatus)&&(identical(other.vodIsend, vodIsend) || other.vodIsend == vodIsend)&&(identical(other.vodLock, vodLock) || other.vodLock == vodLock)&&(identical(other.vodLevel, vodLevel) || other.vodLevel == vodLevel)&&(identical(other.vodCopyright, vodCopyright) || other.vodCopyright == vodCopyright)&&(identical(other.vodPoints, vodPoints) || other.vodPoints == vodPoints)&&(identical(other.vodPointsPlay, vodPointsPlay) || other.vodPointsPlay == vodPointsPlay)&&(identical(other.vodPointsDown, vodPointsDown) || other.vodPointsDown == vodPointsDown)&&(identical(other.vodTrysee, vodTrysee) || other.vodTrysee == vodTrysee)&&(identical(other.vodPlot, vodPlot) || other.vodPlot == vodPlot)&&(identical(other.vodPlotName, vodPlotName) || other.vodPlotName == vodPlotName)&&(identical(other.vodPlotDetail, vodPlotDetail) || other.vodPlotDetail == vodPlotDetail)&&(identical(other.vodPlayFrom, vodPlayFrom) || other.vodPlayFrom == vodPlayFrom)&&(identical(other.vodPlayServer, vodPlayServer) || other.vodPlayServer == vodPlayServer)&&(identical(other.vodPlayNote, vodPlayNote) || other.vodPlayNote == vodPlayNote)&&(identical(other.vodPlayUrl, vodPlayUrl) || other.vodPlayUrl == vodPlayUrl)&&(identical(other.vodDownFrom, vodDownFrom) || other.vodDownFrom == vodDownFrom)&&(identical(other.vodDownServer, vodDownServer) || other.vodDownServer == vodDownServer)&&(identical(other.vodDownNote, vodDownNote) || other.vodDownNote == vodDownNote)&&(identical(other.vodDownUrl, vodDownUrl) || other.vodDownUrl == vodDownUrl)&&(identical(other.vodJumpurl, vodJumpurl) || other.vodJumpurl == vodJumpurl)&&(identical(other.vodPwd, vodPwd) || other.vodPwd == vodPwd)&&(identical(other.vodPwdUrl, vodPwdUrl) || other.vodPwdUrl == vodPwdUrl)&&(identical(other.vodPwdPlay, vodPwdPlay) || other.vodPwdPlay == vodPwdPlay)&&(identical(other.vodPwdPlayUrl, vodPwdPlayUrl) || other.vodPwdPlayUrl == vodPwdPlayUrl)&&(identical(other.vodPwdDown, vodPwdDown) || other.vodPwdDown == vodPwdDown)&&(identical(other.vodPwdDownUrl, vodPwdDownUrl) || other.vodPwdDownUrl == vodPwdDownUrl)&&(identical(other.vodRelVod, vodRelVod) || other.vodRelVod == vodRelVod)&&(identical(other.vodRelArt, vodRelArt) || other.vodRelArt == vodRelArt)&&(identical(other.vodTag, vodTag) || other.vodTag == vodTag)&&(identical(other.vodLetter, vodLetter) || other.vodLetter == vodLetter)&&(identical(other.vodColor, vodColor) || other.vodColor == vodColor)&&(identical(other.vodAuthor, vodAuthor) || other.vodAuthor == vodAuthor)&&(identical(other.vodBehind, vodBehind) || other.vodBehind == vodBehind)&&(identical(other.vodState, vodState) || other.vodState == vodState)&&(identical(other.vodVersion, vodVersion) || other.vodVersion == vodVersion)&&(identical(other.vodWeekday, vodWeekday) || other.vodWeekday == vodWeekday)&&(identical(other.vodTv, vodTv) || other.vodTv == vodTv)&&(identical(other.vodTpl, vodTpl) || other.vodTpl == vodTpl)&&(identical(other.vodTplPlay, vodTplPlay) || other.vodTplPlay == vodTplPlay)&&(identical(other.vodTplDown, vodTplDown) || other.vodTplDown == vodTplDown)&&(identical(other.vodReurl, vodReurl) || other.vodReurl == vodReurl)&&(identical(other.vodTime, vodTime) || other.vodTime == vodTime)&&(identical(other.vodTimeAdd, vodTimeAdd) || other.vodTimeAdd == vodTimeAdd)&&(identical(other.vodTimeHits, vodTimeHits) || other.vodTimeHits == vodTimeHits)&&(identical(other.vodTimeMake, vodTimeMake) || other.vodTimeMake == vodTimeMake)&&const DeepCollectionEquality().equals(other.vodUrlWithPlayer, vodUrlWithPlayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,groupId,typeId,typeId1,vodId,vodName,vodEn,vodSub,vodActor,vodDirector,vodWriter,vodArea,vodLang,vodYear,vodClass,vodPic,vodPicThumb,vodPicSlide,vodPicScreenshot,vodBlurb,vodContent,vodRemarks,vodPubdate,vodTotal,vodSerial,vodDuration,vodScore,vodScoreAll,vodScoreNum,vodDoubanId,vodDoubanScore,vodHits,vodHitsDay,vodHitsWeek,vodHitsMonth,vodUp,vodDown,vodStatus,vodIsend,vodLock,vodLevel,vodCopyright,vodPoints,vodPointsPlay,vodPointsDown,vodTrysee,vodPlot,vodPlotName,vodPlotDetail,vodPlayFrom,vodPlayServer,vodPlayNote,vodPlayUrl,vodDownFrom,vodDownServer,vodDownNote,vodDownUrl,vodJumpurl,vodPwd,vodPwdUrl,vodPwdPlay,vodPwdPlayUrl,vodPwdDown,vodPwdDownUrl,vodRelVod,vodRelArt,vodTag,vodLetter,vodColor,vodAuthor,vodBehind,vodState,vodVersion,vodWeekday,vodTv,vodTpl,vodTplPlay,vodTplDown,vodReurl,vodTime,vodTimeAdd,vodTimeHits,vodTimeMake,const DeepCollectionEquality().hash(vodUrlWithPlayer)]);

@override
String toString() {
  return 'VodInfo(groupId: $groupId, typeId: $typeId, typeId1: $typeId1, vodId: $vodId, vodName: $vodName, vodEn: $vodEn, vodSub: $vodSub, vodActor: $vodActor, vodDirector: $vodDirector, vodWriter: $vodWriter, vodArea: $vodArea, vodLang: $vodLang, vodYear: $vodYear, vodClass: $vodClass, vodPic: $vodPic, vodPicThumb: $vodPicThumb, vodPicSlide: $vodPicSlide, vodPicScreenshot: $vodPicScreenshot, vodBlurb: $vodBlurb, vodContent: $vodContent, vodRemarks: $vodRemarks, vodPubdate: $vodPubdate, vodTotal: $vodTotal, vodSerial: $vodSerial, vodDuration: $vodDuration, vodScore: $vodScore, vodScoreAll: $vodScoreAll, vodScoreNum: $vodScoreNum, vodDoubanId: $vodDoubanId, vodDoubanScore: $vodDoubanScore, vodHits: $vodHits, vodHitsDay: $vodHitsDay, vodHitsWeek: $vodHitsWeek, vodHitsMonth: $vodHitsMonth, vodUp: $vodUp, vodDown: $vodDown, vodStatus: $vodStatus, vodIsend: $vodIsend, vodLock: $vodLock, vodLevel: $vodLevel, vodCopyright: $vodCopyright, vodPoints: $vodPoints, vodPointsPlay: $vodPointsPlay, vodPointsDown: $vodPointsDown, vodTrysee: $vodTrysee, vodPlot: $vodPlot, vodPlotName: $vodPlotName, vodPlotDetail: $vodPlotDetail, vodPlayFrom: $vodPlayFrom, vodPlayServer: $vodPlayServer, vodPlayNote: $vodPlayNote, vodPlayUrl: $vodPlayUrl, vodDownFrom: $vodDownFrom, vodDownServer: $vodDownServer, vodDownNote: $vodDownNote, vodDownUrl: $vodDownUrl, vodJumpurl: $vodJumpurl, vodPwd: $vodPwd, vodPwdUrl: $vodPwdUrl, vodPwdPlay: $vodPwdPlay, vodPwdPlayUrl: $vodPwdPlayUrl, vodPwdDown: $vodPwdDown, vodPwdDownUrl: $vodPwdDownUrl, vodRelVod: $vodRelVod, vodRelArt: $vodRelArt, vodTag: $vodTag, vodLetter: $vodLetter, vodColor: $vodColor, vodAuthor: $vodAuthor, vodBehind: $vodBehind, vodState: $vodState, vodVersion: $vodVersion, vodWeekday: $vodWeekday, vodTv: $vodTv, vodTpl: $vodTpl, vodTplPlay: $vodTplPlay, vodTplDown: $vodTplDown, vodReurl: $vodReurl, vodTime: $vodTime, vodTimeAdd: $vodTimeAdd, vodTimeHits: $vodTimeHits, vodTimeMake: $vodTimeMake, vodUrlWithPlayer: $vodUrlWithPlayer)';
}


}

/// @nodoc
abstract mixin class $VodInfoCopyWith<$Res>  {
  factory $VodInfoCopyWith(VodInfo value, $Res Function(VodInfo) _then) = _$VodInfoCopyWithImpl;
@useResult
$Res call({
 int groupId, int typeId, int typeId1, PlatformInt64 vodId, String vodName, String vodEn, String vodSub, String vodActor, String vodDirector, String vodWriter, String vodArea, String vodLang, String vodYear, String vodClass, String vodPic, String vodPicThumb, String vodPicSlide, String? vodPicScreenshot, String vodBlurb, String vodContent, String vodRemarks, String vodPubdate, int vodTotal, String vodSerial, String vodDuration, String vodScore, int vodScoreAll, int vodScoreNum, PlatformInt64 vodDoubanId, String vodDoubanScore, PlatformInt64 vodHits, PlatformInt64 vodHitsDay, PlatformInt64 vodHitsWeek, PlatformInt64 vodHitsMonth, PlatformInt64 vodUp, PlatformInt64 vodDown, int vodStatus, int vodIsend, int vodLock, int vodLevel, int vodCopyright, int vodPoints, int vodPointsPlay, int vodPointsDown, int vodTrysee, int vodPlot, String vodPlotName, String vodPlotDetail, String vodPlayFrom, String vodPlayServer, String vodPlayNote, String vodPlayUrl, String vodDownFrom, String vodDownServer, String vodDownNote, String vodDownUrl, String vodJumpurl, String vodPwd, String vodPwdUrl, String vodPwdPlay, String vodPwdPlayUrl, String vodPwdDown, String vodPwdDownUrl, String vodRelVod, String vodRelArt, String vodTag, String vodLetter, String vodColor, String vodAuthor, String vodBehind, String vodState, String vodVersion, String vodWeekday, String vodTv, String vodTpl, String vodTplPlay, String vodTplDown, String vodReurl, PlatformInt64 vodTime, PlatformInt64 vodTimeAdd, PlatformInt64 vodTimeHits, PlatformInt64 vodTimeMake, List<VodPlayer>? vodUrlWithPlayer
});




}
/// @nodoc
class _$VodInfoCopyWithImpl<$Res>
    implements $VodInfoCopyWith<$Res> {
  _$VodInfoCopyWithImpl(this._self, this._then);

  final VodInfo _self;
  final $Res Function(VodInfo) _then;

/// Create a copy of VodInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? typeId = null,Object? typeId1 = null,Object? vodId = null,Object? vodName = null,Object? vodEn = null,Object? vodSub = null,Object? vodActor = null,Object? vodDirector = null,Object? vodWriter = null,Object? vodArea = null,Object? vodLang = null,Object? vodYear = null,Object? vodClass = null,Object? vodPic = null,Object? vodPicThumb = null,Object? vodPicSlide = null,Object? vodPicScreenshot = freezed,Object? vodBlurb = null,Object? vodContent = null,Object? vodRemarks = null,Object? vodPubdate = null,Object? vodTotal = null,Object? vodSerial = null,Object? vodDuration = null,Object? vodScore = null,Object? vodScoreAll = null,Object? vodScoreNum = null,Object? vodDoubanId = null,Object? vodDoubanScore = null,Object? vodHits = null,Object? vodHitsDay = null,Object? vodHitsWeek = null,Object? vodHitsMonth = null,Object? vodUp = null,Object? vodDown = null,Object? vodStatus = null,Object? vodIsend = null,Object? vodLock = null,Object? vodLevel = null,Object? vodCopyright = null,Object? vodPoints = null,Object? vodPointsPlay = null,Object? vodPointsDown = null,Object? vodTrysee = null,Object? vodPlot = null,Object? vodPlotName = null,Object? vodPlotDetail = null,Object? vodPlayFrom = null,Object? vodPlayServer = null,Object? vodPlayNote = null,Object? vodPlayUrl = null,Object? vodDownFrom = null,Object? vodDownServer = null,Object? vodDownNote = null,Object? vodDownUrl = null,Object? vodJumpurl = null,Object? vodPwd = null,Object? vodPwdUrl = null,Object? vodPwdPlay = null,Object? vodPwdPlayUrl = null,Object? vodPwdDown = null,Object? vodPwdDownUrl = null,Object? vodRelVod = null,Object? vodRelArt = null,Object? vodTag = null,Object? vodLetter = null,Object? vodColor = null,Object? vodAuthor = null,Object? vodBehind = null,Object? vodState = null,Object? vodVersion = null,Object? vodWeekday = null,Object? vodTv = null,Object? vodTpl = null,Object? vodTplPlay = null,Object? vodTplDown = null,Object? vodReurl = null,Object? vodTime = null,Object? vodTimeAdd = null,Object? vodTimeHits = null,Object? vodTimeMake = null,Object? vodUrlWithPlayer = freezed,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,typeId1: null == typeId1 ? _self.typeId1 : typeId1 // ignore: cast_nullable_to_non_nullable
as int,vodId: null == vodId ? _self.vodId : vodId // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodName: null == vodName ? _self.vodName : vodName // ignore: cast_nullable_to_non_nullable
as String,vodEn: null == vodEn ? _self.vodEn : vodEn // ignore: cast_nullable_to_non_nullable
as String,vodSub: null == vodSub ? _self.vodSub : vodSub // ignore: cast_nullable_to_non_nullable
as String,vodActor: null == vodActor ? _self.vodActor : vodActor // ignore: cast_nullable_to_non_nullable
as String,vodDirector: null == vodDirector ? _self.vodDirector : vodDirector // ignore: cast_nullable_to_non_nullable
as String,vodWriter: null == vodWriter ? _self.vodWriter : vodWriter // ignore: cast_nullable_to_non_nullable
as String,vodArea: null == vodArea ? _self.vodArea : vodArea // ignore: cast_nullable_to_non_nullable
as String,vodLang: null == vodLang ? _self.vodLang : vodLang // ignore: cast_nullable_to_non_nullable
as String,vodYear: null == vodYear ? _self.vodYear : vodYear // ignore: cast_nullable_to_non_nullable
as String,vodClass: null == vodClass ? _self.vodClass : vodClass // ignore: cast_nullable_to_non_nullable
as String,vodPic: null == vodPic ? _self.vodPic : vodPic // ignore: cast_nullable_to_non_nullable
as String,vodPicThumb: null == vodPicThumb ? _self.vodPicThumb : vodPicThumb // ignore: cast_nullable_to_non_nullable
as String,vodPicSlide: null == vodPicSlide ? _self.vodPicSlide : vodPicSlide // ignore: cast_nullable_to_non_nullable
as String,vodPicScreenshot: freezed == vodPicScreenshot ? _self.vodPicScreenshot : vodPicScreenshot // ignore: cast_nullable_to_non_nullable
as String?,vodBlurb: null == vodBlurb ? _self.vodBlurb : vodBlurb // ignore: cast_nullable_to_non_nullable
as String,vodContent: null == vodContent ? _self.vodContent : vodContent // ignore: cast_nullable_to_non_nullable
as String,vodRemarks: null == vodRemarks ? _self.vodRemarks : vodRemarks // ignore: cast_nullable_to_non_nullable
as String,vodPubdate: null == vodPubdate ? _self.vodPubdate : vodPubdate // ignore: cast_nullable_to_non_nullable
as String,vodTotal: null == vodTotal ? _self.vodTotal : vodTotal // ignore: cast_nullable_to_non_nullable
as int,vodSerial: null == vodSerial ? _self.vodSerial : vodSerial // ignore: cast_nullable_to_non_nullable
as String,vodDuration: null == vodDuration ? _self.vodDuration : vodDuration // ignore: cast_nullable_to_non_nullable
as String,vodScore: null == vodScore ? _self.vodScore : vodScore // ignore: cast_nullable_to_non_nullable
as String,vodScoreAll: null == vodScoreAll ? _self.vodScoreAll : vodScoreAll // ignore: cast_nullable_to_non_nullable
as int,vodScoreNum: null == vodScoreNum ? _self.vodScoreNum : vodScoreNum // ignore: cast_nullable_to_non_nullable
as int,vodDoubanId: null == vodDoubanId ? _self.vodDoubanId : vodDoubanId // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodDoubanScore: null == vodDoubanScore ? _self.vodDoubanScore : vodDoubanScore // ignore: cast_nullable_to_non_nullable
as String,vodHits: null == vodHits ? _self.vodHits : vodHits // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodHitsDay: null == vodHitsDay ? _self.vodHitsDay : vodHitsDay // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodHitsWeek: null == vodHitsWeek ? _self.vodHitsWeek : vodHitsWeek // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodHitsMonth: null == vodHitsMonth ? _self.vodHitsMonth : vodHitsMonth // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodUp: null == vodUp ? _self.vodUp : vodUp // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodDown: null == vodDown ? _self.vodDown : vodDown // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodStatus: null == vodStatus ? _self.vodStatus : vodStatus // ignore: cast_nullable_to_non_nullable
as int,vodIsend: null == vodIsend ? _self.vodIsend : vodIsend // ignore: cast_nullable_to_non_nullable
as int,vodLock: null == vodLock ? _self.vodLock : vodLock // ignore: cast_nullable_to_non_nullable
as int,vodLevel: null == vodLevel ? _self.vodLevel : vodLevel // ignore: cast_nullable_to_non_nullable
as int,vodCopyright: null == vodCopyright ? _self.vodCopyright : vodCopyright // ignore: cast_nullable_to_non_nullable
as int,vodPoints: null == vodPoints ? _self.vodPoints : vodPoints // ignore: cast_nullable_to_non_nullable
as int,vodPointsPlay: null == vodPointsPlay ? _self.vodPointsPlay : vodPointsPlay // ignore: cast_nullable_to_non_nullable
as int,vodPointsDown: null == vodPointsDown ? _self.vodPointsDown : vodPointsDown // ignore: cast_nullable_to_non_nullable
as int,vodTrysee: null == vodTrysee ? _self.vodTrysee : vodTrysee // ignore: cast_nullable_to_non_nullable
as int,vodPlot: null == vodPlot ? _self.vodPlot : vodPlot // ignore: cast_nullable_to_non_nullable
as int,vodPlotName: null == vodPlotName ? _self.vodPlotName : vodPlotName // ignore: cast_nullable_to_non_nullable
as String,vodPlotDetail: null == vodPlotDetail ? _self.vodPlotDetail : vodPlotDetail // ignore: cast_nullable_to_non_nullable
as String,vodPlayFrom: null == vodPlayFrom ? _self.vodPlayFrom : vodPlayFrom // ignore: cast_nullable_to_non_nullable
as String,vodPlayServer: null == vodPlayServer ? _self.vodPlayServer : vodPlayServer // ignore: cast_nullable_to_non_nullable
as String,vodPlayNote: null == vodPlayNote ? _self.vodPlayNote : vodPlayNote // ignore: cast_nullable_to_non_nullable
as String,vodPlayUrl: null == vodPlayUrl ? _self.vodPlayUrl : vodPlayUrl // ignore: cast_nullable_to_non_nullable
as String,vodDownFrom: null == vodDownFrom ? _self.vodDownFrom : vodDownFrom // ignore: cast_nullable_to_non_nullable
as String,vodDownServer: null == vodDownServer ? _self.vodDownServer : vodDownServer // ignore: cast_nullable_to_non_nullable
as String,vodDownNote: null == vodDownNote ? _self.vodDownNote : vodDownNote // ignore: cast_nullable_to_non_nullable
as String,vodDownUrl: null == vodDownUrl ? _self.vodDownUrl : vodDownUrl // ignore: cast_nullable_to_non_nullable
as String,vodJumpurl: null == vodJumpurl ? _self.vodJumpurl : vodJumpurl // ignore: cast_nullable_to_non_nullable
as String,vodPwd: null == vodPwd ? _self.vodPwd : vodPwd // ignore: cast_nullable_to_non_nullable
as String,vodPwdUrl: null == vodPwdUrl ? _self.vodPwdUrl : vodPwdUrl // ignore: cast_nullable_to_non_nullable
as String,vodPwdPlay: null == vodPwdPlay ? _self.vodPwdPlay : vodPwdPlay // ignore: cast_nullable_to_non_nullable
as String,vodPwdPlayUrl: null == vodPwdPlayUrl ? _self.vodPwdPlayUrl : vodPwdPlayUrl // ignore: cast_nullable_to_non_nullable
as String,vodPwdDown: null == vodPwdDown ? _self.vodPwdDown : vodPwdDown // ignore: cast_nullable_to_non_nullable
as String,vodPwdDownUrl: null == vodPwdDownUrl ? _self.vodPwdDownUrl : vodPwdDownUrl // ignore: cast_nullable_to_non_nullable
as String,vodRelVod: null == vodRelVod ? _self.vodRelVod : vodRelVod // ignore: cast_nullable_to_non_nullable
as String,vodRelArt: null == vodRelArt ? _self.vodRelArt : vodRelArt // ignore: cast_nullable_to_non_nullable
as String,vodTag: null == vodTag ? _self.vodTag : vodTag // ignore: cast_nullable_to_non_nullable
as String,vodLetter: null == vodLetter ? _self.vodLetter : vodLetter // ignore: cast_nullable_to_non_nullable
as String,vodColor: null == vodColor ? _self.vodColor : vodColor // ignore: cast_nullable_to_non_nullable
as String,vodAuthor: null == vodAuthor ? _self.vodAuthor : vodAuthor // ignore: cast_nullable_to_non_nullable
as String,vodBehind: null == vodBehind ? _self.vodBehind : vodBehind // ignore: cast_nullable_to_non_nullable
as String,vodState: null == vodState ? _self.vodState : vodState // ignore: cast_nullable_to_non_nullable
as String,vodVersion: null == vodVersion ? _self.vodVersion : vodVersion // ignore: cast_nullable_to_non_nullable
as String,vodWeekday: null == vodWeekday ? _self.vodWeekday : vodWeekday // ignore: cast_nullable_to_non_nullable
as String,vodTv: null == vodTv ? _self.vodTv : vodTv // ignore: cast_nullable_to_non_nullable
as String,vodTpl: null == vodTpl ? _self.vodTpl : vodTpl // ignore: cast_nullable_to_non_nullable
as String,vodTplPlay: null == vodTplPlay ? _self.vodTplPlay : vodTplPlay // ignore: cast_nullable_to_non_nullable
as String,vodTplDown: null == vodTplDown ? _self.vodTplDown : vodTplDown // ignore: cast_nullable_to_non_nullable
as String,vodReurl: null == vodReurl ? _self.vodReurl : vodReurl // ignore: cast_nullable_to_non_nullable
as String,vodTime: null == vodTime ? _self.vodTime : vodTime // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodTimeAdd: null == vodTimeAdd ? _self.vodTimeAdd : vodTimeAdd // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodTimeHits: null == vodTimeHits ? _self.vodTimeHits : vodTimeHits // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodTimeMake: null == vodTimeMake ? _self.vodTimeMake : vodTimeMake // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodUrlWithPlayer: freezed == vodUrlWithPlayer ? _self.vodUrlWithPlayer : vodUrlWithPlayer // ignore: cast_nullable_to_non_nullable
as List<VodPlayer>?,
  ));
}

}


/// Adds pattern-matching-related methods to [VodInfo].
extension VodInfoPatterns on VodInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VodInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VodInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VodInfo value)  $default,){
final _that = this;
switch (_that) {
case _VodInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VodInfo value)?  $default,){
final _that = this;
switch (_that) {
case _VodInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int groupId,  int typeId,  int typeId1,  PlatformInt64 vodId,  String vodName,  String vodEn,  String vodSub,  String vodActor,  String vodDirector,  String vodWriter,  String vodArea,  String vodLang,  String vodYear,  String vodClass,  String vodPic,  String vodPicThumb,  String vodPicSlide,  String? vodPicScreenshot,  String vodBlurb,  String vodContent,  String vodRemarks,  String vodPubdate,  int vodTotal,  String vodSerial,  String vodDuration,  String vodScore,  int vodScoreAll,  int vodScoreNum,  PlatformInt64 vodDoubanId,  String vodDoubanScore,  PlatformInt64 vodHits,  PlatformInt64 vodHitsDay,  PlatformInt64 vodHitsWeek,  PlatformInt64 vodHitsMonth,  PlatformInt64 vodUp,  PlatformInt64 vodDown,  int vodStatus,  int vodIsend,  int vodLock,  int vodLevel,  int vodCopyright,  int vodPoints,  int vodPointsPlay,  int vodPointsDown,  int vodTrysee,  int vodPlot,  String vodPlotName,  String vodPlotDetail,  String vodPlayFrom,  String vodPlayServer,  String vodPlayNote,  String vodPlayUrl,  String vodDownFrom,  String vodDownServer,  String vodDownNote,  String vodDownUrl,  String vodJumpurl,  String vodPwd,  String vodPwdUrl,  String vodPwdPlay,  String vodPwdPlayUrl,  String vodPwdDown,  String vodPwdDownUrl,  String vodRelVod,  String vodRelArt,  String vodTag,  String vodLetter,  String vodColor,  String vodAuthor,  String vodBehind,  String vodState,  String vodVersion,  String vodWeekday,  String vodTv,  String vodTpl,  String vodTplPlay,  String vodTplDown,  String vodReurl,  PlatformInt64 vodTime,  PlatformInt64 vodTimeAdd,  PlatformInt64 vodTimeHits,  PlatformInt64 vodTimeMake,  List<VodPlayer>? vodUrlWithPlayer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VodInfo() when $default != null:
return $default(_that.groupId,_that.typeId,_that.typeId1,_that.vodId,_that.vodName,_that.vodEn,_that.vodSub,_that.vodActor,_that.vodDirector,_that.vodWriter,_that.vodArea,_that.vodLang,_that.vodYear,_that.vodClass,_that.vodPic,_that.vodPicThumb,_that.vodPicSlide,_that.vodPicScreenshot,_that.vodBlurb,_that.vodContent,_that.vodRemarks,_that.vodPubdate,_that.vodTotal,_that.vodSerial,_that.vodDuration,_that.vodScore,_that.vodScoreAll,_that.vodScoreNum,_that.vodDoubanId,_that.vodDoubanScore,_that.vodHits,_that.vodHitsDay,_that.vodHitsWeek,_that.vodHitsMonth,_that.vodUp,_that.vodDown,_that.vodStatus,_that.vodIsend,_that.vodLock,_that.vodLevel,_that.vodCopyright,_that.vodPoints,_that.vodPointsPlay,_that.vodPointsDown,_that.vodTrysee,_that.vodPlot,_that.vodPlotName,_that.vodPlotDetail,_that.vodPlayFrom,_that.vodPlayServer,_that.vodPlayNote,_that.vodPlayUrl,_that.vodDownFrom,_that.vodDownServer,_that.vodDownNote,_that.vodDownUrl,_that.vodJumpurl,_that.vodPwd,_that.vodPwdUrl,_that.vodPwdPlay,_that.vodPwdPlayUrl,_that.vodPwdDown,_that.vodPwdDownUrl,_that.vodRelVod,_that.vodRelArt,_that.vodTag,_that.vodLetter,_that.vodColor,_that.vodAuthor,_that.vodBehind,_that.vodState,_that.vodVersion,_that.vodWeekday,_that.vodTv,_that.vodTpl,_that.vodTplPlay,_that.vodTplDown,_that.vodReurl,_that.vodTime,_that.vodTimeAdd,_that.vodTimeHits,_that.vodTimeMake,_that.vodUrlWithPlayer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int groupId,  int typeId,  int typeId1,  PlatformInt64 vodId,  String vodName,  String vodEn,  String vodSub,  String vodActor,  String vodDirector,  String vodWriter,  String vodArea,  String vodLang,  String vodYear,  String vodClass,  String vodPic,  String vodPicThumb,  String vodPicSlide,  String? vodPicScreenshot,  String vodBlurb,  String vodContent,  String vodRemarks,  String vodPubdate,  int vodTotal,  String vodSerial,  String vodDuration,  String vodScore,  int vodScoreAll,  int vodScoreNum,  PlatformInt64 vodDoubanId,  String vodDoubanScore,  PlatformInt64 vodHits,  PlatformInt64 vodHitsDay,  PlatformInt64 vodHitsWeek,  PlatformInt64 vodHitsMonth,  PlatformInt64 vodUp,  PlatformInt64 vodDown,  int vodStatus,  int vodIsend,  int vodLock,  int vodLevel,  int vodCopyright,  int vodPoints,  int vodPointsPlay,  int vodPointsDown,  int vodTrysee,  int vodPlot,  String vodPlotName,  String vodPlotDetail,  String vodPlayFrom,  String vodPlayServer,  String vodPlayNote,  String vodPlayUrl,  String vodDownFrom,  String vodDownServer,  String vodDownNote,  String vodDownUrl,  String vodJumpurl,  String vodPwd,  String vodPwdUrl,  String vodPwdPlay,  String vodPwdPlayUrl,  String vodPwdDown,  String vodPwdDownUrl,  String vodRelVod,  String vodRelArt,  String vodTag,  String vodLetter,  String vodColor,  String vodAuthor,  String vodBehind,  String vodState,  String vodVersion,  String vodWeekday,  String vodTv,  String vodTpl,  String vodTplPlay,  String vodTplDown,  String vodReurl,  PlatformInt64 vodTime,  PlatformInt64 vodTimeAdd,  PlatformInt64 vodTimeHits,  PlatformInt64 vodTimeMake,  List<VodPlayer>? vodUrlWithPlayer)  $default,) {final _that = this;
switch (_that) {
case _VodInfo():
return $default(_that.groupId,_that.typeId,_that.typeId1,_that.vodId,_that.vodName,_that.vodEn,_that.vodSub,_that.vodActor,_that.vodDirector,_that.vodWriter,_that.vodArea,_that.vodLang,_that.vodYear,_that.vodClass,_that.vodPic,_that.vodPicThumb,_that.vodPicSlide,_that.vodPicScreenshot,_that.vodBlurb,_that.vodContent,_that.vodRemarks,_that.vodPubdate,_that.vodTotal,_that.vodSerial,_that.vodDuration,_that.vodScore,_that.vodScoreAll,_that.vodScoreNum,_that.vodDoubanId,_that.vodDoubanScore,_that.vodHits,_that.vodHitsDay,_that.vodHitsWeek,_that.vodHitsMonth,_that.vodUp,_that.vodDown,_that.vodStatus,_that.vodIsend,_that.vodLock,_that.vodLevel,_that.vodCopyright,_that.vodPoints,_that.vodPointsPlay,_that.vodPointsDown,_that.vodTrysee,_that.vodPlot,_that.vodPlotName,_that.vodPlotDetail,_that.vodPlayFrom,_that.vodPlayServer,_that.vodPlayNote,_that.vodPlayUrl,_that.vodDownFrom,_that.vodDownServer,_that.vodDownNote,_that.vodDownUrl,_that.vodJumpurl,_that.vodPwd,_that.vodPwdUrl,_that.vodPwdPlay,_that.vodPwdPlayUrl,_that.vodPwdDown,_that.vodPwdDownUrl,_that.vodRelVod,_that.vodRelArt,_that.vodTag,_that.vodLetter,_that.vodColor,_that.vodAuthor,_that.vodBehind,_that.vodState,_that.vodVersion,_that.vodWeekday,_that.vodTv,_that.vodTpl,_that.vodTplPlay,_that.vodTplDown,_that.vodReurl,_that.vodTime,_that.vodTimeAdd,_that.vodTimeHits,_that.vodTimeMake,_that.vodUrlWithPlayer);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int groupId,  int typeId,  int typeId1,  PlatformInt64 vodId,  String vodName,  String vodEn,  String vodSub,  String vodActor,  String vodDirector,  String vodWriter,  String vodArea,  String vodLang,  String vodYear,  String vodClass,  String vodPic,  String vodPicThumb,  String vodPicSlide,  String? vodPicScreenshot,  String vodBlurb,  String vodContent,  String vodRemarks,  String vodPubdate,  int vodTotal,  String vodSerial,  String vodDuration,  String vodScore,  int vodScoreAll,  int vodScoreNum,  PlatformInt64 vodDoubanId,  String vodDoubanScore,  PlatformInt64 vodHits,  PlatformInt64 vodHitsDay,  PlatformInt64 vodHitsWeek,  PlatformInt64 vodHitsMonth,  PlatformInt64 vodUp,  PlatformInt64 vodDown,  int vodStatus,  int vodIsend,  int vodLock,  int vodLevel,  int vodCopyright,  int vodPoints,  int vodPointsPlay,  int vodPointsDown,  int vodTrysee,  int vodPlot,  String vodPlotName,  String vodPlotDetail,  String vodPlayFrom,  String vodPlayServer,  String vodPlayNote,  String vodPlayUrl,  String vodDownFrom,  String vodDownServer,  String vodDownNote,  String vodDownUrl,  String vodJumpurl,  String vodPwd,  String vodPwdUrl,  String vodPwdPlay,  String vodPwdPlayUrl,  String vodPwdDown,  String vodPwdDownUrl,  String vodRelVod,  String vodRelArt,  String vodTag,  String vodLetter,  String vodColor,  String vodAuthor,  String vodBehind,  String vodState,  String vodVersion,  String vodWeekday,  String vodTv,  String vodTpl,  String vodTplPlay,  String vodTplDown,  String vodReurl,  PlatformInt64 vodTime,  PlatformInt64 vodTimeAdd,  PlatformInt64 vodTimeHits,  PlatformInt64 vodTimeMake,  List<VodPlayer>? vodUrlWithPlayer)?  $default,) {final _that = this;
switch (_that) {
case _VodInfo() when $default != null:
return $default(_that.groupId,_that.typeId,_that.typeId1,_that.vodId,_that.vodName,_that.vodEn,_that.vodSub,_that.vodActor,_that.vodDirector,_that.vodWriter,_that.vodArea,_that.vodLang,_that.vodYear,_that.vodClass,_that.vodPic,_that.vodPicThumb,_that.vodPicSlide,_that.vodPicScreenshot,_that.vodBlurb,_that.vodContent,_that.vodRemarks,_that.vodPubdate,_that.vodTotal,_that.vodSerial,_that.vodDuration,_that.vodScore,_that.vodScoreAll,_that.vodScoreNum,_that.vodDoubanId,_that.vodDoubanScore,_that.vodHits,_that.vodHitsDay,_that.vodHitsWeek,_that.vodHitsMonth,_that.vodUp,_that.vodDown,_that.vodStatus,_that.vodIsend,_that.vodLock,_that.vodLevel,_that.vodCopyright,_that.vodPoints,_that.vodPointsPlay,_that.vodPointsDown,_that.vodTrysee,_that.vodPlot,_that.vodPlotName,_that.vodPlotDetail,_that.vodPlayFrom,_that.vodPlayServer,_that.vodPlayNote,_that.vodPlayUrl,_that.vodDownFrom,_that.vodDownServer,_that.vodDownNote,_that.vodDownUrl,_that.vodJumpurl,_that.vodPwd,_that.vodPwdUrl,_that.vodPwdPlay,_that.vodPwdPlayUrl,_that.vodPwdDown,_that.vodPwdDownUrl,_that.vodRelVod,_that.vodRelArt,_that.vodTag,_that.vodLetter,_that.vodColor,_that.vodAuthor,_that.vodBehind,_that.vodState,_that.vodVersion,_that.vodWeekday,_that.vodTv,_that.vodTpl,_that.vodTplPlay,_that.vodTplDown,_that.vodReurl,_that.vodTime,_that.vodTimeAdd,_that.vodTimeHits,_that.vodTimeMake,_that.vodUrlWithPlayer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VodInfo implements VodInfo {
  const _VodInfo({required this.groupId, required this.typeId, required this.typeId1, required this.vodId, required this.vodName, required this.vodEn, required this.vodSub, required this.vodActor, required this.vodDirector, required this.vodWriter, required this.vodArea, required this.vodLang, required this.vodYear, required this.vodClass, required this.vodPic, required this.vodPicThumb, required this.vodPicSlide, this.vodPicScreenshot, required this.vodBlurb, required this.vodContent, required this.vodRemarks, required this.vodPubdate, required this.vodTotal, required this.vodSerial, required this.vodDuration, required this.vodScore, required this.vodScoreAll, required this.vodScoreNum, required this.vodDoubanId, required this.vodDoubanScore, required this.vodHits, required this.vodHitsDay, required this.vodHitsWeek, required this.vodHitsMonth, required this.vodUp, required this.vodDown, required this.vodStatus, required this.vodIsend, required this.vodLock, required this.vodLevel, required this.vodCopyright, required this.vodPoints, required this.vodPointsPlay, required this.vodPointsDown, required this.vodTrysee, required this.vodPlot, required this.vodPlotName, required this.vodPlotDetail, required this.vodPlayFrom, required this.vodPlayServer, required this.vodPlayNote, required this.vodPlayUrl, required this.vodDownFrom, required this.vodDownServer, required this.vodDownNote, required this.vodDownUrl, required this.vodJumpurl, required this.vodPwd, required this.vodPwdUrl, required this.vodPwdPlay, required this.vodPwdPlayUrl, required this.vodPwdDown, required this.vodPwdDownUrl, required this.vodRelVod, required this.vodRelArt, required this.vodTag, required this.vodLetter, required this.vodColor, required this.vodAuthor, required this.vodBehind, required this.vodState, required this.vodVersion, required this.vodWeekday, required this.vodTv, required this.vodTpl, required this.vodTplPlay, required this.vodTplDown, required this.vodReurl, required this.vodTime, required this.vodTimeAdd, required this.vodTimeHits, required this.vodTimeMake, final  List<VodPlayer>? vodUrlWithPlayer}): _vodUrlWithPlayer = vodUrlWithPlayer;
  factory _VodInfo.fromJson(Map<String, dynamic> json) => _$VodInfoFromJson(json);

@override final  int groupId;
@override final  int typeId;
@override final  int typeId1;
@override final  PlatformInt64 vodId;
@override final  String vodName;
@override final  String vodEn;
@override final  String vodSub;
@override final  String vodActor;
@override final  String vodDirector;
@override final  String vodWriter;
@override final  String vodArea;
@override final  String vodLang;
@override final  String vodYear;
@override final  String vodClass;
@override final  String vodPic;
@override final  String vodPicThumb;
@override final  String vodPicSlide;
@override final  String? vodPicScreenshot;
@override final  String vodBlurb;
@override final  String vodContent;
@override final  String vodRemarks;
@override final  String vodPubdate;
@override final  int vodTotal;
@override final  String vodSerial;
@override final  String vodDuration;
@override final  String vodScore;
@override final  int vodScoreAll;
@override final  int vodScoreNum;
@override final  PlatformInt64 vodDoubanId;
@override final  String vodDoubanScore;
@override final  PlatformInt64 vodHits;
@override final  PlatformInt64 vodHitsDay;
@override final  PlatformInt64 vodHitsWeek;
@override final  PlatformInt64 vodHitsMonth;
@override final  PlatformInt64 vodUp;
@override final  PlatformInt64 vodDown;
@override final  int vodStatus;
@override final  int vodIsend;
@override final  int vodLock;
@override final  int vodLevel;
@override final  int vodCopyright;
@override final  int vodPoints;
@override final  int vodPointsPlay;
@override final  int vodPointsDown;
@override final  int vodTrysee;
@override final  int vodPlot;
@override final  String vodPlotName;
@override final  String vodPlotDetail;
@override final  String vodPlayFrom;
@override final  String vodPlayServer;
@override final  String vodPlayNote;
@override final  String vodPlayUrl;
@override final  String vodDownFrom;
@override final  String vodDownServer;
@override final  String vodDownNote;
@override final  String vodDownUrl;
@override final  String vodJumpurl;
@override final  String vodPwd;
@override final  String vodPwdUrl;
@override final  String vodPwdPlay;
@override final  String vodPwdPlayUrl;
@override final  String vodPwdDown;
@override final  String vodPwdDownUrl;
@override final  String vodRelVod;
@override final  String vodRelArt;
@override final  String vodTag;
@override final  String vodLetter;
@override final  String vodColor;
@override final  String vodAuthor;
@override final  String vodBehind;
@override final  String vodState;
@override final  String vodVersion;
@override final  String vodWeekday;
@override final  String vodTv;
@override final  String vodTpl;
@override final  String vodTplPlay;
@override final  String vodTplDown;
@override final  String vodReurl;
@override final  PlatformInt64 vodTime;
@override final  PlatformInt64 vodTimeAdd;
@override final  PlatformInt64 vodTimeHits;
@override final  PlatformInt64 vodTimeMake;
 final  List<VodPlayer>? _vodUrlWithPlayer;
@override List<VodPlayer>? get vodUrlWithPlayer {
  final value = _vodUrlWithPlayer;
  if (value == null) return null;
  if (_vodUrlWithPlayer is EqualUnmodifiableListView) return _vodUrlWithPlayer;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of VodInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VodInfoCopyWith<_VodInfo> get copyWith => __$VodInfoCopyWithImpl<_VodInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VodInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VodInfo&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.typeId, typeId) || other.typeId == typeId)&&(identical(other.typeId1, typeId1) || other.typeId1 == typeId1)&&(identical(other.vodId, vodId) || other.vodId == vodId)&&(identical(other.vodName, vodName) || other.vodName == vodName)&&(identical(other.vodEn, vodEn) || other.vodEn == vodEn)&&(identical(other.vodSub, vodSub) || other.vodSub == vodSub)&&(identical(other.vodActor, vodActor) || other.vodActor == vodActor)&&(identical(other.vodDirector, vodDirector) || other.vodDirector == vodDirector)&&(identical(other.vodWriter, vodWriter) || other.vodWriter == vodWriter)&&(identical(other.vodArea, vodArea) || other.vodArea == vodArea)&&(identical(other.vodLang, vodLang) || other.vodLang == vodLang)&&(identical(other.vodYear, vodYear) || other.vodYear == vodYear)&&(identical(other.vodClass, vodClass) || other.vodClass == vodClass)&&(identical(other.vodPic, vodPic) || other.vodPic == vodPic)&&(identical(other.vodPicThumb, vodPicThumb) || other.vodPicThumb == vodPicThumb)&&(identical(other.vodPicSlide, vodPicSlide) || other.vodPicSlide == vodPicSlide)&&(identical(other.vodPicScreenshot, vodPicScreenshot) || other.vodPicScreenshot == vodPicScreenshot)&&(identical(other.vodBlurb, vodBlurb) || other.vodBlurb == vodBlurb)&&(identical(other.vodContent, vodContent) || other.vodContent == vodContent)&&(identical(other.vodRemarks, vodRemarks) || other.vodRemarks == vodRemarks)&&(identical(other.vodPubdate, vodPubdate) || other.vodPubdate == vodPubdate)&&(identical(other.vodTotal, vodTotal) || other.vodTotal == vodTotal)&&(identical(other.vodSerial, vodSerial) || other.vodSerial == vodSerial)&&(identical(other.vodDuration, vodDuration) || other.vodDuration == vodDuration)&&(identical(other.vodScore, vodScore) || other.vodScore == vodScore)&&(identical(other.vodScoreAll, vodScoreAll) || other.vodScoreAll == vodScoreAll)&&(identical(other.vodScoreNum, vodScoreNum) || other.vodScoreNum == vodScoreNum)&&(identical(other.vodDoubanId, vodDoubanId) || other.vodDoubanId == vodDoubanId)&&(identical(other.vodDoubanScore, vodDoubanScore) || other.vodDoubanScore == vodDoubanScore)&&(identical(other.vodHits, vodHits) || other.vodHits == vodHits)&&(identical(other.vodHitsDay, vodHitsDay) || other.vodHitsDay == vodHitsDay)&&(identical(other.vodHitsWeek, vodHitsWeek) || other.vodHitsWeek == vodHitsWeek)&&(identical(other.vodHitsMonth, vodHitsMonth) || other.vodHitsMonth == vodHitsMonth)&&(identical(other.vodUp, vodUp) || other.vodUp == vodUp)&&(identical(other.vodDown, vodDown) || other.vodDown == vodDown)&&(identical(other.vodStatus, vodStatus) || other.vodStatus == vodStatus)&&(identical(other.vodIsend, vodIsend) || other.vodIsend == vodIsend)&&(identical(other.vodLock, vodLock) || other.vodLock == vodLock)&&(identical(other.vodLevel, vodLevel) || other.vodLevel == vodLevel)&&(identical(other.vodCopyright, vodCopyright) || other.vodCopyright == vodCopyright)&&(identical(other.vodPoints, vodPoints) || other.vodPoints == vodPoints)&&(identical(other.vodPointsPlay, vodPointsPlay) || other.vodPointsPlay == vodPointsPlay)&&(identical(other.vodPointsDown, vodPointsDown) || other.vodPointsDown == vodPointsDown)&&(identical(other.vodTrysee, vodTrysee) || other.vodTrysee == vodTrysee)&&(identical(other.vodPlot, vodPlot) || other.vodPlot == vodPlot)&&(identical(other.vodPlotName, vodPlotName) || other.vodPlotName == vodPlotName)&&(identical(other.vodPlotDetail, vodPlotDetail) || other.vodPlotDetail == vodPlotDetail)&&(identical(other.vodPlayFrom, vodPlayFrom) || other.vodPlayFrom == vodPlayFrom)&&(identical(other.vodPlayServer, vodPlayServer) || other.vodPlayServer == vodPlayServer)&&(identical(other.vodPlayNote, vodPlayNote) || other.vodPlayNote == vodPlayNote)&&(identical(other.vodPlayUrl, vodPlayUrl) || other.vodPlayUrl == vodPlayUrl)&&(identical(other.vodDownFrom, vodDownFrom) || other.vodDownFrom == vodDownFrom)&&(identical(other.vodDownServer, vodDownServer) || other.vodDownServer == vodDownServer)&&(identical(other.vodDownNote, vodDownNote) || other.vodDownNote == vodDownNote)&&(identical(other.vodDownUrl, vodDownUrl) || other.vodDownUrl == vodDownUrl)&&(identical(other.vodJumpurl, vodJumpurl) || other.vodJumpurl == vodJumpurl)&&(identical(other.vodPwd, vodPwd) || other.vodPwd == vodPwd)&&(identical(other.vodPwdUrl, vodPwdUrl) || other.vodPwdUrl == vodPwdUrl)&&(identical(other.vodPwdPlay, vodPwdPlay) || other.vodPwdPlay == vodPwdPlay)&&(identical(other.vodPwdPlayUrl, vodPwdPlayUrl) || other.vodPwdPlayUrl == vodPwdPlayUrl)&&(identical(other.vodPwdDown, vodPwdDown) || other.vodPwdDown == vodPwdDown)&&(identical(other.vodPwdDownUrl, vodPwdDownUrl) || other.vodPwdDownUrl == vodPwdDownUrl)&&(identical(other.vodRelVod, vodRelVod) || other.vodRelVod == vodRelVod)&&(identical(other.vodRelArt, vodRelArt) || other.vodRelArt == vodRelArt)&&(identical(other.vodTag, vodTag) || other.vodTag == vodTag)&&(identical(other.vodLetter, vodLetter) || other.vodLetter == vodLetter)&&(identical(other.vodColor, vodColor) || other.vodColor == vodColor)&&(identical(other.vodAuthor, vodAuthor) || other.vodAuthor == vodAuthor)&&(identical(other.vodBehind, vodBehind) || other.vodBehind == vodBehind)&&(identical(other.vodState, vodState) || other.vodState == vodState)&&(identical(other.vodVersion, vodVersion) || other.vodVersion == vodVersion)&&(identical(other.vodWeekday, vodWeekday) || other.vodWeekday == vodWeekday)&&(identical(other.vodTv, vodTv) || other.vodTv == vodTv)&&(identical(other.vodTpl, vodTpl) || other.vodTpl == vodTpl)&&(identical(other.vodTplPlay, vodTplPlay) || other.vodTplPlay == vodTplPlay)&&(identical(other.vodTplDown, vodTplDown) || other.vodTplDown == vodTplDown)&&(identical(other.vodReurl, vodReurl) || other.vodReurl == vodReurl)&&(identical(other.vodTime, vodTime) || other.vodTime == vodTime)&&(identical(other.vodTimeAdd, vodTimeAdd) || other.vodTimeAdd == vodTimeAdd)&&(identical(other.vodTimeHits, vodTimeHits) || other.vodTimeHits == vodTimeHits)&&(identical(other.vodTimeMake, vodTimeMake) || other.vodTimeMake == vodTimeMake)&&const DeepCollectionEquality().equals(other._vodUrlWithPlayer, _vodUrlWithPlayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,groupId,typeId,typeId1,vodId,vodName,vodEn,vodSub,vodActor,vodDirector,vodWriter,vodArea,vodLang,vodYear,vodClass,vodPic,vodPicThumb,vodPicSlide,vodPicScreenshot,vodBlurb,vodContent,vodRemarks,vodPubdate,vodTotal,vodSerial,vodDuration,vodScore,vodScoreAll,vodScoreNum,vodDoubanId,vodDoubanScore,vodHits,vodHitsDay,vodHitsWeek,vodHitsMonth,vodUp,vodDown,vodStatus,vodIsend,vodLock,vodLevel,vodCopyright,vodPoints,vodPointsPlay,vodPointsDown,vodTrysee,vodPlot,vodPlotName,vodPlotDetail,vodPlayFrom,vodPlayServer,vodPlayNote,vodPlayUrl,vodDownFrom,vodDownServer,vodDownNote,vodDownUrl,vodJumpurl,vodPwd,vodPwdUrl,vodPwdPlay,vodPwdPlayUrl,vodPwdDown,vodPwdDownUrl,vodRelVod,vodRelArt,vodTag,vodLetter,vodColor,vodAuthor,vodBehind,vodState,vodVersion,vodWeekday,vodTv,vodTpl,vodTplPlay,vodTplDown,vodReurl,vodTime,vodTimeAdd,vodTimeHits,vodTimeMake,const DeepCollectionEquality().hash(_vodUrlWithPlayer)]);

@override
String toString() {
  return 'VodInfo(groupId: $groupId, typeId: $typeId, typeId1: $typeId1, vodId: $vodId, vodName: $vodName, vodEn: $vodEn, vodSub: $vodSub, vodActor: $vodActor, vodDirector: $vodDirector, vodWriter: $vodWriter, vodArea: $vodArea, vodLang: $vodLang, vodYear: $vodYear, vodClass: $vodClass, vodPic: $vodPic, vodPicThumb: $vodPicThumb, vodPicSlide: $vodPicSlide, vodPicScreenshot: $vodPicScreenshot, vodBlurb: $vodBlurb, vodContent: $vodContent, vodRemarks: $vodRemarks, vodPubdate: $vodPubdate, vodTotal: $vodTotal, vodSerial: $vodSerial, vodDuration: $vodDuration, vodScore: $vodScore, vodScoreAll: $vodScoreAll, vodScoreNum: $vodScoreNum, vodDoubanId: $vodDoubanId, vodDoubanScore: $vodDoubanScore, vodHits: $vodHits, vodHitsDay: $vodHitsDay, vodHitsWeek: $vodHitsWeek, vodHitsMonth: $vodHitsMonth, vodUp: $vodUp, vodDown: $vodDown, vodStatus: $vodStatus, vodIsend: $vodIsend, vodLock: $vodLock, vodLevel: $vodLevel, vodCopyright: $vodCopyright, vodPoints: $vodPoints, vodPointsPlay: $vodPointsPlay, vodPointsDown: $vodPointsDown, vodTrysee: $vodTrysee, vodPlot: $vodPlot, vodPlotName: $vodPlotName, vodPlotDetail: $vodPlotDetail, vodPlayFrom: $vodPlayFrom, vodPlayServer: $vodPlayServer, vodPlayNote: $vodPlayNote, vodPlayUrl: $vodPlayUrl, vodDownFrom: $vodDownFrom, vodDownServer: $vodDownServer, vodDownNote: $vodDownNote, vodDownUrl: $vodDownUrl, vodJumpurl: $vodJumpurl, vodPwd: $vodPwd, vodPwdUrl: $vodPwdUrl, vodPwdPlay: $vodPwdPlay, vodPwdPlayUrl: $vodPwdPlayUrl, vodPwdDown: $vodPwdDown, vodPwdDownUrl: $vodPwdDownUrl, vodRelVod: $vodRelVod, vodRelArt: $vodRelArt, vodTag: $vodTag, vodLetter: $vodLetter, vodColor: $vodColor, vodAuthor: $vodAuthor, vodBehind: $vodBehind, vodState: $vodState, vodVersion: $vodVersion, vodWeekday: $vodWeekday, vodTv: $vodTv, vodTpl: $vodTpl, vodTplPlay: $vodTplPlay, vodTplDown: $vodTplDown, vodReurl: $vodReurl, vodTime: $vodTime, vodTimeAdd: $vodTimeAdd, vodTimeHits: $vodTimeHits, vodTimeMake: $vodTimeMake, vodUrlWithPlayer: $vodUrlWithPlayer)';
}


}

/// @nodoc
abstract mixin class _$VodInfoCopyWith<$Res> implements $VodInfoCopyWith<$Res> {
  factory _$VodInfoCopyWith(_VodInfo value, $Res Function(_VodInfo) _then) = __$VodInfoCopyWithImpl;
@override @useResult
$Res call({
 int groupId, int typeId, int typeId1, PlatformInt64 vodId, String vodName, String vodEn, String vodSub, String vodActor, String vodDirector, String vodWriter, String vodArea, String vodLang, String vodYear, String vodClass, String vodPic, String vodPicThumb, String vodPicSlide, String? vodPicScreenshot, String vodBlurb, String vodContent, String vodRemarks, String vodPubdate, int vodTotal, String vodSerial, String vodDuration, String vodScore, int vodScoreAll, int vodScoreNum, PlatformInt64 vodDoubanId, String vodDoubanScore, PlatformInt64 vodHits, PlatformInt64 vodHitsDay, PlatformInt64 vodHitsWeek, PlatformInt64 vodHitsMonth, PlatformInt64 vodUp, PlatformInt64 vodDown, int vodStatus, int vodIsend, int vodLock, int vodLevel, int vodCopyright, int vodPoints, int vodPointsPlay, int vodPointsDown, int vodTrysee, int vodPlot, String vodPlotName, String vodPlotDetail, String vodPlayFrom, String vodPlayServer, String vodPlayNote, String vodPlayUrl, String vodDownFrom, String vodDownServer, String vodDownNote, String vodDownUrl, String vodJumpurl, String vodPwd, String vodPwdUrl, String vodPwdPlay, String vodPwdPlayUrl, String vodPwdDown, String vodPwdDownUrl, String vodRelVod, String vodRelArt, String vodTag, String vodLetter, String vodColor, String vodAuthor, String vodBehind, String vodState, String vodVersion, String vodWeekday, String vodTv, String vodTpl, String vodTplPlay, String vodTplDown, String vodReurl, PlatformInt64 vodTime, PlatformInt64 vodTimeAdd, PlatformInt64 vodTimeHits, PlatformInt64 vodTimeMake, List<VodPlayer>? vodUrlWithPlayer
});




}
/// @nodoc
class __$VodInfoCopyWithImpl<$Res>
    implements _$VodInfoCopyWith<$Res> {
  __$VodInfoCopyWithImpl(this._self, this._then);

  final _VodInfo _self;
  final $Res Function(_VodInfo) _then;

/// Create a copy of VodInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? typeId = null,Object? typeId1 = null,Object? vodId = null,Object? vodName = null,Object? vodEn = null,Object? vodSub = null,Object? vodActor = null,Object? vodDirector = null,Object? vodWriter = null,Object? vodArea = null,Object? vodLang = null,Object? vodYear = null,Object? vodClass = null,Object? vodPic = null,Object? vodPicThumb = null,Object? vodPicSlide = null,Object? vodPicScreenshot = freezed,Object? vodBlurb = null,Object? vodContent = null,Object? vodRemarks = null,Object? vodPubdate = null,Object? vodTotal = null,Object? vodSerial = null,Object? vodDuration = null,Object? vodScore = null,Object? vodScoreAll = null,Object? vodScoreNum = null,Object? vodDoubanId = null,Object? vodDoubanScore = null,Object? vodHits = null,Object? vodHitsDay = null,Object? vodHitsWeek = null,Object? vodHitsMonth = null,Object? vodUp = null,Object? vodDown = null,Object? vodStatus = null,Object? vodIsend = null,Object? vodLock = null,Object? vodLevel = null,Object? vodCopyright = null,Object? vodPoints = null,Object? vodPointsPlay = null,Object? vodPointsDown = null,Object? vodTrysee = null,Object? vodPlot = null,Object? vodPlotName = null,Object? vodPlotDetail = null,Object? vodPlayFrom = null,Object? vodPlayServer = null,Object? vodPlayNote = null,Object? vodPlayUrl = null,Object? vodDownFrom = null,Object? vodDownServer = null,Object? vodDownNote = null,Object? vodDownUrl = null,Object? vodJumpurl = null,Object? vodPwd = null,Object? vodPwdUrl = null,Object? vodPwdPlay = null,Object? vodPwdPlayUrl = null,Object? vodPwdDown = null,Object? vodPwdDownUrl = null,Object? vodRelVod = null,Object? vodRelArt = null,Object? vodTag = null,Object? vodLetter = null,Object? vodColor = null,Object? vodAuthor = null,Object? vodBehind = null,Object? vodState = null,Object? vodVersion = null,Object? vodWeekday = null,Object? vodTv = null,Object? vodTpl = null,Object? vodTplPlay = null,Object? vodTplDown = null,Object? vodReurl = null,Object? vodTime = null,Object? vodTimeAdd = null,Object? vodTimeHits = null,Object? vodTimeMake = null,Object? vodUrlWithPlayer = freezed,}) {
  return _then(_VodInfo(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,typeId: null == typeId ? _self.typeId : typeId // ignore: cast_nullable_to_non_nullable
as int,typeId1: null == typeId1 ? _self.typeId1 : typeId1 // ignore: cast_nullable_to_non_nullable
as int,vodId: null == vodId ? _self.vodId : vodId // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodName: null == vodName ? _self.vodName : vodName // ignore: cast_nullable_to_non_nullable
as String,vodEn: null == vodEn ? _self.vodEn : vodEn // ignore: cast_nullable_to_non_nullable
as String,vodSub: null == vodSub ? _self.vodSub : vodSub // ignore: cast_nullable_to_non_nullable
as String,vodActor: null == vodActor ? _self.vodActor : vodActor // ignore: cast_nullable_to_non_nullable
as String,vodDirector: null == vodDirector ? _self.vodDirector : vodDirector // ignore: cast_nullable_to_non_nullable
as String,vodWriter: null == vodWriter ? _self.vodWriter : vodWriter // ignore: cast_nullable_to_non_nullable
as String,vodArea: null == vodArea ? _self.vodArea : vodArea // ignore: cast_nullable_to_non_nullable
as String,vodLang: null == vodLang ? _self.vodLang : vodLang // ignore: cast_nullable_to_non_nullable
as String,vodYear: null == vodYear ? _self.vodYear : vodYear // ignore: cast_nullable_to_non_nullable
as String,vodClass: null == vodClass ? _self.vodClass : vodClass // ignore: cast_nullable_to_non_nullable
as String,vodPic: null == vodPic ? _self.vodPic : vodPic // ignore: cast_nullable_to_non_nullable
as String,vodPicThumb: null == vodPicThumb ? _self.vodPicThumb : vodPicThumb // ignore: cast_nullable_to_non_nullable
as String,vodPicSlide: null == vodPicSlide ? _self.vodPicSlide : vodPicSlide // ignore: cast_nullable_to_non_nullable
as String,vodPicScreenshot: freezed == vodPicScreenshot ? _self.vodPicScreenshot : vodPicScreenshot // ignore: cast_nullable_to_non_nullable
as String?,vodBlurb: null == vodBlurb ? _self.vodBlurb : vodBlurb // ignore: cast_nullable_to_non_nullable
as String,vodContent: null == vodContent ? _self.vodContent : vodContent // ignore: cast_nullable_to_non_nullable
as String,vodRemarks: null == vodRemarks ? _self.vodRemarks : vodRemarks // ignore: cast_nullable_to_non_nullable
as String,vodPubdate: null == vodPubdate ? _self.vodPubdate : vodPubdate // ignore: cast_nullable_to_non_nullable
as String,vodTotal: null == vodTotal ? _self.vodTotal : vodTotal // ignore: cast_nullable_to_non_nullable
as int,vodSerial: null == vodSerial ? _self.vodSerial : vodSerial // ignore: cast_nullable_to_non_nullable
as String,vodDuration: null == vodDuration ? _self.vodDuration : vodDuration // ignore: cast_nullable_to_non_nullable
as String,vodScore: null == vodScore ? _self.vodScore : vodScore // ignore: cast_nullable_to_non_nullable
as String,vodScoreAll: null == vodScoreAll ? _self.vodScoreAll : vodScoreAll // ignore: cast_nullable_to_non_nullable
as int,vodScoreNum: null == vodScoreNum ? _self.vodScoreNum : vodScoreNum // ignore: cast_nullable_to_non_nullable
as int,vodDoubanId: null == vodDoubanId ? _self.vodDoubanId : vodDoubanId // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodDoubanScore: null == vodDoubanScore ? _self.vodDoubanScore : vodDoubanScore // ignore: cast_nullable_to_non_nullable
as String,vodHits: null == vodHits ? _self.vodHits : vodHits // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodHitsDay: null == vodHitsDay ? _self.vodHitsDay : vodHitsDay // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodHitsWeek: null == vodHitsWeek ? _self.vodHitsWeek : vodHitsWeek // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodHitsMonth: null == vodHitsMonth ? _self.vodHitsMonth : vodHitsMonth // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodUp: null == vodUp ? _self.vodUp : vodUp // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodDown: null == vodDown ? _self.vodDown : vodDown // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodStatus: null == vodStatus ? _self.vodStatus : vodStatus // ignore: cast_nullable_to_non_nullable
as int,vodIsend: null == vodIsend ? _self.vodIsend : vodIsend // ignore: cast_nullable_to_non_nullable
as int,vodLock: null == vodLock ? _self.vodLock : vodLock // ignore: cast_nullable_to_non_nullable
as int,vodLevel: null == vodLevel ? _self.vodLevel : vodLevel // ignore: cast_nullable_to_non_nullable
as int,vodCopyright: null == vodCopyright ? _self.vodCopyright : vodCopyright // ignore: cast_nullable_to_non_nullable
as int,vodPoints: null == vodPoints ? _self.vodPoints : vodPoints // ignore: cast_nullable_to_non_nullable
as int,vodPointsPlay: null == vodPointsPlay ? _self.vodPointsPlay : vodPointsPlay // ignore: cast_nullable_to_non_nullable
as int,vodPointsDown: null == vodPointsDown ? _self.vodPointsDown : vodPointsDown // ignore: cast_nullable_to_non_nullable
as int,vodTrysee: null == vodTrysee ? _self.vodTrysee : vodTrysee // ignore: cast_nullable_to_non_nullable
as int,vodPlot: null == vodPlot ? _self.vodPlot : vodPlot // ignore: cast_nullable_to_non_nullable
as int,vodPlotName: null == vodPlotName ? _self.vodPlotName : vodPlotName // ignore: cast_nullable_to_non_nullable
as String,vodPlotDetail: null == vodPlotDetail ? _self.vodPlotDetail : vodPlotDetail // ignore: cast_nullable_to_non_nullable
as String,vodPlayFrom: null == vodPlayFrom ? _self.vodPlayFrom : vodPlayFrom // ignore: cast_nullable_to_non_nullable
as String,vodPlayServer: null == vodPlayServer ? _self.vodPlayServer : vodPlayServer // ignore: cast_nullable_to_non_nullable
as String,vodPlayNote: null == vodPlayNote ? _self.vodPlayNote : vodPlayNote // ignore: cast_nullable_to_non_nullable
as String,vodPlayUrl: null == vodPlayUrl ? _self.vodPlayUrl : vodPlayUrl // ignore: cast_nullable_to_non_nullable
as String,vodDownFrom: null == vodDownFrom ? _self.vodDownFrom : vodDownFrom // ignore: cast_nullable_to_non_nullable
as String,vodDownServer: null == vodDownServer ? _self.vodDownServer : vodDownServer // ignore: cast_nullable_to_non_nullable
as String,vodDownNote: null == vodDownNote ? _self.vodDownNote : vodDownNote // ignore: cast_nullable_to_non_nullable
as String,vodDownUrl: null == vodDownUrl ? _self.vodDownUrl : vodDownUrl // ignore: cast_nullable_to_non_nullable
as String,vodJumpurl: null == vodJumpurl ? _self.vodJumpurl : vodJumpurl // ignore: cast_nullable_to_non_nullable
as String,vodPwd: null == vodPwd ? _self.vodPwd : vodPwd // ignore: cast_nullable_to_non_nullable
as String,vodPwdUrl: null == vodPwdUrl ? _self.vodPwdUrl : vodPwdUrl // ignore: cast_nullable_to_non_nullable
as String,vodPwdPlay: null == vodPwdPlay ? _self.vodPwdPlay : vodPwdPlay // ignore: cast_nullable_to_non_nullable
as String,vodPwdPlayUrl: null == vodPwdPlayUrl ? _self.vodPwdPlayUrl : vodPwdPlayUrl // ignore: cast_nullable_to_non_nullable
as String,vodPwdDown: null == vodPwdDown ? _self.vodPwdDown : vodPwdDown // ignore: cast_nullable_to_non_nullable
as String,vodPwdDownUrl: null == vodPwdDownUrl ? _self.vodPwdDownUrl : vodPwdDownUrl // ignore: cast_nullable_to_non_nullable
as String,vodRelVod: null == vodRelVod ? _self.vodRelVod : vodRelVod // ignore: cast_nullable_to_non_nullable
as String,vodRelArt: null == vodRelArt ? _self.vodRelArt : vodRelArt // ignore: cast_nullable_to_non_nullable
as String,vodTag: null == vodTag ? _self.vodTag : vodTag // ignore: cast_nullable_to_non_nullable
as String,vodLetter: null == vodLetter ? _self.vodLetter : vodLetter // ignore: cast_nullable_to_non_nullable
as String,vodColor: null == vodColor ? _self.vodColor : vodColor // ignore: cast_nullable_to_non_nullable
as String,vodAuthor: null == vodAuthor ? _self.vodAuthor : vodAuthor // ignore: cast_nullable_to_non_nullable
as String,vodBehind: null == vodBehind ? _self.vodBehind : vodBehind // ignore: cast_nullable_to_non_nullable
as String,vodState: null == vodState ? _self.vodState : vodState // ignore: cast_nullable_to_non_nullable
as String,vodVersion: null == vodVersion ? _self.vodVersion : vodVersion // ignore: cast_nullable_to_non_nullable
as String,vodWeekday: null == vodWeekday ? _self.vodWeekday : vodWeekday // ignore: cast_nullable_to_non_nullable
as String,vodTv: null == vodTv ? _self.vodTv : vodTv // ignore: cast_nullable_to_non_nullable
as String,vodTpl: null == vodTpl ? _self.vodTpl : vodTpl // ignore: cast_nullable_to_non_nullable
as String,vodTplPlay: null == vodTplPlay ? _self.vodTplPlay : vodTplPlay // ignore: cast_nullable_to_non_nullable
as String,vodTplDown: null == vodTplDown ? _self.vodTplDown : vodTplDown // ignore: cast_nullable_to_non_nullable
as String,vodReurl: null == vodReurl ? _self.vodReurl : vodReurl // ignore: cast_nullable_to_non_nullable
as String,vodTime: null == vodTime ? _self.vodTime : vodTime // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodTimeAdd: null == vodTimeAdd ? _self.vodTimeAdd : vodTimeAdd // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodTimeHits: null == vodTimeHits ? _self.vodTimeHits : vodTimeHits // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodTimeMake: null == vodTimeMake ? _self.vodTimeMake : vodTimeMake // ignore: cast_nullable_to_non_nullable
as PlatformInt64,vodUrlWithPlayer: freezed == vodUrlWithPlayer ? _self._vodUrlWithPlayer : vodUrlWithPlayer // ignore: cast_nullable_to_non_nullable
as List<VodPlayer>?,
  ));
}


}


/// @nodoc
mixin _$VodPlayer {

 String get code; String get name; String get url; String get headers; String get parseApi; String get extraParseApi; bool get parseSecret; String get linkFeatures; String get unLinkFeatures; List<String> get coreParams;
/// Create a copy of VodPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VodPlayerCopyWith<VodPlayer> get copyWith => _$VodPlayerCopyWithImpl<VodPlayer>(this as VodPlayer, _$identity);

  /// Serializes this VodPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VodPlayer&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.headers, headers) || other.headers == headers)&&(identical(other.parseApi, parseApi) || other.parseApi == parseApi)&&(identical(other.extraParseApi, extraParseApi) || other.extraParseApi == extraParseApi)&&(identical(other.parseSecret, parseSecret) || other.parseSecret == parseSecret)&&(identical(other.linkFeatures, linkFeatures) || other.linkFeatures == linkFeatures)&&(identical(other.unLinkFeatures, unLinkFeatures) || other.unLinkFeatures == unLinkFeatures)&&const DeepCollectionEquality().equals(other.coreParams, coreParams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,url,headers,parseApi,extraParseApi,parseSecret,linkFeatures,unLinkFeatures,const DeepCollectionEquality().hash(coreParams));

@override
String toString() {
  return 'VodPlayer(code: $code, name: $name, url: $url, headers: $headers, parseApi: $parseApi, extraParseApi: $extraParseApi, parseSecret: $parseSecret, linkFeatures: $linkFeatures, unLinkFeatures: $unLinkFeatures, coreParams: $coreParams)';
}


}

/// @nodoc
abstract mixin class $VodPlayerCopyWith<$Res>  {
  factory $VodPlayerCopyWith(VodPlayer value, $Res Function(VodPlayer) _then) = _$VodPlayerCopyWithImpl;
@useResult
$Res call({
 String code, String name, String url, String headers, String parseApi, String extraParseApi, bool parseSecret, String linkFeatures, String unLinkFeatures, List<String> coreParams
});




}
/// @nodoc
class _$VodPlayerCopyWithImpl<$Res>
    implements $VodPlayerCopyWith<$Res> {
  _$VodPlayerCopyWithImpl(this._self, this._then);

  final VodPlayer _self;
  final $Res Function(VodPlayer) _then;

/// Create a copy of VodPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? url = null,Object? headers = null,Object? parseApi = null,Object? extraParseApi = null,Object? parseSecret = null,Object? linkFeatures = null,Object? unLinkFeatures = null,Object? coreParams = null,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as String,parseApi: null == parseApi ? _self.parseApi : parseApi // ignore: cast_nullable_to_non_nullable
as String,extraParseApi: null == extraParseApi ? _self.extraParseApi : extraParseApi // ignore: cast_nullable_to_non_nullable
as String,parseSecret: null == parseSecret ? _self.parseSecret : parseSecret // ignore: cast_nullable_to_non_nullable
as bool,linkFeatures: null == linkFeatures ? _self.linkFeatures : linkFeatures // ignore: cast_nullable_to_non_nullable
as String,unLinkFeatures: null == unLinkFeatures ? _self.unLinkFeatures : unLinkFeatures // ignore: cast_nullable_to_non_nullable
as String,coreParams: null == coreParams ? _self.coreParams : coreParams // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [VodPlayer].
extension VodPlayerPatterns on VodPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VodPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VodPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VodPlayer value)  $default,){
final _that = this;
switch (_that) {
case _VodPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VodPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _VodPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  String url,  String headers,  String parseApi,  String extraParseApi,  bool parseSecret,  String linkFeatures,  String unLinkFeatures,  List<String> coreParams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VodPlayer() when $default != null:
return $default(_that.code,_that.name,_that.url,_that.headers,_that.parseApi,_that.extraParseApi,_that.parseSecret,_that.linkFeatures,_that.unLinkFeatures,_that.coreParams);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  String url,  String headers,  String parseApi,  String extraParseApi,  bool parseSecret,  String linkFeatures,  String unLinkFeatures,  List<String> coreParams)  $default,) {final _that = this;
switch (_that) {
case _VodPlayer():
return $default(_that.code,_that.name,_that.url,_that.headers,_that.parseApi,_that.extraParseApi,_that.parseSecret,_that.linkFeatures,_that.unLinkFeatures,_that.coreParams);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  String url,  String headers,  String parseApi,  String extraParseApi,  bool parseSecret,  String linkFeatures,  String unLinkFeatures,  List<String> coreParams)?  $default,) {final _that = this;
switch (_that) {
case _VodPlayer() when $default != null:
return $default(_that.code,_that.name,_that.url,_that.headers,_that.parseApi,_that.extraParseApi,_that.parseSecret,_that.linkFeatures,_that.unLinkFeatures,_that.coreParams);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VodPlayer implements VodPlayer {
  const _VodPlayer({required this.code, required this.name, required this.url, required this.headers, required this.parseApi, required this.extraParseApi, required this.parseSecret, required this.linkFeatures, required this.unLinkFeatures, required final  List<String> coreParams}): _coreParams = coreParams;
  factory _VodPlayer.fromJson(Map<String, dynamic> json) => _$VodPlayerFromJson(json);

@override final  String code;
@override final  String name;
@override final  String url;
@override final  String headers;
@override final  String parseApi;
@override final  String extraParseApi;
@override final  bool parseSecret;
@override final  String linkFeatures;
@override final  String unLinkFeatures;
 final  List<String> _coreParams;
@override List<String> get coreParams {
  if (_coreParams is EqualUnmodifiableListView) return _coreParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coreParams);
}


/// Create a copy of VodPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VodPlayerCopyWith<_VodPlayer> get copyWith => __$VodPlayerCopyWithImpl<_VodPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VodPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VodPlayer&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.headers, headers) || other.headers == headers)&&(identical(other.parseApi, parseApi) || other.parseApi == parseApi)&&(identical(other.extraParseApi, extraParseApi) || other.extraParseApi == extraParseApi)&&(identical(other.parseSecret, parseSecret) || other.parseSecret == parseSecret)&&(identical(other.linkFeatures, linkFeatures) || other.linkFeatures == linkFeatures)&&(identical(other.unLinkFeatures, unLinkFeatures) || other.unLinkFeatures == unLinkFeatures)&&const DeepCollectionEquality().equals(other._coreParams, _coreParams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,url,headers,parseApi,extraParseApi,parseSecret,linkFeatures,unLinkFeatures,const DeepCollectionEquality().hash(_coreParams));

@override
String toString() {
  return 'VodPlayer(code: $code, name: $name, url: $url, headers: $headers, parseApi: $parseApi, extraParseApi: $extraParseApi, parseSecret: $parseSecret, linkFeatures: $linkFeatures, unLinkFeatures: $unLinkFeatures, coreParams: $coreParams)';
}


}

/// @nodoc
abstract mixin class _$VodPlayerCopyWith<$Res> implements $VodPlayerCopyWith<$Res> {
  factory _$VodPlayerCopyWith(_VodPlayer value, $Res Function(_VodPlayer) _then) = __$VodPlayerCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, String url, String headers, String parseApi, String extraParseApi, bool parseSecret, String linkFeatures, String unLinkFeatures, List<String> coreParams
});




}
/// @nodoc
class __$VodPlayerCopyWithImpl<$Res>
    implements _$VodPlayerCopyWith<$Res> {
  __$VodPlayerCopyWithImpl(this._self, this._then);

  final _VodPlayer _self;
  final $Res Function(_VodPlayer) _then;

/// Create a copy of VodPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? url = null,Object? headers = null,Object? parseApi = null,Object? extraParseApi = null,Object? parseSecret = null,Object? linkFeatures = null,Object? unLinkFeatures = null,Object? coreParams = null,}) {
  return _then(_VodPlayer(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as String,parseApi: null == parseApi ? _self.parseApi : parseApi // ignore: cast_nullable_to_non_nullable
as String,extraParseApi: null == extraParseApi ? _self.extraParseApi : extraParseApi // ignore: cast_nullable_to_non_nullable
as String,parseSecret: null == parseSecret ? _self.parseSecret : parseSecret // ignore: cast_nullable_to_non_nullable
as bool,linkFeatures: null == linkFeatures ? _self.linkFeatures : linkFeatures // ignore: cast_nullable_to_non_nullable
as String,unLinkFeatures: null == unLinkFeatures ? _self.unLinkFeatures : unLinkFeatures // ignore: cast_nullable_to_non_nullable
as String,coreParams: null == coreParams ? _self._coreParams : coreParams // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
