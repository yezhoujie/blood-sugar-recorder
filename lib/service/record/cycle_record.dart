import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/domain/record/record_item.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';

///记录周期service层.
///单例.
class CycleRecordService {
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
        List<List<RecordItem>> list = await Future.wait<List<RecordItem>>([
          MedicineRecordItemDatasource().findByCycleId(cycle.id!),
          FoodRecordItemDatasource().findByCycleId(cycle.id!),
          BloodSugarRecordItemDatasource().findByCycleId(cycle.id!)
        ]);
        List<RecordItem> itemList = list.expand((element) => element).toList()
          ..sort((a, b) => a.recordTime.compareTo(b.recordTime));
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
            print("save items ${e.runtimeType}");
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
        print("items saved!");
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
}