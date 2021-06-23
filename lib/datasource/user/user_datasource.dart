import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:sqflite/sqflite.dart';

/// 用户数据层
/// 单例
class UserDatasource {
  static final UserDatasource _instance = UserDatasource._internal();

  factory UserDatasource() => _instance;

  UserDatasource._internal();

  final String _tableName = "users";

  /// 保存用户信息.
  Future<User> saveUser(User user) async {
    int id = await Global.database.insert(this._tableName, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    user.id = id;
    return user;
  }

  /// 根据用户ID获取用户信息.
  Future<User?> getById(int id) async {
    List<Map<String, dynamic>> userMapList = await Global.database
        .rawQuery('''select * from $_tableName where id = ?''', [id]);
    if (userMapList.isNotEmpty) {
      return User.fromJson(userMapList.first);
    } else {
      return null;
    }
  }

  /// 获取第一个用户信息.
  /// 用于设置当期用户.
  Future<User?> getFirst() async {
    List<Map<String, dynamic>> userMapList = await Global.database
        .rawQuery('''select * from $_tableName order by id asc limit 1''');
    if (userMapList.isNotEmpty) {
      return User.fromJson(userMapList.first);
    } else {
      return null;
    }
  }

  /// 删除用户.
  Future<void> deleteById(int id) async {
    await Global.database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// 获取所有用户.
  Future<List<User>> findAll() async {
    List<Map<String, dynamic>> userMapList =
        await Global.database.rawQuery('''select * from users''');
    if (userMapList.isNotEmpty) {
      return userMapList.map((e) => User.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
