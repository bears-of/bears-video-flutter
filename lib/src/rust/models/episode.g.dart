// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Episode _$EpisodeFromJson(Map<String, dynamic> json) =>
    _Episode(label: json['label'] as String, url: json['url'] as String);

Map<String, dynamic> _$EpisodeToJson(_Episode instance) => <String, dynamic>{
  'label': instance.label,
  'url': instance.url,
};

_PlaySource _$PlaySourceFromJson(Map<String, dynamic> json) => _PlaySource(
  name: json['name'] as String,
  parseApi: json['parseApi'] as String,
  episodes: (json['episodes'] as List<dynamic>)
      .map((e) => Episode.fromJson(e as Map<String, dynamic>))
      .toList(),
  needResolve: json['needResolve'] as bool,
  headers: Map<String, String>.from(json['headers'] as Map),
);

Map<String, dynamic> _$PlaySourceToJson(_PlaySource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'parseApi': instance.parseApi,
      'episodes': instance.episodes,
      'needResolve': instance.needResolve,
      'headers': instance.headers,
    };
