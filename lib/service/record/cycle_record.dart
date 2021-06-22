import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/domain/record/record_item.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/service/record/medicine_record.dart';

///记录周期service层.
///单例.
class CycleRecordService {
  static const MAX_ITEM_COUNT = 10;
  static final CycleRecordService _instance = CycleRecordService._internal();

  CycleRecordService._internal();

  factory CycleRecordService() => _instance;

  /// 根据用户ID获取当前正在进行的记录周期.
  Future<CycleRecord?> getCurrentByUserId(int userId) async {
    try {
      CycleRecord? cycle =
          await CycleRecordDatasource().getCurrentByUserId(userId);
      if (null == cycle) {
        /// 获取去最近一次结束的周期记录.
        cycle = await CycleRecordDatasource().getLatestClosedByUserId(userId);
      }

      if (null != cycle) {
        /// 如果存在当前正在进行的记录周期，获取周期内的详细记录.
        List<RecordItem> itemList = await this.findItemsById(cycle.id!);
        cycle.itemList = itemList;
      }
      return cycle;
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 根据id获取周期记录.
  Future<CycleRecord> getById(int id) async {
    try {
      CycleRecord? res = await CycleRecordDatasource().getById(id);
      if (res == null) {
        throw ErrorData(
            code: ErrorData.errorCodeMap["NOT_FOUND"]!,
            message: "记录周期不见了,请刷新再试一次");
      }
      return res;
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 单独保存周期数据.
  Future<CycleRecord> save(CycleRecord record) async {
    try {
      return CycleRecordDatasource().save(record);
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 保存周期数据以及周期下的记录数据.
  Future<CycleRecord> saveWithItems(
      CycleRecord record, List<RecordItem> itemList) async {
    try {
      record = await this.save(record);

      if (itemList.isNotEmpty) {
        /// 按照时间先后顺序排序
        itemList.sort((a, b) => a.recordTime.compareTo(b.recordTime));

        /// 保存周期内记录项.
        await Future.wait(
          itemList.map((e) async {
            e.cycleRecordId = record.id;
            if (e is MedicineRecordItem) {
              MedicineRecordItemDatasource().save(e);
            } else if (e is FoodRecordItem) {
              FoodRecordItemDatasource().save(e);
            } else if (e is BloodSugarRecordItem) {
              BloodSugarRecordItemDatasource().save(e);
            }
          }),
        );
        // print("items saved!");
      }

      /// 周期默认关闭.
      record.closed = true;

      /// 周期内最后一次详细记录的时间为周期时间.
      record.datetime = itemList.last.recordTime;
      record = await this.save(record);

      return record;
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }

  /// 根据根据周期内的明细记录，更新该周期的时间.
  Future<void> refresh(CycleRecord cycle) async {
    List<RecordItem> itemList = await this.findItemsById(cycle.id!);
    if (itemList.isEmpty) {
      /// 如果周期内一条明细记录都没有，删除该周期数据.
      await this.deleteById(cycle.id!);
    } else {
      /// 无论周期是否关闭，始终更新周期时间.
      itemList.sort((a, b) => a.recordTime.compareTo(b.recordTime));
      cycle.datetime = itemList.last.recordTime;
      await this.save(cycle);
    }
  }

  /// 只删除周期记录.
  Future<void> deleteById(int id) async {
    await CycleRecordDatasource().deleteById(id);
  }

  /// 删除周期数据以及周期内所有明细记录.
  Future<void> deleteWithItemsById(int id) async {
    await MedicineRecordItemDatasource().deleteByCycleId(id);
    await FoodRecordItemDatasource().deleteByCycleId(id);
    await BloodSugarRecordItemDatasource().deleteByCycleId(id);
    await this.deleteById(id);
  }

  /// 关闭周期.
  Future<void> close(CycleRecord cycle) async {
    cycle.closed = true;
    await this.save(cycle);
    await this.refresh(cycle);
  }

  /// 获取周期内的明细记录列表.
  Future<List<RecordItem>> findItemsById(int id) async {
    List<List<RecordItem>> list = await Future.wait<List<RecordItem>>([
      MedicineRecordService().findByCycleId(id),
      FoodRecordItemDatasource().findByCycleId(id),
      BloodSugarRecordItemDatasource().findByCycleId(id)
    ]);
    List<RecordItem> itemList = list.expand((element) => element).toList()
      ..sort((a, b) => a.recordTime.compareTo(b.recordTime));
    return itemList;
  }

  /// 判断是否可以在一个周期内继续添加明细记录.
  Future<bool> canAddItem(int id) async {
    return (await findItemsById(id)).length < MAX_ITEM_COUNT;
  }

  /// 获取周期分页信息.
  /// [userId] 当前用户信息.
  /// [beginDate] 开始时间,只精确到天.
  /// [next] 是否获[beginDate]取时间之后的记录.
  Future<List<CycleRecord>> findPage(
      int userId, bool next, DateTime beginDate) async {
    List<CycleRecord> cycleList = [];
    if (next) {
      cycleList = await CycleRecordDatasource()
          .findLimitByFrom(userId: userId, start: beginDate, limit: 10);
    } else {
      cycleList = await CycleRecordDatasource()
          .findLimitByBefore(userId: userId, start: beginDate, limit: 10);
    }

    /// 过滤未完成的周期.
    cycleList = cycleList.where((element) => element.closed).toList();

    /// 获取周期内的明细记录.
    if (cycleList.isNotEmpty) {
      for (var value in cycleList) {
        value.itemList = await this.findItemsById(value.id!);
      }
    }
    return cycleList;
  }
}
