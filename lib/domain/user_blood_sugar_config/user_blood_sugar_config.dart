import 'package:json_annotation/json_annotation.dart';

part 'user_blood_sugar_config.g.dart';

@JsonSerializable(explicitToJson: true)
class UserBloodSugarConfig {
  /// 用户ID.
  int userId;

  ///空腹血糖指标下限，低于该值为低血糖
  double fpgMin;

  ///空腹须糖指标上限，高于该值为高血糖
  double fpgMax;

  ///餐后两小时血糖指标下限，低于该值为低血糖
  double hpg2Min;

  ///餐后两小时血糖指标上限, 高于该值为高血糖
  double hpg2Max;

  UserBloodSugarConfig({
    required this.userId,
    required this.fpgMin,
    required this.fpgMax,
    required this.hpg2Min,
    required this.hpg2Max,
  });

  factory UserBloodSugarConfig.fromJson(Map<String, dynamic> json) =>
      _$UserBloodSugarConfigFromJson(json);

  Map<String, dynamic> toJson() => _$UserBloodSugarConfigToJson(this);

  /// 按照医学标准获取默认血糖指标设置.
  static UserBloodSugarConfig byDefault(int userId) {
    return UserBloodSugarConfig(
      userId: userId,
      fpgMin: 3.9,
      fpgMax: 6.1,
      hpg2Min: 5.1,
      hpg2Max: 7.0,
    );
  }
}
