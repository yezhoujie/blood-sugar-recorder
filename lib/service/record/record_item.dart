import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/service/record/cycle_record.dart';

/// 周期内记录抽象service.
abstract class RecordItemService<T extends RecordItem> {
  Future<T> save(T item) async {
    try {
      CycleRecord cycle = await this._checkCycle(item);
      item.cycleRecordId = cycle.id;
      T res = await this.doSave(item);

      /// 更新周期信息.
      await CycleRecordService().refresh(cycle);
      return res;
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 确认是否存在正在进行的记录周期，如果不存在则创建一个新周期.
  Future<CycleRecord> _checkCycle(T item) async {
    CycleRecord? cycle;

    /// 如果明细关联有周期.直接获取周期.
    if (null != item.cycleRecordId) {
      cycle = await CycleRecordDatasource().getById(item.cycleRecordId!);
    }

    /// 如果明细没有关联周期.尝试获取当前未关闭的周期.
    if (null == cycle) {
      cycle = await CycleRecordDatasource().getCurrentByUserId(item.userId);
    }

    ///创建一个新的周期.
    if (null == cycle) {
      cycle = CycleRecord.byDefault(item.userId);
      return await CycleRecordDatasource().save(cycle);
    }

    return cycle;
  }

  Future<T> doSave(T item);

  Future<void> doDelete(T item);

  Future<void> delete(T item) async {
    if (null != item.id) {
      CycleRecord cycle =
          await CycleRecordService().getById(item.cycleRecordId!);
      await this.doDelete(item);
      ///刷新周期数据.
      await CycleRecordService().refresh(cycle);
    }
  }
}
