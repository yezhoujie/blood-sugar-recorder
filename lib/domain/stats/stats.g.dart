// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stats _$StatsFromJson(Map<String, dynamic> json) {
  return Stats(
    recordDays: json['recordDays'] as int,
    breakDays: json['breakDays'] as int,
    medicineRecordNum: json['medicineRecordNum'] as int,
    foodRecordNum: json['foodRecordNum'] as int,
    bloodSugarRecordNum: json['bloodSugarRecordNum'] as int,
    highBloodSugarRecordNum: json['highBloodSugarRecordNum'] as int,
    lowBloodSugarRecordNum: json['lowBloodSugarRecordNum'] as int,
    fpgBloodSugarRecordNum: json['fpgBloodSugarRecordNum'] as int,
    fpgHighBloodSugarRecordNum: json['fpgHighBloodSugarRecordNum'] as int,
    fpgLowBloodSugarRecordNum: json['fpgLowBloodSugarRecordNum'] as int,
    fpgBloodSugarMax: (json['fpgBloodSugarMax'] as num?)?.toDouble(),
    fpgBloodSugarMin: (json['fpgBloodSugarMin'] as num?)?.toDouble(),
    hpgBloodSugarRecordNum: json['hpgBloodSugarRecordNum'] as int,
    hpgHighBloodSugarRecordNum: json['hpgHighBloodSugarRecordNum'] as int,
    hpgLowBloodSugarRecordNum: json['hpgLowBloodSugarRecordNum'] as int,
    hpgBloodSugarMax: (json['hpgBloodSugarMax'] as num?)?.toDouble(),
    hpgBloodSugarMin: (json['hpgBloodSugarMin'] as num?)?.toDouble(),
    standard:
        UserBloodSugarConfig.fromJson(json['standard'] as Map<String, dynamic>),
    fpgRecordList: (json['fpgRecordList'] as List<dynamic>)
        .map((e) => BloodSugarRecordItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    hpgRecordList: (json['hpgRecordList'] as List<dynamic>)
        .map((e) => BloodSugarRecordItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
      'recordDays': instance.recordDays,
      'breakDays': instance.breakDays,
      'medicineRecordNum': instance.medicineRecordNum,
      'foodRecordNum': instance.foodRecordNum,
      'bloodSugarRecordNum': instance.bloodSugarRecordNum,
      'highBloodSugarRecordNum': instance.highBloodSugarRecordNum,
      'lowBloodSugarRecordNum': instance.lowBloodSugarRecordNum,
      'fpgBloodSugarRecordNum': instance.fpgBloodSugarRecordNum,
      'fpgHighBloodSugarRecordNum': instance.fpgHighBloodSugarRecordNum,
      'fpgLowBloodSugarRecordNum': instance.fpgLowBloodSugarRecordNum,
      'fpgBloodSugarMax': instance.fpgBloodSugarMax,
      'fpgBloodSugarMin': instance.fpgBloodSugarMin,
      'hpgBloodSugarRecordNum': instance.hpgBloodSugarRecordNum,
      'hpgHighBloodSugarRecordNum': instance.hpgHighBloodSugarRecordNum,
      'hpgLowBloodSugarRecordNum': instance.hpgLowBloodSugarRecordNum,
      'hpgBloodSugarMax': instance.hpgBloodSugarMax,
      'hpgBloodSugarMin': instance.hpgBloodSugarMin,
      'standard': instance.standard.toJson(),
      'fpgRecordList': instance.fpgRecordList.map((e) => e.toJson()).toList(),
      'hpgRecordList': instance.hpgRecordList.map((e) => e.toJson()).toList(),
    };
