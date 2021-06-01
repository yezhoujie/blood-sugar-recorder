import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';

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
    Global.currentUser = user;
    await StorageUtil().setJson(CURRENT_USER_ID_KEY, user);

    /// 保存默认血糖指标信息.
    await UserBloodSugarConfigDatasource()
        .saveConfig(UserBloodSugarConfig.byDefault(user.id!));
  }
}
