import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// 用户实体.
@JsonSerializable(explicitToJson: true)
class User {
  /// id 主键
  int? id;

  /// 姓名
  String name;

  /// 性别
  Gender gender;

  /// 生日.
  DateTime birthday;

  User({
    this.id,
    required this.name,
    required this.gender,
    required this.birthday,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

/// 性别枚举
enum Gender {
  ///男
  MALE,

  /// 女
  FEMALE,

  /// 未知
  UNKNOWN
}
