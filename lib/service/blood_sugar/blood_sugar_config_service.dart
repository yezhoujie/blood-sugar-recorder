import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';

/// 血檀指标设置业务处理类.
/// 单例.
class BloodSugarConfigService {
  static final BloodSugarConfigService _instance =
      BloodSugarConfigService._internal();

  BloodSugarConfigService._internal();

  factory BloodSugarConfigService() => _instance;

  /// 根据用户ID获取用户血糖指标配置信息.
  Future<UserBloodSugarConfig> getByUserId(int userId) async {
    try {
      UserBloodSugarConfig? config =
          await UserBloodSugarConfigDatasource().getByUserId(userId);
      if (null == config) {
        throw ErrorData(
            code: ErrorData.errorCodeMap['NOT_FOUND']!,
            message: "糟糕！数据跑掉了，请刷新后重试");
      }
      return config;
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 保存血糖指标信息.
  Future<UserBloodSugarConfig> save(UserBloodSugarConfig config) async {
    try {
      return await UserBloodSugarConfigDatasource().saveConfig(config);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }
}
