import 'package:blood_sugar_recorder/domain/record/record_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blood_sugar_record_item.g.dart';

@JsonSerializable(explicitToJson: true)
class BloodSugarRecordItem extends RecordItem {
  ///血糖
  double? bloodSugar;

  ///是否为空腹0:否，1:是
  bool? fpg = false;

  BloodSugarRecordItem(
      {int? id,
      required int userId,
      int? cycleRecordId,
      this.bloodSugar,
      this.fpg,
      required DateTime recordTime})
      : super(
            id: id,
            recordTime: recordTime,
            userId: userId,
            cycleRecordId: cycleRecordId);

  factory BloodSugarRecordItem.fromJson(Map<String, dynamic> json) =>
      _$BloodSugarRecordItemFromJson(json);

  Map<String, dynamic> toJson() => _$BloodSugarRecordItemToJson(this);
}
