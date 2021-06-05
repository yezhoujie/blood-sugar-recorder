import 'package:blood_sugar_recorder/global.dart';

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
}
