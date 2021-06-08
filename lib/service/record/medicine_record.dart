import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/service/record/record_item.dart';

/// 药物记录业务层.
/// 单例.
class MedicineRecordService extends RecordItemService<MedicineRecordItem> {
  static final MedicineRecordService _instance =
      MedicineRecordService._internal();

  MedicineRecordService._internal();

  factory MedicineRecordService() => _instance;

  /// 保存到数据库.
  @override
  Future<MedicineRecordItem> doSave(MedicineRecordItem item) async {
    return await MedicineRecordItemDatasource().save(item);
  }
}
