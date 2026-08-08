// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'danmaku_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DanmakuItem _$DanmakuItemFromJson(Map<String, dynamic> json) => _DanmakuItem(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  content: json['content'] as String,
  color: json['color'] as String,
  vTime: json['vTime'] as String,
);

Map<String, dynamic> _$DanmakuItemToJson(_DanmakuItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'content': instance.content,
      'color': instance.color,
      'vTime': instance.vTime,
    };
