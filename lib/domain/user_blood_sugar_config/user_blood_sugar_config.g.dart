// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_blood_sugar_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBloodSugarConfig _$UserBloodSugarConfigFromJson(Map<String, dynamic> json) {
  return UserBloodSugarConfig(
    userId: json['userId'] as int,
    fpgMin: (json['fpgMin'] as num).toDouble(),
    fpgMax: (json['fpgMax'] as num).toDouble(),
    hpg2Min: (json['hpg2Min'] as num).toDouble(),
    hpg2Max: (json['hpg2Max'] as num).toDouble(),
  );
}

Map<String, dynamic> _$UserBloodSugarConfigToJson(
        UserBloodSugarConfig instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fpgMin': instance.fpgMin,
      'fpgMax': instance.fpgMax,
      'hpg2Min': instance.hpg2Min,
      'hpg2Max': instance.hpg2Max,
    };
