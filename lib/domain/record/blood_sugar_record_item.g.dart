// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_sugar_record_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BloodSugarRecordItem _$BloodSugarRecordItemFromJson(Map<String, dynamic> json) {
  return BloodSugarRecordItem(
    id: json['id'] as int?,
    userId: json['userId'] as int,
    cycleRecordId: json['cycleRecordId'] as int?,
    bloodSugar: (json['bloodSugar'] as num?)?.toDouble(),
    fpg: boolFromIntWithNull(json['fpg'] as int?),
    recordTime: DateTime.parse(json['recordTime'] as String),
  );
}

Map<String, dynamic> _$BloodSugarRecordItemToJson(
        BloodSugarRecordItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'recordTime': instance.recordTime.toIso8601String(),
      'cycleRecordId': instance.cycleRecordId,
      'bloodSugar': instance.bloodSugar,
      'fpg': boolToIntWithNull(instance.fpg),
    };
