import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/pages/stats/stats.dart';

/// 统计数据service层.
/// 单例.
class StatsService {
  static final StatsService _instance = StatsService._internal();

  StatsService._internal();

  factory StatsService() => _instance;

  Future<Stats> getStatsData({
    required int userId,
    required DateTime begin,
    required DateTime end,
    required StatEnum statType,
  }) async {
    try {
      /// 获取记录天数.
      int? days = await CycleRecordDatasource()
          .countDistinctDaysByUserIdAndBetweenDate(userId, begin, end);

      int breakDays = 0;

      /// 计算中断天数.
      if(statType == StatEnum.ALL){
        List<CycleRecord> firstList = await CycleRecordDatasource()
            .findLimitByFrom(userId: userId, start: begin, limit: 1);
        if (firstList.isNotEmpty) {
          int totalDays = end.difference(firstList.first.datetime!).inDays;
          breakDays = totalDays - (days ?? 0) + 1;
        }
      }else{
        int totalDays = end.difference(begin).inDays;
        breakDays = totalDays - (days ?? 0) + 1;
      }


      /// 计算药物使用记录数.
      int? medicineRecordNum = await MedicineRecordItemDatasource()
          .countByUserIdAndBetweenDate(userId, begin, end);

      /// 药物使用记录数.
      int? foodRecordNum = await FoodRecordItemDatasource()
          .countByUserIdAndBetweenDate(userId, begin, end);

      /// 获取血糖记录数.
      int? bloodSugarRecordNum = await BloodSugarRecordItemDatasource()
          .countByUserIdAndBetweenDate(userId, begin, end);

      /// 获取空腹血糖记录数.
      int? fpgBloodSugarRecordNum = await BloodSugarRecordItemDatasource()
          .countFpgByUserIdAndBetweenDate(userId, begin, end);

      /// 获取餐后血糖记录数.
      int? hpgBloodSugarRecordNum = await BloodSugarRecordItemDatasource()
          .countHpgByUserIdAndBetweenDate(userId, begin, end);

      /// 获取当前用户下的血糖指标.
      UserBloodSugarConfig config =
          (await UserBloodSugarConfigDatasource().getByUserId(userId) ??
              UserBloodSugarConfig.byDefault(userId));

      /// 获取空腹高血糖记录数.
      int? fpgHighBloodSugarRecordNum = await BloodSugarRecordItemDatasource()
          .countFpgHighRecordByUserIdAndBetweenDate(
              userId, begin, end, config.fpgMax);

      /// 获取空腹低血糖记录数.
      int? fpgLowBloodSugarRecordNum = await BloodSugarRecordItemDatasource()
          .countFpgLowRecordByUserIdAndBetweenDate(
              userId, begin, end, config.fpgMin);

      /// 获取餐后高血糖记录数.
      int? hpgHighBloodSugarRecordNum = await BloodSugarRecordItemDatasource()
          .countHpgHighRecordByUserIdAndBetweenDate(
              userId, begin, end, config.hpg2Max);

      /// 获取餐后低血糖记录数.
      int? hpgLowBloodSugarRecordNum = await BloodSugarRecordItemDatasource()
          .countHpgLowRecordByUserIdAndBetweenDate(
              userId, begin, end, config.hpg2Min);

      /// 高血糖记录总数.
      int highBloodSugarRecordNum =
          (fpgHighBloodSugarRecordNum ?? 0) + (hpgHighBloodSugarRecordNum ?? 0);

      /// 低血糖记录总数.
      int lowBloodSugarRecordNum =
          (fpgLowBloodSugarRecordNum ?? 0) + (hpgLowBloodSugarRecordNum ?? 0);

      List<BloodSugarRecordItem> fpgRecordList = [];
      List<BloodSugarRecordItem> hpgRecordList = [];

      /// 空腹血糖监测记录列表数据.
      if (statType != StatEnum.ALL) {
        /// 获取空腹血糖检测列表.
        fpgRecordList = await BloodSugarRecordItemDatasource()
            .findByUserIdAndFpgAndBetweenDate(userId, begin, end, true);

        /// 获取餐后血糖检测列表.
        hpgRecordList = await BloodSugarRecordItemDatasource()
            .findByUserIdAndFpgAndBetweenDate(userId, begin, end, false);
      }

      double? fpgBloodSugarMax;
      double? fpgBloodSugarMin;
      double? hpgBloodSugarMax;
      double? hpgBloodSugarMin;

      /// 获取空腹最高血糖
      fpgBloodSugarMax = await BloodSugarRecordItemDatasource()
          .getMaxByUserIdAndFpgAndBetweenDate(userId, begin, end, true);

      /// 获取空腹最低血糖
      fpgBloodSugarMin = await BloodSugarRecordItemDatasource()
          .getMinByUserIdAndFpgAndBetweenDate(userId, begin, end, true);

      /// 获取餐后最高血糖
      hpgBloodSugarMax = await BloodSugarRecordItemDatasource()
          .getMaxByUserIdAndFpgAndBetweenDate(userId, begin, end, false);

      /// 获取餐后最低血糖
      hpgBloodSugarMin = await BloodSugarRecordItemDatasource()
          .getMinByUserIdAndFpgAndBetweenDate(userId, begin, end, false);
      Stats res = Stats(
        recordDays: days ?? 0,
        breakDays: breakDays,
        medicineRecordNum: medicineRecordNum ?? 0,
        foodRecordNum: foodRecordNum ?? 0,
        bloodSugarRecordNum: bloodSugarRecordNum ?? 0,
        highBloodSugarRecordNum: highBloodSugarRecordNum,
        lowBloodSugarRecordNum: lowBloodSugarRecordNum,
        fpgBloodSugarRecordNum: fpgBloodSugarRecordNum ?? 0,
        fpgHighBloodSugarRecordNum: fpgHighBloodSugarRecordNum ?? 0,
        fpgLowBloodSugarRecordNum: fpgLowBloodSugarRecordNum ?? 0,
        hpgBloodSugarRecordNum: hpgBloodSugarRecordNum ?? 0,
        hpgHighBloodSugarRecordNum: hpgHighBloodSugarRecordNum ?? 0,
        hpgLowBloodSugarRecordNum: hpgLowBloodSugarRecordNum ?? 0,
        standard: config,
        fpgRecordList: fpgRecordList,
        hpgRecordList: hpgRecordList,
        fpgBloodSugarMax: fpgBloodSugarMax,
        fpgBloodSugarMin: fpgBloodSugarMin,
        hpgBloodSugarMax: hpgBloodSugarMax,
        hpgBloodSugarMin: hpgBloodSugarMin,
      );
      return res;
    } catch (exception) {
      throw ErrorData(
          code: ErrorData.errorCodeMap['INTERNAL_ERROR']!,
          message: "糟糕！程序出错了,请刷新后重试");
    }
  }
}
