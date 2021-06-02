import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';

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
}
