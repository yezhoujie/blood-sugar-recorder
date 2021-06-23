import 'package:blood_sugar_recorder/utils/bool_converter.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_medicine_config.g.dart';

@JsonSerializable(explicitToJson: true)
class UserMedicineConfig {
  /// 主键.
  int? id;

  /// 关联用户ID.
  int userId;

  /// 药物类型.
  MedicineType type;

  /// 药物名称.
  String name;

  /// 所选的颜色HEX值.
  String color;

  /// 药物单位.
  String? unit;

  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool deleted;

  UserMedicineConfig({
    this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.color,
    this.unit,
    this.deleted = false,
  });

  factory UserMedicineConfig.fromJson(Map<String, dynamic> json) =>
      _$UserMedicineConfigFromJson(json);

  Map<String, dynamic> toJson() => _$UserMedicineConfigToJson(this);

  /// 默认药物数据.
  static UserMedicineConfig byDefault(int userId) {
    return UserMedicineConfig(
      userId: userId,
      type: MedicineType.INS,
      name: "门冬胰岛素",
      color: Colors.orange.value.toRadixString(16),
      unit: "单位",
      deleted: false,
    );
  }
}

/// 药物类型枚举.
enum MedicineType {
  /// 胰岛素.
  INS,

  /// 药物.
  PILL
}
