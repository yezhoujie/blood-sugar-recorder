import 'package:blood_sugar_recorder/global.dart';

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
}
