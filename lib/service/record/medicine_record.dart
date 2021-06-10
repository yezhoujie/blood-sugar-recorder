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

  @override
  Future<void> doDelete(MedicineRecordItem item) async {
    await MedicineRecordItemDatasource().deleteById(item.id!);
  }

  /// 根据周期ID获取药物使用记录列表.
  Future<List<MedicineRecordItem>> findByCycleId(int cycleId) async {
    List<MedicineRecordItem> list =
        await MedicineRecordItemDatasource().findByCycleId(cycleId);
    if (list.isNotEmpty) {
      list = await Future.wait(list.map((e) async {
        if (null != e.medicineId) {
          e.medicine =
              await UserMedicineConfigDatasource().getById(e.medicineId!);
        }
        return e;
      }).toList());
    }
    return list;
  }
}
