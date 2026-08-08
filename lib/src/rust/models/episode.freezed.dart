// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Episode {

 String get label; String get url;
/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeCopyWith<Episode> get copyWith => _$EpisodeCopyWithImpl<Episode>(this as Episode, _$identity);

  /// Serializes this Episode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Episode&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'Episode(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class $EpisodeCopyWith<$Res>  {
  factory $EpisodeCopyWith(Episode value, $Res Function(Episode) _then) = _$EpisodeCopyWithImpl;
@useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class _$EpisodeCopyWithImpl<$Res>
    implements $EpisodeCopyWith<$Res> {
  _$EpisodeCopyWithImpl(this._self, this._then);

  final Episode _self;
  final $Res Function(Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? url = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Episode].
extension EpisodePatterns on Episode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Episode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Episode value)  $default,){
final _that = this;
switch (_that) {
case _Episode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Episode value)?  $default,){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.label,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String url)  $default,) {final _that = this;
switch (_that) {
case _Episode():
return $default(_that.label,_that.url);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String url)?  $default,) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.label,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Episode implements Episode {
  const _Episode({required this.label, required this.url});
  factory _Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);

@override final  String label;
@override final  String url;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeCopyWith<_Episode> get copyWith => __$EpisodeCopyWithImpl<_Episode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Episode&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'Episode(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class _$EpisodeCopyWith<$Res> implements $EpisodeCopyWith<$Res> {
  factory _$EpisodeCopyWith(_Episode value, $Res Function(_Episode) _then) = __$EpisodeCopyWithImpl;
@override @useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class __$EpisodeCopyWithImpl<$Res>
    implements _$EpisodeCopyWith<$Res> {
  __$EpisodeCopyWithImpl(this._self, this._then);

  final _Episode _self;
  final $Res Function(_Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? url = null,}) {
  return _then(_Episode(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PlaySource {

 String get name; String get parseApi; List<Episode> get episodes; bool get needResolve; Map<String, String> get headers;
/// Create a copy of PlaySource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaySourceCopyWith<PlaySource> get copyWith => _$PlaySourceCopyWithImpl<PlaySource>(this as PlaySource, _$identity);

  /// Serializes this PlaySource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaySource&&(identical(other.name, name) || other.name == name)&&(identical(other.parseApi, parseApi) || other.parseApi == parseApi)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.needResolve, needResolve) || other.needResolve == needResolve)&&const DeepCollectionEquality().equals(other.headers, headers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,parseApi,const DeepCollectionEquality().hash(episodes),needResolve,const DeepCollectionEquality().hash(headers));

@override
String toString() {
  return 'PlaySource(name: $name, parseApi: $parseApi, episodes: $episodes, needResolve: $needResolve, headers: $headers)';
}


}

/// @nodoc
abstract mixin class $PlaySourceCopyWith<$Res>  {
  factory $PlaySourceCopyWith(PlaySource value, $Res Function(PlaySource) _then) = _$PlaySourceCopyWithImpl;
@useResult
$Res call({
 String name, String parseApi, List<Episode> episodes, bool needResolve, Map<String, String> headers
});




}
/// @nodoc
class _$PlaySourceCopyWithImpl<$Res>
    implements $PlaySourceCopyWith<$Res> {
  _$PlaySourceCopyWithImpl(this._self, this._then);

  final PlaySource _self;
  final $Res Function(PlaySource) _then;

/// Create a copy of PlaySource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? parseApi = null,Object? episodes = null,Object? needResolve = null,Object? headers = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parseApi: null == parseApi ? _self.parseApi : parseApi // ignore: cast_nullable_to_non_nullable
as String,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,needResolve: null == needResolve ? _self.needResolve : needResolve // ignore: cast_nullable_to_non_nullable
as bool,headers: null == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaySource].
extension PlaySourcePatterns on PlaySource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaySource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaySource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaySource value)  $default,){
final _that = this;
switch (_that) {
case _PlaySource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaySource value)?  $default,){
final _that = this;
switch (_that) {
case _PlaySource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String parseApi,  List<Episode> episodes,  bool needResolve,  Map<String, String> headers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaySource() when $default != null:
return $default(_that.name,_that.parseApi,_that.episodes,_that.needResolve,_that.headers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String parseApi,  List<Episode> episodes,  bool needResolve,  Map<String, String> headers)  $default,) {final _that = this;
switch (_that) {
case _PlaySource():
return $default(_that.name,_that.parseApi,_that.episodes,_that.needResolve,_that.headers);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String parseApi,  List<Episode> episodes,  bool needResolve,  Map<String, String> headers)?  $default,) {final _that = this;
switch (_that) {
case _PlaySource() when $default != null:
return $default(_that.name,_that.parseApi,_that.episodes,_that.needResolve,_that.headers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaySource implements PlaySource {
  const _PlaySource({required this.name, required this.parseApi, required final  List<Episode> episodes, required this.needResolve, required final  Map<String, String> headers}): _episodes = episodes,_headers = headers;
  factory _PlaySource.fromJson(Map<String, dynamic> json) => _$PlaySourceFromJson(json);

@override final  String name;
@override final  String parseApi;
 final  List<Episode> _episodes;
@override List<Episode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

@override final  bool needResolve;
 final  Map<String, String> _headers;
@override Map<String, String> get headers {
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_headers);
}


/// Create a copy of PlaySource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaySourceCopyWith<_PlaySource> get copyWith => __$PlaySourceCopyWithImpl<_PlaySource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaySourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaySource&&(identical(other.name, name) || other.name == name)&&(identical(other.parseApi, parseApi) || other.parseApi == parseApi)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.needResolve, needResolve) || other.needResolve == needResolve)&&const DeepCollectionEquality().equals(other._headers, _headers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,parseApi,const DeepCollectionEquality().hash(_episodes),needResolve,const DeepCollectionEquality().hash(_headers));

@override
String toString() {
  return 'PlaySource(name: $name, parseApi: $parseApi, episodes: $episodes, needResolve: $needResolve, headers: $headers)';
}


}

/// @nodoc
abstract mixin class _$PlaySourceCopyWith<$Res> implements $PlaySourceCopyWith<$Res> {
  factory _$PlaySourceCopyWith(_PlaySource value, $Res Function(_PlaySource) _then) = __$PlaySourceCopyWithImpl;
@override @useResult
$Res call({
 String name, String parseApi, List<Episode> episodes, bool needResolve, Map<String, String> headers
});




}
/// @nodoc
class __$PlaySourceCopyWithImpl<$Res>
    implements _$PlaySourceCopyWith<$Res> {
  __$PlaySourceCopyWithImpl(this._self, this._then);

  final _PlaySource _self;
  final $Res Function(_PlaySource) _then;

/// Create a copy of PlaySource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? parseApi = null,Object? episodes = null,Object? needResolve = null,Object? headers = null,}) {
  return _then(_PlaySource(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parseApi: null == parseApi ? _self.parseApi : parseApi // ignore: cast_nullable_to_non_nullable
as String,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,needResolve: null == needResolve ? _self.needResolve : needResolve // ignore: cast_nullable_to_non_nullable
as bool,headers: null == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
