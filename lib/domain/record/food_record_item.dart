import 'package:blood_sugar_recorder/domain/record/record_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_record_item.g.dart';

/// 周期内的进食记录.
@JsonSerializable(explicitToJson: true)
class FoodRecordItem extends RecordItem {
  ///食物清单
  String? foodInfo;

  ///进食备注
  String? comment;

  FoodRecordItem(
      {int? id,
      required int userId,
      int? cycleRecordId,
      this.foodInfo,
      this.comment,
      required DateTime recordTime})
      : super(
            id: id,
            recordTime: recordTime,
            userId: userId,
            cycleRecordId: cycleRecordId);

  factory FoodRecordItem.fromJson(Map<String, dynamic> json) =>
      _$FoodRecordItemFromJson(json);

  Map<String, dynamic> toJson() => _$FoodRecordItemToJson(this);
}
