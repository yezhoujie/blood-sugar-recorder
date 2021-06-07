import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';

/// 周期内记录抽象service.
abstract class RecordItemService<T extends RecordItem> {
  Future<T> create(T item) async {
    try {
      this._checkCycle(item);
      return await this._doCreate(item);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 确认是否存在正在进行的记录周期，如果不存在则创建一个新周期.
  Future<CycleRecord> _checkCycle(T item) async {
    CycleRecord? cycle =
        await CycleRecordDatasource().getCurrentByUserId(item.userId);
    if (null == cycle) {
      /// 创建一个新记录周期
      CycleRecord newCycle = CycleRecord.byDefault(item.userId);
      return await CycleRecordDatasource().save(newCycle);
    } else {
      return cycle;
    }
  }

  Future<T> _doCreate(T item);
}
