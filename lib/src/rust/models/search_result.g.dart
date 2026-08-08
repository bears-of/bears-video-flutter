// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchRequest _$SearchRequestFromJson(Map<String, dynamic> json) =>
    _SearchRequest(
      pg: BigInt.parse(json['pg'] as String),
      tid: json['tid'] == null ? null : BigInt.parse(json['tid'] as String),
      text: json['text'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$SearchRequestToJson(_SearchRequest instance) =>
    <String, dynamic>{
      'pg': instance.pg.toString(),
      'tid': instance.tid?.toString(),
      'text': instance.text,
      'token': instance.token,
    };

_SearchVodItem _$SearchVodItemFromJson(Map<String, dynamic> json) =>
    _SearchVodItem(
      typeId: (json['typeId'] as num).toInt(),
      vodId: (json['vodId'] as num).toInt(),
      vodName: json['vodName'] as String,
      vodActor: json['vodActor'] as String,
      vodArea: json['vodArea'] as String,
      vodLang: json['vodLang'] as String,
      vodPic: json['vodPic'] as String,
      vodRemarks: json['vodRemarks'] as String,
      vodYear: json['vodYear'] as String,
    );

Map<String, dynamic> _$SearchVodItemToJson(_SearchVodItem instance) =>
    <String, dynamic>{
      'typeId': instance.typeId,
      'vodId': instance.vodId,
      'vodName': instance.vodName,
      'vodActor': instance.vodActor,
      'vodArea': instance.vodArea,
      'vodLang': instance.vodLang,
      'vodPic': instance.vodPic,
      'vodRemarks': instance.vodRemarks,
      'vodYear': instance.vodYear,
    };
