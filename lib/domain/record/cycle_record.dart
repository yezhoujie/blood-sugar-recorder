import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/utils/bool_converter.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cycle_record.g.dart';

/// 血糖记录周期记录.
/// 其中包含了药物，进食，血糖测量记录.
@JsonSerializable(explicitToJson: true)
class CycleRecord {
  /// 主键id
  int? id;

  /// 关联用户id
  int userId;

  ///周期所在时间，以周期内最后一次记录时间为准.
  DateTime? datetime;

  ///该周期是否关闭，0:false, 1:true
  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool closed;

  ///周期备注
  String? comment;

  /// 周期下的详细记录列表.
  @JsonKey(ignore: true)
  List<RecordItem> itemList;

  CycleRecord({
    this.id,
    required this.userId,
    this.datetime,
    required this.closed,
    this.comment,
    this.itemList = const [],
  });

  factory CycleRecord.fromJson(Map<String, dynamic> json) =>
      _$CycleRecordFromJson(json);

  Map<String, dynamic> toJson() => _$CycleRecordToJson(this);

  static CycleRecord byDefault(int userId) {
    return CycleRecord(userId: userId, closed: false);
  }

  static String toShareText(CycleRecord cycleRecord) {
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
    String text = "【血糖记录器】分享数据\n";
    if (cycleRecord.itemList.isEmpty) {
      text += "暂无明细数据";
    } else {
      for (var item in cycleRecord.itemList) {
        switch (item.runtimeType) {
          case MedicineRecordItem:
            {
              item as MedicineRecordItem;
              text += format.format(item.recordTime) +
                  " ${item.extra ? "额外" : ""}使用${item.medicine!.name}${item.usage}${item.medicine!.unit}\n";
              break;
            }
          case FoodRecordItem:
            {
              item as FoodRecordItem;
              text += format.format(item.recordTime) +
                  " 用餐${item.foodInfo ?? ""}\n备注：${item.comment ?? ""}\n";
              break;
            }
          case BloodSugarRecordItem:
            {
              item as BloodSugarRecordItem;
              text += format.format(item.recordTime) +
                  " 血糖测量${item.bloodSugar ?? ""}mmol/L(${null == item.fpg || !item.fpg! ? "餐后" : "空腹"})\n";
              break;
            }
        }
      }
      text += "周期备注：${cycleRecord.comment ?? "暂无备注"}";
    }

    return text;
  }
}
