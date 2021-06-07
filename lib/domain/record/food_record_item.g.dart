// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_record_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodRecordItem _$FoodRecordItemFromJson(Map<String, dynamic> json) {
  return FoodRecordItem(
    id: json['id'] as int?,
    userId: json['userId'] as int,
    cycleRecordId: json['cycleRecordId'] as int?,
    foodInfo: json['foodInfo'] as String?,
    comment: json['comment'] as String?,
    recordTime: DateTime.parse(json['recordTime'] as String),
  );
}

Map<String, dynamic> _$FoodRecordItemToJson(FoodRecordItem instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'recordTime': instance.recordTime.toIso8601String(),
      'cycleRecordId': instance.cycleRecordId,
      'id': instance.id,
      'foodInfo': instance.foodInfo,
      'comment': instance.comment,
    };
