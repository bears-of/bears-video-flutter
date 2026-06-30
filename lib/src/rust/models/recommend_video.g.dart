// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BannerItem _$BannerItemFromJson(Map<String, dynamic> json) => _BannerItem(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  content: json['content'] as String,
  reqType: (json['reqType'] as num).toInt(),
  reqContent: json['reqContent'] as String,
  realPackageId: json['realPackageId'] as String,
);

Map<String, dynamic> _$BannerItemToJson(_BannerItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'content': instance.content,
      'reqType': instance.reqType,
      'reqContent': instance.reqContent,
      'realPackageId': instance.realPackageId,
    };

_HomeRecommendData _$HomeRecommendDataFromJson(Map<String, dynamic> json) =>
    _HomeRecommendData(
      banners: (json['banners'] as List<dynamic>)
          .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>)
          .map((e) => HomeVideoSection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeRecommendDataToJson(_HomeRecommendData instance) =>
    <String, dynamic>{'banners': instance.banners, 'videos': instance.videos};

_HomeVideoSection _$HomeVideoSectionFromJson(Map<String, dynamic> json) =>
    _HomeVideoSection(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      typeId: (json['typeId'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
      moreReqType: (json['moreReqType'] as num).toInt(),
      moreText: json['moreText'] as String,
      vlist: (json['vlist'] as List<dynamic>)
          .map((e) => VodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeVideoSectionToJson(_HomeVideoSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'typeId': instance.typeId,
      'hasMore': instance.hasMore,
      'moreReqType': instance.moreReqType,
      'moreText': instance.moreText,
      'vlist': instance.vlist,
    };

_VodItem _$VodItemFromJson(Map<String, dynamic> json) => _VodItem(
  vodId: (json['vodId'] as num).toInt(),
  vodName: json['vodName'] as String,
  vodPic: json['vodPic'] as String,
  vodRemarks: json['vodRemarks'] as String,
  typeId: (json['typeId'] as num).toInt(),
);

Map<String, dynamic> _$VodItemToJson(_VodItem instance) => <String, dynamic>{
  'vodId': instance.vodId,
  'vodName': instance.vodName,
  'vodPic': instance.vodPic,
  'vodRemarks': instance.vodRemarks,
  'typeId': instance.typeId,
};
