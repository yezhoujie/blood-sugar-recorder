import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:sqflite/sqflite.dart';

/// 用户药物配置数据层
/// 单例
class UserMedicineConfigDatasource {
  static final UserMedicineConfigDatasource _instance =
      UserMedicineConfigDatasource._internal();

  final String _tableName = "user_medicine_config";

  factory UserMedicineConfigDatasource() => _instance;

  UserMedicineConfigDatasource._internal();

  /// 根据用户Id获取用户下的药物配置.
  Future<List<UserMedicineConfig?>> findByUserId(int userId) async {
    List<Map<String, dynamic>> resList = await Global.database
        .rawQuery('''select * from $_tableName where userId = ?''', [userId]);

    if (resList.isNotEmpty) {
      return resList.map((item) => UserMedicineConfig.fromJson(item)).toList();
    } else {
      return [];
    }
  }

  /// 根据ID获取药物信息.
  Future<UserMedicineConfig?> getById(int id) async {
    List<Map<String, dynamic>> resList = await Global.database
        .rawQuery('''select * from $_tableName where id = ?''', [id]);

    if (resList.isNotEmpty) {
      return UserMedicineConfig.fromJson(resList.first);
    } else {
      return null;
    }
  }

  /// 根据用户ID以及药物类型获取药物信息列表.
  Future<List<UserMedicineConfig>> getByUserIdAndType(
      int userId, MedicineType type) async {
    List<Map<String, dynamic>> resList = await Global.database.rawQuery(
        '''select * from $_tableName where userId = ? and type = ?''',
        [userId, EnumToString.convertToString(type)]);
    if (resList.isNotEmpty) {
      return resList.map((item) => UserMedicineConfig.fromJson(item)).toList();
    }
    return [];
  }

  /// 新增或修改药物配置信息.
  Future<UserMedicineConfig> saveConfig(UserMedicineConfig config) async {
    await Global.database.insert(_tableName, config.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return config;
  }

  /// 删除设置项.
  Future<void> deleteById(int id) async {
    await Global.database.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }

  /// 删除用户下的所有配置项.
  Future<void> deleteByUserId(int userId) async {
    await Global.database
        .delete(_tableName, where: "userId = ?", whereArgs: [userId]);
  }
}
