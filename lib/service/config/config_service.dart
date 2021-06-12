import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/global.dart';

/// 用户信息数据配置逻辑处理类
/// 单例.
class ConfigService {
  static final ConfigService _instance = ConfigService._internal();

  factory ConfigService() => _instance;

  ConfigService._internal();

  /// 保存初始化配置信息.
  Future<void> saveInitConfig(User newUser) async {
    /// 保存用户信息.
    User user = await UserDatasource().saveUser(newUser);

    /// 设置为当前用户.
    Global.saveCurrentUser(user);

    /// 保存默认血糖指标信息.
    await UserBloodSugarConfigDatasource()
        .saveConfig(UserBloodSugarConfig.byDefault(user.id!));
  }

  /// 获取用户的血糖标准.
  Future<UserBloodSugarConfig> getStandard(int userId) async {
    try {
      return await UserBloodSugarConfigDatasource().getByUserId(userId) ??
          UserBloodSugarConfig.byDefault(userId);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }
}
