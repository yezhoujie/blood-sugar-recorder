import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:sqflite/sqflite.dart';

/// 进食记录数据库层.
/// 单例.
class FoodRecordItemDatasource {
  static final FoodRecordItemDatasource _instance =
      FoodRecordItemDatasource._internal();

  FoodRecordItemDatasource._internal();

  factory FoodRecordItemDatasource() => _instance;

  final String _tableName = "food_record_item";

  /// 删除用户下所有的进食记录.
  Future<void> deleteByUserId(int userId) async {
    await Global.database
        .delete(this._tableName, where: "userId = ?", whereArgs: [userId]);
  }

  /// 新增或保存药物干预记录.
  Future<FoodRecordItem> save(FoodRecordItem item) async {
    int id = await Global.database.insert(this._tableName, item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    item.id = id;
    return item;
  }

  /// 根据ID 删除记录.
  Future<void> deleteById(int id) async {
    await Global.database
        .delete(this._tableName, where: "id = ?", whereArgs: [id]);
  }

  /// 根据ID 获取记录.
  Future<FoodRecordItem?> getById(int id) async {
    List<Map<String, dynamic>> listMap = await Global.database
        .rawQuery("select * from ${this._tableName} where id = ?", [id]);
    if (listMap.isEmpty) {
      return null;
    }
    return FoodRecordItem.fromJson(listMap.first);
  }

  /// 获取一个周期记录下的药物干预记录.
  Future<List<FoodRecordItem>> findByCycleId(int cycleId) async {
    List<Map<String, dynamic>> listMap = await Global.database.rawQuery(
        "select * from ${this._tableName} where cycleRecordId = ? order by recordTime",
        [cycleId]);
    if (listMap.isEmpty) {
      return [];
    }
    return listMap.map((e) => FoodRecordItem.fromJson(e)).toList();
  }

  /// 删除一个周期下的所有药物干预记录.
  Future<void> deleteByCycleId(int cycleId) async {
    await Global.database.delete(this._tableName,
        where: "cycleRecordId = ?", whereArgs: [cycleId]);
  }

  /// 获取用户下，时间区间内所有记录总数.
  Future<int?> countByUserIdAndBetweenDate(
      int userId, DateTime begin, DateTime end) async {
    return await Global.database.rawQuery(
        "select count(*) from $_tableName where userId = ? and recordTime >= ? and recordTime <= ?",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String()
        ]).then(Sqflite.firstIntValue);
  }
}
