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

  /// 获取用户下时间区间内，空腹/餐后的检测记录列表.
  Future<List<BloodSugarRecordItem>> findByUserIdAndFpgAndBetweenDate(
      int userId, DateTime begin, DateTime end, bool fpg) async {
    List<Map<String, dynamic>> listMap = await Global.database.rawQuery(
        "select * from ${this._tableName} where userId = ? and recordTime >= ? and recordTime <= ? and fpg = ? order by recordTime",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String(),
          (fpg ? 1 : 0)
        ]);
    if (listMap.isEmpty) {
      return [];
    }
    return listMap.map((e) => BloodSugarRecordItem.fromJson(e)).toList();
  }

  /// 删除一个周期下的所有药物干预记录.
  Future<void> deleteByCycleId(int cycleId) async {
    await Global.database.delete(this._tableName,
        where: "cycleRecordId = ?", whereArgs: [cycleId]);
  }

  /// 获取用户下时间区域内的所有记录数.
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

  /// 获取用户下时间区间内所有空腹监测记录数.
  Future<int?> countFpgByUserIdAndBetweenDate(
      int userId, DateTime begin, DateTime end) async {
    return await Global.database.rawQuery(
        "select count(*) from $_tableName where userId = ? and recordTime >= ? and recordTime <= ? and fpg = 1",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String()
        ]).then(Sqflite.firstIntValue);
  }

  /// 获取用户下是时间区间内所有餐后检测记录数.
  Future<int?> countHpgByUserIdAndBetweenDate(
      int userId, DateTime begin, DateTime end) async {
    return await Global.database.rawQuery(
        "select count(*) from $_tableName where userId = ? and recordTime >= ? and recordTime <= ? and fpg = 0",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String()
        ]).then(Sqflite.firstIntValue);
  }

  /// 获取用户下时间区间内空腹高血糖的所有记录数.
  Future<int?> countFpgHighRecordByUserIdAndBetweenDate(
      int userId, DateTime begin, DateTime end, double standard) async {
    return await Global.database.rawQuery(
        "select count(*) from $_tableName where userId = ? and recordTime >= ? and recordTime <= ? and bloodSugar > ? and fpg = 1",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String(),
          standard
        ]).then(Sqflite.firstIntValue);
  }

  /// 获取用户下时间区间内餐后高血糖的所有记录数.
  Future<int?> countHpgHighRecordByUserIdAndBetweenDate(
      int userId, DateTime begin, DateTime end, double standard) async {
    return await Global.database.rawQuery(
        "select count(*) from $_tableName where userId = ? and recordTime >= ? and recordTime <= ? and bloodSugar > ? and fpg = 0",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String(),
          standard
        ]).then(Sqflite.firstIntValue);
  }

  /// 获取用户下时间区间内空腹低血糖的所有记录数.
  Future<int?> countFpgLowRecordByUserIdAndBetweenDate(
      int userId, DateTime begin, DateTime end, double standard) async {
    return await Global.database.rawQuery(
        "select count(*) from $_tableName where userId = ? and recordTime >= ? and recordTime <= ? and bloodSugar < ? and fpg = 1",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String(),
          standard
        ]).then(Sqflite.firstIntValue);
  }

  /// 获取用户下时间区间内餐后低血糖的所有记录数.
  Future<int?> countHpgLowRecordByUserIdAndBetweenDate(
      int userId, DateTime begin, DateTime end, double standard) async {
    return await Global.database.rawQuery(
        "select count(*) from $_tableName where userId = ? and recordTime >= ? and recordTime <= ? and bloodSugar < ? and fpg = 0",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String(),
          standard
        ]).then(Sqflite.firstIntValue);
  }

  /// 获取用户下时间区间内最高血糖记录.
  Future<double?> getMaxByUserIdAndFpgAndBetweenDate(
      int userId, DateTime begin, DateTime end, bool fpg) async {
    List<Map<String, dynamic>> listMap = await Global.database.rawQuery(
        "select max(bloodSugar) as bloodSugar from ${this._tableName} where userId = ? and recordTime >= ? and recordTime <= ? and fpg = ? order by recordTime",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String(),
          (fpg ? 1 : 0)
        ]);
    if (listMap.isEmpty) {
      return null;
    }
    return listMap.map((e) => e.values.first).first;
  }

  /// 获取用户下时间区间内最低血糖记录.
  Future<double?> getMinByUserIdAndFpgAndBetweenDate(
      int userId, DateTime begin, DateTime end, bool fpg) async {
    List<Map<String, dynamic>> listMap = await Global.database.rawQuery(
        "select min(bloodSugar) as bloodSugar from ${this._tableName} where userId = ? and recordTime >= ? and recordTime <= ? and fpg = ?",
        [
          userId,
          begin.toIso8601String(),
          end.toIso8601String(),
          (fpg ? 1 : 0)
        ]);
    if (listMap.isEmpty) {
      return null;
    }
    return listMap.map((e) => e.values.first).first;
  }
}
