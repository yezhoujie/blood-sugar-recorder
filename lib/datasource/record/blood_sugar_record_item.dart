import 'package:blood_sugar_recorder/global.dart';

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
}
