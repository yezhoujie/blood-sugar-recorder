// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_record_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineRecordItem _$MedicineRecordItemFromJson(Map<String, dynamic> json) {
  return MedicineRecordItem(
    id: json['id'] as int?,
    userId: json['userId'] as int,
    cycleRecordId: json['cycleRecordId'] as int?,
    medicineId: json['medicineId'] as int?,
    usage: (json['usage'] as num).toDouble(),
    recordTime: DateTime.parse(json['recordTime'] as String),
    extra: json['extra'] as bool,
  );
}

Map<String, dynamic> _$MedicineRecordItemToJson(MedicineRecordItem instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'recordTime': instance.recordTime.toIso8601String(),
      'cycleRecordId': instance.cycleRecordId,
      'id': instance.id,
      'medicineId': instance.medicineId,
      'usage': instance.usage,
      'extra': instance.extra,
    };
