// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CycleRecord _$CycleRecordFromJson(Map<String, dynamic> json) {
  return CycleRecord(
    id: json['id'] as int?,
    userId: json['userId'] as int,
    datetime: json['datetime'] == null
        ? null
        : DateTime.parse(json['datetime'] as String),
    closed: boolFromInt(json['closed'] as int),
    comment: json['comment'] as String?,
  );
}

Map<String, dynamic> _$CycleRecordToJson(CycleRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'datetime': instance.datetime?.toIso8601String(),
      'closed': boolToInt(instance.closed),
      'comment': instance.comment,
    };
