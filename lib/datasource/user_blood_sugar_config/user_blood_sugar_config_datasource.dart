import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:sqflite/sqflite.dart';

///用户血糖指标设置数据层
///单例
class UserBloodSugarConfigDatasource {
  static final UserBloodSugarConfigDatasource _instance =
      UserBloodSugarConfigDatasource._internal();

  factory UserBloodSugarConfigDatasource() => _instance;

  final _tableName = 'user_blood_sugar_config';

  UserBloodSugarConfigDatasource._internal();

  /// 获取用户的血糖指标设置.
  Future<UserBloodSugarConfig?> getByUserId(int userId) async {
    List<Map<String, dynamic>> resMap = await Global.database
        .rawQuery('''select * from $_tableName where userId = ?''', [userId]);
    if (resMap.isNotEmpty) {
      return UserBloodSugarConfig.fromJson(resMap.first);
    } else {
      return null;
    }
  }

  /// 保存用户的血糖指标设置.
  Future<UserBloodSugarConfig> saveConfig(UserBloodSugarConfig config) async {
    await Global.database.insert(_tableName, config.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return config;
  }

  /// 删除用户下的血糖指标配置.
  Future<void> deleteByUserId(int userId) async {
    await Global.database
        .delete(_tableName, where: "userId = ?", whereArgs: [userId]);
  }
}
