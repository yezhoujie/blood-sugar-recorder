import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stats.g.dart';

@JsonSerializable(explicitToJson: true)
class Stats {
  /// 记录天数.
  int recordDays;

  /// 中断天数.
  int breakDays;

  /// 药物使用记录数.
  int medicineRecordNum;

  /// 用餐记录数.
  int foodRecordNum;

  /// 血糖记录数.
  int bloodSugarRecordNum;

  /// 高血糖记录数.
  int highBloodSugarRecordNum;

  /// 低血糖记录数.
  int lowBloodSugarRecordNum;

  /// 空腹血糖记录数.
  int fpgBloodSugarRecordNum;

  /// 空腹高血糖记录数.
  int fpgHighBloodSugarRecordNum;

  /// 空腹低血糖记录数.
  int fpgLowBloodSugarRecordNum;

  /// 空腹血糖最高值.
  double? fpgBloodSugarMax;

  /// 空腹血糖最低值.
  double? fpgBloodSugarMin;

  /// 餐后血糖记录数.
  int hpgBloodSugarRecordNum;

  /// 餐后稿血糖记录数.
  int hpgHighBloodSugarRecordNum;

  /// 餐后低血糖记录数.
  int hpgLowBloodSugarRecordNum;

  /// 餐后血糖最高值.
  double? hpgBloodSugarMax;

  /// 餐后血糖最低值.
  double? hpgBloodSugarMin;

  /// 用户血糖指标配置.
  UserBloodSugarConfig standard;

  /// 空腹血糖记录列表.
  List<BloodSugarRecordItem> fpgRecordList;

  /// 餐后血糖记录列表.
  List<BloodSugarRecordItem> hpgRecordList;

  Stats({
    required this.recordDays,
    required this.breakDays,
    required this.medicineRecordNum,
    required this.foodRecordNum,
    required this.bloodSugarRecordNum,
    required this.highBloodSugarRecordNum,
    required this.lowBloodSugarRecordNum,
    required this.fpgBloodSugarRecordNum,
    required this.fpgHighBloodSugarRecordNum,
    required this.fpgLowBloodSugarRecordNum,
    this.fpgBloodSugarMax,
    this.fpgBloodSugarMin,
    required this.hpgBloodSugarRecordNum,
    required this.hpgHighBloodSugarRecordNum,
    required this.hpgLowBloodSugarRecordNum,
    this.hpgBloodSugarMax,
    this.hpgBloodSugarMin,
    required this.standard,
    required this.fpgRecordList,
    required this.hpgRecordList,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);

  Map<String, dynamic> toJson() => _$StatsToJson(this);
}
