import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/service/record/record_item.dart';

/// 血糖记录业务处理类.
/// 单例
class BloodSugarRecordService extends RecordItemService<BloodSugarRecordItem> {
  static final BloodSugarRecordService _instance =
      BloodSugarRecordService._internal();

  BloodSugarRecordService._internal();

  factory BloodSugarRecordService() => _instance;

  @override
  Future<void> doDelete(BloodSugarRecordItem item) async {
    if (null != item.id) {
      await BloodSugarRecordItemDatasource().deleteById(item.id!);
    }
  }

  @override
  Future<BloodSugarRecordItem> doSave(BloodSugarRecordItem item) async {
    return await BloodSugarRecordItemDatasource().save(item);
  }
}
