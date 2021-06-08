import 'package:blood_sugar_recorder/domain/record/record_item.dart';
import 'package:blood_sugar_recorder/utils/bool_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medicine_record_item.g.dart';

/// 周期内的药物干预记录.
@JsonSerializable(explicitToJson: true)
class MedicineRecordItem extends RecordItem {
  ///药物ID
  int? medicineId;

  ///药物用量
  double usage = 1;

  /// 是否进行额外药物补充
  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool extra;

  MedicineRecordItem({
    int? id,
    required int userId,
    int? cycleRecordId,
    this.medicineId,
    this.usage = 1,
    required DateTime recordTime,
    this.extra = false,
  }) : super(
            id: id,
            recordTime: recordTime,
            userId: userId,
            cycleRecordId: cycleRecordId);

  factory MedicineRecordItem.fromJson(Map<String, dynamic> json) =>
      _$MedicineRecordItemFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineRecordItemToJson(this);
}
