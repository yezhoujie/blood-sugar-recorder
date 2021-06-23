import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/service/record/record_item.dart';

class FoodRecordService extends RecordItemService<FoodRecordItem> {
  static final FoodRecordService _instance = FoodRecordService._internal();

  FoodRecordService._internal();

  factory FoodRecordService() => _instance;

  @override
  Future<void> doDelete(FoodRecordItem item) async {
    if (null != item.id) {
      await FoodRecordItemDatasource().deleteById(item.id!);
    }
  }

  @override
  Future<FoodRecordItem> doSave(FoodRecordItem item) async {
    return await FoodRecordItemDatasource().save(item);
  }
}
