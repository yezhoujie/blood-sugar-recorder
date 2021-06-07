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
    fpg: json['fpg'] as bool?,
    recordTime: DateTime.parse(json['recordTime'] as String),
  );
}

Map<String, dynamic> _$BloodSugarRecordItemToJson(
        BloodSugarRecordItem instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'recordTime': instance.recordTime.toIso8601String(),
      'cycleRecordId': instance.cycleRecordId,
      'id': instance.id,
      'bloodSugar': instance.bloodSugar,
      'fpg': instance.fpg,
    };
