import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';

/// 药物管理业务逻辑.
class MedicineService {
  /// 根据ID获取配置.
  Future<UserMedicineConfig> getById(int id) async {
    try {
      UserMedicineConfig? config =
          await UserMedicineConfigDatasource().getById(id);
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

  /// 保存药物信息.
  Future<UserMedicineConfig> save(UserMedicineConfig config) async {
    try {
      return await UserMedicineConfigDatasource().saveConfig(config);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 根据ID删除记录.
  Future<void> deleteById(int id) async {
    try {
      await UserMedicineConfigDatasource().deleteById(id);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 获取用户下的所有药物列表.
  Future<List<UserMedicineConfig>> findByUserId(int userId) async {
    try {
      return await UserMedicineConfigDatasource().findByUserId(userId);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }
}
