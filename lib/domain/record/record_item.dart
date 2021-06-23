/// 周期内记录项抽象类.
abstract class RecordItem {
  /// -- 主键ID
  int? id;

  ///冗余用户ID
  int userId;

  /// 记录时间.
  DateTime recordTime;

  ///关联周期ID
  int? cycleRecordId;

  RecordItem(
      {this.id, required this.recordTime, required this.userId, this.cycleRecordId});
}
