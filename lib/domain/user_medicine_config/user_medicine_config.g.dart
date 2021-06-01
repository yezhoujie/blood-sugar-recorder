// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_medicine_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMedicineConfig _$UserMedicineConfigFromJson(Map<String, dynamic> json) {
  return UserMedicineConfig(
    id: json['id'] as int?,
    userId: json['userId'] as int,
    type: _$enumDecode(_$MedicineTypeEnumMap, json['type']),
    name: json['name'] as String,
    color: json['color'] as String,
    unit: json['unit'] as String?,
  );
}

Map<String, dynamic> _$UserMedicineConfigToJson(UserMedicineConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$MedicineTypeEnumMap[instance.type],
      'name': instance.name,
      'color': instance.color,
      'unit': instance.unit,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$MedicineTypeEnumMap = {
  MedicineType.INS: 'INS',
  MedicineType.PILL: 'PILL',
};
