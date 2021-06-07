import 'package:blood_sugar_recorder/domain/record/record_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medicine_record_item.g.dart';

/// 周期内的药物干预记录.
@JsonSerializable(explicitToJson: true)
class MedicineRecordItem extends RecordItem {
  /// -- 主键ID
  int? id;

  ///药物ID
  int? medicineId;

  ///药物用量
  double usage = 1;

  /// 是否进行额外药物补充
  bool extra;

  MedicineRecordItem({
    this.id,
    required int userId,
    int? cycleRecordId,
    this.medicineId,
    this.usage = 1,
    required DateTime recordTime,
    this.extra = false,
  }) : super(
            recordTime: recordTime,
            userId: userId,
            cycleRecordId: cycleRecordId);

  factory MedicineRecordItem.fromJson(Map<String, dynamic> json) =>
      _$MedicineRecordItemFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineRecordItemToJson(this);
}
