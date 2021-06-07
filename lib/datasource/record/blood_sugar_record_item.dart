import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:sqflite/sqflite.dart';

/// 血糖记录数据库层.
class BloodSugarRecordItemDatasource {
  static final BloodSugarRecordItemDatasource _instance =
      BloodSugarRecordItemDatasource._internal();

  BloodSugarRecordItemDatasource._internal();

  factory BloodSugarRecordItemDatasource() => _instance;

  final String _tableName = "blood_sugar_record_item";

  /// 删除用户下所有的血糖测试记录.
  Future<void> deleteByUserId(int userId) async {
    await Global.database
        .delete(this._tableName, where: "userId = ?", whereArgs: [userId]);
  }

  /// 新增或保存药物干预记录.
  Future<BloodSugarRecordItem> save(BloodSugarRecordItem item) async {
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
  Future<BloodSugarRecordItem?> getById(int id) async {
    List<Map<String, dynamic>> listMap = await Global.database
        .rawQuery("select * from ${this._tableName} where id = ?", [id]);
    if (listMap.isEmpty) {
      return null;
    }
    return BloodSugarRecordItem.fromJson(listMap.first);
  }

  /// 获取一个周期记录下的药物干预记录.
  Future<List<BloodSugarRecordItem>> findByCycleId(int cycleId) async {
    List<Map<String, dynamic>> listMap = await Global.database.rawQuery(
        "select * from ${this._tableName} where cycleRecordId = ? order by recordTime",
        [cycleId]);
    if (listMap.isEmpty) {
      return [];
    }
    return listMap.map((e) => BloodSugarRecordItem.fromJson(e)).toList();
  }

  /// 删除一个周期下的所有药物干预记录.
  Future<void> deleteByCycleId(int cycleId) async {
    await Global.database
        .delete(this._tableName, where: "cycleRecordId = ?", whereArgs: [
      [cycleId]
    ]);
  }

}
