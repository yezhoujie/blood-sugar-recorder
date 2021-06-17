import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/domain/record/cycle_record.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:sqflite/sqflite.dart';

/// 血糖记录周期数据库层.
/// 单例.
class CycleRecordDatasource {
  static final CycleRecordDatasource _instance =
      CycleRecordDatasource._internal();

  CycleRecordDatasource._internal();

  factory CycleRecordDatasource() => _instance;

  final String _tableName = "cycle_record";

  /// 删除用户下所有的血糖记录周期.
  Future<void> deleteByUserId(int userId) async {
    await Global.database
        .delete(this._tableName, where: "userId = ?", whereArgs: [userId]);
  }

  /// 获取当前正在进行的记录周期.
  Future<CycleRecord?> getCurrentByUserId(int userId) async {
    List<Map<String, dynamic>> cycleMapList = await Global.database.rawQuery(
        "select * from ${this._tableName} where userId = ? and closed = 0 order by id limit 1",
        [userId]);

    if (cycleMapList.isEmpty) {
      return null;
    }
    return CycleRecord.fromJson(cycleMapList.first);
  }

  /// 新增或保存记录周期记录.
  Future<CycleRecord> save(CycleRecord item) async {
    int id = await Global.database.insert(this._tableName, item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    item.id = id;
    return item;
  }

  /// 通过id获取记录周期信息.
  Future<CycleRecord?> getById(int id) async {
    List<Map<String, dynamic>> listMap = await Global.database
        .rawQuery("select * from ${this._tableName} where id = ?", [id]);

    if (listMap.isEmpty) {
      return null;
    }
    return CycleRecord.fromJson(listMap.first);
  }

  /// 通过id删除记录周期信息.
  Future<void> deleteById(int id) async {
    await Global.database
        .delete(this._tableName, where: "id = ?", whereArgs: [id]);
  }

  /// 获取某个时间之后的指定数量的记录.
  Future<List<CycleRecord>> findLimitByFrom(
      {required int userId, required DateTime start, int limit = 20}) async {
    List<Map<String, dynamic>> listMap = await Global.database.rawQuery(
        "select * from ${this._tableName} where userId = ? and datetime > ? order by datetime limit ?",
        [userId, start.toIso8601String(), limit]);
    if (listMap.isEmpty) {
      return [];
    } else {
      return listMap
          .map((e) => CycleRecord.fromJson(e))
          .toList()
          .reversed
          .toList();
    }
  }

  /// 获取某个时间之前的指定数量的记录.
  Future<List<CycleRecord>> findLimitByBefore(
      {required int userId, required DateTime start, int limit = 20}) async {
    List<Map<String, dynamic>> listMap = await Global.database.rawQuery(
        "select * from ${this._tableName} where userId = ? and datetime < ? order by datetime desc limit ?",
        [userId, start.toIso8601String(), limit]);
    if (listMap.isEmpty) {
      return [];
    } else {
      return listMap.map((e) => CycleRecord.fromJson(e)).toList();
    }
  }

  Future<CycleRecord?> getLatestClosedByUserId(int userId) async {
    List<Map<String, dynamic>> listMap = await Global.database.rawQuery(
        "select * from ${this._tableName} where userId = ? order by datetime desc limit 1",
        [userId]);
    if (listMap.isEmpty) {
      return null;
    }
    return CycleRecord.fromJson(listMap.first);
  }
}
