import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/service/service.dart';

/// 用户信息业务处理类.
/// 单例.
class UserService {
  static final UserService _instance = UserService._internal();

  UserService._internal();

  factory UserService() => _instance;

  /// 保存或新增用户信息.
  Future<User> save(User user) async {
    /// 保存用户信息.
    try {
      return await UserDatasource().saveUser(user);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 获取所有用户.
  Future<List<User>> findAll() async {
    try {
      List<User> userList = await UserDatasource().findAll();
      return userList;
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 通过id获取用户信息.
  Future<User?> getById(int id) async {
    try {
      return await UserDatasource().getById(id);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 删除用户，以及用户下的所有数据.
  Future<void> deleteById(int id) async {
    try {
      /// 删除用户下所有药物关于记录.
      await MedicineRecordItemDatasource().deleteByUserId(id);

      /// 删除用户下所有的进食记录.
      await FoodRecordItemDatasource().deleteByUserId(id);

      /// 删除用户下所有的血糖测试记录.
      await BloodSugarRecordItemDatasource().deleteByUserId(id);

      /// 删除用户下所有的血糖周期记录.
      await CycleRecordDatasource().deleteByUserId(id);

      /// 删除用户下的血糖指标信息.
      await BloodSugarConfigService().deleteByUserId(id);

      /// 删除用户下的药物配置信息.
      await MedicineService().deleteAllByUserId(id);

      /// 删除用户信息.
      await UserDatasource().deleteById(id);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }
}
