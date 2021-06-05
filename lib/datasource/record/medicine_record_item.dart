import 'package:blood_sugar_recorder/global.dart';

/// 药物干预记录数据库层.
/// 单例
class MedicineRecordItemDatasource {
  static final MedicineRecordItemDatasource _instance =
      MedicineRecordItemDatasource._internal();

  MedicineRecordItemDatasource._internal();

  factory MedicineRecordItemDatasource() => _instance;

  final String _tableName = "medicine_record_item";

  /// 删除用户下所有药物干预记录.
  Future<void> deleteByUserId(int userId) async {
    await Global.database
        .delete(this._tableName, where: "userId = ?", whereArgs: [userId]);
  }
}
