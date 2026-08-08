// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoListRequest _$VideoListRequestFromJson(Map<String, dynamic> json) =>
    _VideoListRequest(
      pg: BigInt.parse(json['pg'] as String),
      tid: BigInt.parse(json['tid'] as String),
      class_: json['class_'] as String,
      area: json['area'] as String,
      lang: json['lang'] as String,
      year: json['year'] as String,
      order: json['order'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$VideoListRequestToJson(_VideoListRequest instance) =>
    <String, dynamic>{
      'pg': instance.pg.toString(),
      'tid': instance.tid.toString(),
      'class_': instance.class_,
      'area': instance.area,
      'lang': instance.lang,
      'year': instance.year,
      'order': instance.order,
      'token': instance.token,
    };

_VodListItem _$VodListItemFromJson(Map<String, dynamic> json) => _VodListItem(
  typeId: (json['typeId'] as num).toInt(),
  vodId: (json['vodId'] as num).toInt(),
  vodName: json['vodName'] as String,
  vodPic: json['vodPic'] as String,
  vodRemarks: json['vodRemarks'] as String,
);

Map<String, dynamic> _$VodListItemToJson(_VodListItem instance) =>
    <String, dynamic>{
      'typeId': instance.typeId,
      'vodId': instance.vodId,
      'vodName': instance.vodName,
      'vodPic': instance.vodPic,
      'vodRemarks': instance.vodRemarks,
    };
