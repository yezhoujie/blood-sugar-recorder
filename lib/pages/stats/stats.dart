import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/pages/stats/stats_num_widget.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// 统计分页页面.
class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  /// 默认统计类型为总览.
  StatEnum _type = StatEnum.ALL;

  User _currentUser = Global.currentUser!;

  Stats _statsData = Stats(
      recordDays: 0,
      breakDays: 0,
      medicineRecordNum: 0,
      foodRecordNum: 0,
      bloodSugarRecordNum: 0,
      highBloodSugarRecordNum: 0,
      lowBloodSugarRecordNum: 0,
      fpgBloodSugarRecordNum: 0,
      fpgHighBloodSugarRecordNum: 0,
      fpgLowBloodSugarRecordNum: 0,
      hpgBloodSugarRecordNum: 0,
      hpgHighBloodSugarRecordNum: 0,
      hpgLowBloodSugarRecordNum: 0,
      standard: UserBloodSugarConfig.byDefault(Global.currentUser!.id!),
      fpgRecordList: [],
      hpgRecordList: []);

  List<PieChartData> _bloodPeiChartList = [];
  List<PieChartData> _fpgBloodPeiChartList = [];
  List<PieChartData> _hpgBloodPeiChartList = [];

  DateTime _begin =
      DateFormat("yyyy-mm-dd HH:mm:ss").parse("1922-01-01 00:00:00");

  DateTime _end = DateTime.now();

  ScrollController _scrollController = ScrollController();

  TooltipBehavior _pieChartTooltipBehavior = TooltipBehavior(
    enable: true,
    textStyle: TextStyle(
      fontSize: 20.sp,
    ),
  );

  ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true);

  var _lineTooltipBehavior = TooltipBehavior(
    enable: true,
    textStyle: TextStyle(
      fontSize: 20.sp,
    ),
    builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
        int seriesIndex) {
      point as CartesianChartPoint;
      DateTime time = DateTime.fromMillisecondsSinceEpoch(point.xValue);
      return seriesIndex == 0
          ? Container(
              color: Colors.black87,
              child: Text(
                '${DateFormat("yyyy-MM-dd HH:mm").format(time)} \n ${(data as BloodSugarRecordItem).bloodSugar} mmol/L',
                style: TextStyle(
                  fontSize: 25.sp,
                  color: Colors.white,
                ),
              ),
            )
          : Container();
    },
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    /// 注册监听
    UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);
    this._dataRefresh();
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            _buildTabButtons(),
            _buildTimePicker(),
            _buildStatPage(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._loadData();
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }

  //////////////UI构建区域///////////////

  /// 构建顶部统计类型选择tab.
  _buildTabButtons() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        width: 330.w,
        height: 35.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: [Shadows.primaryShadow],
          borderRadius: RadiusConstant.k6pxRadius,
          border: Border.all(color: Colors.amber, width: 1.8),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: StatEnum.values
              .map(
                (e) => Expanded(
                  child: InkWell(
                    onTap: () {
                      DateTime begin = _begin;
                      DateTime end = _end;
                      switch (e) {
                        case StatEnum.ALL:
                          begin = DateFormat("yyyy-mm-dd HH:mm:ss")
                              .parse("1922-01-01 00:00:00");
                          end = DateTime.now();
                          break;
                        case StatEnum.MONTH:
                          DateTime tmp = DateTime.now();
                          begin = DateTime(
                            tmp.year,
                            tmp.month,
                          );
                          end = tmp;
                          break;
                        case StatEnum.YEAR:
                          DateTime tmp = DateTime.now();
                          begin = DateTime(
                            tmp.year,
                          );
                          end = tmp;
                          break;
                        case StatEnum.CUSTOM:
                          DateTime tmp = DateTime.now();
                          begin = tmp.subtract(Duration(days: 30));
                          begin = DateTime(begin.year, begin.month, begin.day);
                          end = tmp;
                          break;
                      }
                      this._type = e;
                      this._begin = begin;
                      this._end = end;
                      this._loadData();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: e == this._type ? Colors.amber : Colors.white,
                        // border: Border.all(color: Colors.amber, width: 1.8),
                        border: e == StatEnum.CUSTOM
                            ? null
                            : Border(
                                right:
                                    BorderSide(width: 1.8, color: Colors.amber),
                              ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _getTabTitle(e),
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: e == this._type
                              ? Colors.white
                              : AppColor.thirdElementText,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// 根据枚举类型获取枚举的中文名称.
  String _getTabTitle(StatEnum e) {
    switch (e) {
      case StatEnum.ALL:
        return "总览";
      case StatEnum.MONTH:
        return "月度";
      case StatEnum.YEAR:
        return "年度";
      default:
        return "自定义";
    }
  }

  /// 构建统计结果展示内容
  _buildStatPage() {
    return Expanded(
      child: SingleChildScrollView(
        controller: this._scrollController,
        padding: EdgeInsets.only(right: 25.w, left: 25.w, top: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 连续记录天数，中断记录天数行
            _buildRecordDaysRow(),
            Divider(
              thickness: 1.5,
            ),
            SizedBox(
              height: 40.h,
            ),
            _buildOtherDetailsRow(),
            Divider(
              thickness: 1.5,
            ),
            SizedBox(
              height: 40.h,
            ),

            /// 血糖记录次数.
            _buildBloodSugarRow(),
            Divider(
              thickness: 1.5,
            ),
            SizedBox(
              height: 40.h,
            ),

            /// 血糖，空腹次数
            _buildFpgBloodSugarRow(),

            SizedBox(
              height: 10.h,
            ),

            /// 血糖，空腹超标次数
            _buildFpgBloodSugarStandardRow(),

            SizedBox(
              height: 10.h,
            ),
            _buildFpgBloodSugarTopRow(),

            Divider(
              thickness: 1.5,
            ),
            SizedBox(
              height: 40.h,
            ),

            /// 血糖，餐后次数
            _buildHpgBloodSugarRow(),

            SizedBox(
              height: 10.h,
            ),

            /// 血糖，餐后超标次数.
            _buildHpgBloodSugarStandardRow(),
            SizedBox(
              height: 10.h,
            ),
            _buildHpgBloodSugarTopRow(),

            Divider(
              thickness: 1.5,
            ),
            SizedBox(
              height: 40.h,
            ),

            /// 图表区域.
            this._buildPieChart(
              context,
              title: "血糖分布",
              dataList: this._bloodPeiChartList,
            ),

            Divider(
              thickness: 1.5,
            ),
            SizedBox(
              height: 40.h,
            ),
            this._buildPieChart(
              context,
              title: "空腹血糖分布",
              dataList: this._fpgBloodPeiChartList,
            ),

            SizedBox(
              height: 10.h,
            ),

            if (this._type != StatEnum.ALL)
              this._buildLineChart(
                context,
                title: "空腹血糖趋势",
                dataList: this._statsData.fpgRecordList,
                maxStandard: this._statsData.standard.fpgMax,
                minStandard: this._statsData.standard.fpgMin,
              ),

            Divider(
              thickness: 1.5,
            ),
            SizedBox(
              height: 40.h,
            ),

            this._buildPieChart(
              context,
              title: "餐后血糖分布",
              dataList: this._hpgBloodPeiChartList,
            ),

            if (this._type != StatEnum.ALL)
              this._buildLineChart(
                context,
                title: "餐后血糖趋势",
                dataList: this._statsData.hpgRecordList,
                maxStandard: this._statsData.standard.hpg2Max,
                minStandard: this._statsData.standard.hpg2Min,
              ),
          ],
        ),
      ),
    );
  }

  /// 构建记录天数，中断天数数据行.
  _buildRecordDaysRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 记录天数
        StatsNumWidget(
          title: "记录天数",
          num: this._statsData.recordDays,
          unit: "天",
          numColor: Colors.green,
        ),

        /// 中断天数.
        StatsNumWidget(
          title: "中断天数",
          num: this._statsData.breakDays,
          numColor: Colors.redAccent,
          unit: "天",
        ),
      ],
    );
  }

  /// 构建血糖明细记录次数
  _buildBloodSugarRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 血糖记录天数
        StatsNumWidget(
            title: "血糖记录次数",
            num: this._statsData.bloodSugarRecordNum,
            numColor: Colors.green,
            unit: "次"),
      ],
    );
  }

  /// 构建空腹血糖检测次数.
  _buildFpgBloodSugarRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 空腹监测次数.
        StatsNumWidget(
          title: "空腹检测数",
          num: this._statsData.fpgBloodSugarRecordNum,
          numColor: Colors.green,
          unit: "次",
        ),
      ],
    );
  }

  /// 构建空腹血糖检测高低血糖次数.
  _buildFpgBloodSugarStandardRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 空腹高血糖次数.
        StatsNumWidget(
          title: "空腹高血糖",
          num: this._statsData.fpgHighBloodSugarRecordNum,
          numColor: Colors.redAccent,
          unit: "次",
        ),
        StatsNumWidget(
          title: "空腹低血糖",
          num: this._statsData.fpgLowBloodSugarRecordNum,
          numColor: Colors.blue,
          unit: "次",
        ),
      ],
    );
  }

  /// 构建空腹血糖检测最高/最低数值.
  _buildFpgBloodSugarTopRow() {
    // todo, 超标了，才显示红色和蓝色.
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatsNumWidget(
          title: "空腹血糖最高",
          num: this._statsData.fpgBloodSugarMax,
          numColor: Colors.redAccent,
          unit: "mmol/L",
        ),
        StatsNumWidget(
          title: "空腹血糖最低",
          num: this._statsData.fpgBloodSugarMin,
          numColor: Colors.blue,
          unit: "mmol/L",
        ),
      ],
    );
  }

  /// 构建餐后血糖检测次数.
  _buildHpgBloodSugarRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 餐后血糖监测次数.
        StatsNumWidget(
          title: "餐后检测数",
          num: this._statsData.hpgBloodSugarRecordNum,
          numColor: Colors.green,
          unit: "次",
        ),
      ],
    );
  }

  /// 构建餐后血糖检测高低血糖次数.
  _buildHpgBloodSugarStandardRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 餐后高血糖监测次数.
        StatsNumWidget(
          title: "餐后高血糖",
          num: this._statsData.hpgHighBloodSugarRecordNum,
          numColor: Colors.redAccent,
          unit: "次",
        ),

        /// 餐后低血糖监测次数.
        StatsNumWidget(
          title: "餐后低血糖",
          num: this._statsData.hpgLowBloodSugarRecordNum,
          numColor: Colors.blue,
          unit: "次",
        ),
      ],
    );
  }

  /// 构建餐后血糖检测最高/最低数值.
  _buildHpgBloodSugarTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatsNumWidget(
          title: "餐后血糖最高",
          num: this._statsData.hpgBloodSugarMax,
          numColor: Colors.redAccent,
          unit: "mmol/L",
        ),
        StatsNumWidget(
          title: "餐后血糖最低",
          num: this._statsData.hpgBloodSugarMin,
          numColor: Colors.blue,
          unit: "mmol/L",
        ),
      ],
    );
  }

  /// 构建药物，用餐记录次数.
  _buildOtherDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatsNumWidget(
          title: "用药记录数",
          num: this._statsData.medicineRecordNum,
          numColor: Colors.green,
          unit: "次",
        ),
        StatsNumWidget(
          title: "用餐记录数",
          num: this._statsData.foodRecordNum,
          numColor: Colors.green,
          unit: "次",
        ),
      ],
    );
  }

  /// 构建饼图.
  Widget _buildPieChart(BuildContext context,
      {required String title, required List<PieChartData> dataList}) {
    Widget chart;
    if (dataList.isNotEmpty) {
      chart = SfCircularChart(
        key: ValueKey(title),
        title: ChartTitle(
            text: title,
            textStyle: TextStyle(
              fontSize: 25.sp,
              color: AppColor.thirdElementText,
            )),
        legend: Legend(
            isVisible: true,
            iconHeight: 20.w,
            iconWidth: 20.w,
            textStyle: TextStyle(
              fontSize: 20.sp,
              color: AppColor.thirdElementText,
            ),
            overflowMode: LegendItemOverflowMode.wrap),
        tooltipBehavior: this._pieChartTooltipBehavior,
        series: <PieSeries<PieChartData, String>>[
          PieSeries<PieChartData, String>(
            pointColorMapper: (data, _) => data.color,
            enableSmartLabels: true,
            dataSource: dataList,
            enableTooltip: true,

            /// legend label.
            xValueMapper: (data, _) => "${data.title}",

            /// 数据.
            yValueMapper: (data, _) => data.recordNum,
            dataLabelMapper: (data, _) =>
                "${data.title}:\n${data.recordNum}次\n${data.percent}%",
            dataLabelSettings: DataLabelSettings(
              labelIntersectAction: LabelIntersectAction.none,
              textStyle: TextStyle(
                fontSize: 20.sp,
              ),
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
              useSeriesColor: true,
              connectorLineSettings: ConnectorLineSettings(
                length: "10",
                // Type of the connector line
                type: ConnectorType.curve,
              ),
            ),
          ),
        ],
      );
    } else {
      chart = Center(
        child: Text(
          "$title:\n暂无数据",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35.sp,
            color: AppColor.thirdElementText,
          ),
        ),
      );
    }
    return Container(
      height: 450.h,
      width: MediaQuery.of(context).size.width,
      child: chart,
    );
  }

  /// 构建折线图.
  Widget _buildLineChart(
    BuildContext context, {
    required String title,
    required List<BloodSugarRecordItem> dataList,
    required double maxStandard,
    required double minStandard,
  }) {
    Widget chart;
    if (dataList.isNotEmpty) {
      List<double> maxLine = dataList.map((e) => maxStandard).toList();
      List<double> minLine = dataList.map((e) => minStandard).toList();
      chart = SfCartesianChart(
        palette: <Color>[Colors.amber, Colors.redAccent, Colors.blue],
        // Chart title text
        title: ChartTitle(
            text: title,
            textStyle: TextStyle(
              fontSize: 25.sp,
              color: AppColor.thirdElementText,
            )),
        // Initialize category axis
        primaryXAxis: DateTimeAxis(
          labelStyle: TextStyle(fontSize: 15.sp),
          dateFormat: DateFormat('yy/MM'),
        ),
        tooltipBehavior: this._lineTooltipBehavior,
        zoomPanBehavior: this._zoomPanBehavior,
        series: <ChartSeries>[
          // Initialize line series
          FastLineSeries<BloodSugarRecordItem, DateTime>(
            name: "空腹血糖",
            dataSource: dataList,

            /// x轴, 时间.
            xValueMapper: (data, index) => data.recordTime,
            yValueMapper: (data, _) => data.bloodSugar,
            dataLabelSettings: DataLabelSettings(
              textStyle: TextStyle(
                fontSize: 20.sp,
              ),
              isVisible: true,
              // labelPosition: ChartDataLabelPosition.inside,
              useSeriesColor: true,
              // connectorLineSettings: ConnectorLineSettings(
              //   length: "10",
              //   // Type of the connector line
              //   type: ConnectorType.curve,
              // ),
            ),
          ),

          /// 指标线上限
          FastLineSeries<double, DateTime>(
            name: "上限指标",
            dataSource: maxLine,

            /// x轴, 时间.
            xValueMapper: (_, index) => dataList[index].recordTime,
            yValueMapper: (data, _) => data,
            dataLabelSettings: DataLabelSettings(
              isVisible: false,
            ),
          ),

          /// 指标线下限
          FastLineSeries<double, DateTime>(
            name: "下线指标",
            dataSource: minLine,

            /// x轴, 时间.
            xValueMapper: (_, index) => dataList[index].recordTime,
            yValueMapper: (data, _) => data,
            dataLabelSettings: DataLabelSettings(
              isVisible: false,
            ),
          ),
        ],
      );
    } else {
      chart = Center(
        child: Text(
          "$title:\n暂无数据",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 35.sp,
            color: AppColor.thirdElementText,
          ),
        ),
      );
    }

    return Container(
      height: 300.h,
      width: MediaQuery.of(context).size.width,
      child: chart,
    );
  }

  _buildTimePicker() {
    DateFormat dateFormat;
    String begin = "";
    String end = "";
    if (this._type == StatEnum.ALL) {
      return Container();
    } else {
      switch (this._type) {
        case StatEnum.CUSTOM:
          dateFormat = DateFormat("yyyy-MM-dd");
          begin = dateFormat.format(this._begin);
          end = dateFormat.format(this._end);
          break;
        case StatEnum.YEAR:
          dateFormat = DateFormat("yyyy");
          begin = dateFormat.format(this._begin);
          break;
        case StatEnum.MONTH:
          dateFormat = DateFormat("yyyy-MM");
          begin = dateFormat.format(this._begin);
          break;
      }
      return Container(
        margin: EdgeInsets.only(top: 15.h, left: 25.w, right: 25.w),
        width: MediaQuery.of(context).size.width,
        height: 50.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$begin ${this._type == StatEnum.CUSTOM ? '~ $end' : ''}",
              style: TextStyle(
                fontSize: 25.sp,
                color: AppColor.thirdElementText,
              ),
            ),
            IconButton(
              onPressed: () {
                DateTime now = DateTime.now();
                var start = DateTime(now.year - 100, now.month, now.day);
                if (this._type == StatEnum.CUSTOM) {
                  showPickerDateRange(
                      context: context,
                      endDate: now,
                      selectedStart: this._begin,
                      selectedEnd: this._end,
                      onConfirm: (start, end) {
                        this._begin = start;
                        this._end =
                            DateTime(end.year, end.month, end.day, 23, 59, 59);
                        this._loadData();
                      });
                } else if (this._type == StatEnum.MONTH) {
                  showPickerMonth(
                      context: context,
                      scaffoldState: this._scaffoldKey.currentState!,
                      selected: this._begin,
                      endDate: now,
                      beginDate: start,
                      onConfirm: (picker, selected) {
                        var tmpBegin = DateFormat("yyyy-MM-dd HH:mm:ss")
                            .parse(picker.adapter.text);
                        int lastDay =
                            DateTime(tmpBegin.year, tmpBegin.month + 1, 0).day;
                        this._begin = DateTime(
                          tmpBegin.year,
                          tmpBegin.month,
                          1,
                        );
                        this._end = DateTime(
                          tmpBegin.year,
                          tmpBegin.month,
                          lastDay,
                          23,
                          59,
                          59,
                        );
                        this._loadData();
                      });
                } else {
                  showPickerYear(
                      context: context,
                      scaffoldState: this._scaffoldKey.currentState!,
                      selected: this._begin,
                      endDate: now,
                      beginDate: start,
                      onConfirm: (picker, selected) {
                        var tmpBegin = DateFormat("yyyy-MM-dd HH:mm:ss")
                            .parse(picker.adapter.text);
                        this._begin = DateTime(
                          tmpBegin.year,
                          01,
                          01,
                        );
                        this._end = DateTime(
                          tmpBegin.year,
                          12,
                          31,
                          23,
                          59,
                          59,
                        );
                        this._loadData();
                      });
                }
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 25.sp,
                color: AppColor.thirdElementText,
              ),
            )
          ],
        ),
      );
    }
  }

  ///////////////////////事件处理区域//////////////////////
  _loadData() async {
    CancelFunc cancelFunc = showLoading();

    /// 统计数据.
    try {
      Stats stats = await StatsService().getStatsData(
        userId: Global.currentUser!.id!,
        begin: this._begin,
        end: this._end,
        statType: this._type,
      );

      this._hpgBloodPeiChartList = [];
      this._bloodPeiChartList = [];
      this._fpgBloodPeiChartList = [];

      if (stats.bloodSugarRecordNum > 0) {
        /// 构建血糖饼图数据.
        double highPercent = double.parse(NumberFormat('####.##').format(
                stats.highBloodSugarRecordNum *
                    1.0 /
                    stats.bloodSugarRecordNum)) *
            100;
        PieChartData high = PieChartData(
            recordNum: stats.highBloodSugarRecordNum,
            title: "高血糖",
            percent: highPercent,
            color: Colors.redAccent);

        double lowPercent = double.parse(NumberFormat('####.##').format(
                stats.lowBloodSugarRecordNum *
                    1.0 /
                    stats.bloodSugarRecordNum)) *
            100;
        PieChartData low = PieChartData(
            recordNum: stats.lowBloodSugarRecordNum,
            title: "低血糖",
            percent: lowPercent,
            color: Colors.blue);

        double normalPercent = 100.0 - highPercent - lowPercent;
        int normalCount = stats.bloodSugarRecordNum -
            stats.highBloodSugarRecordNum -
            stats.lowBloodSugarRecordNum;

        PieChartData normal = PieChartData(
            recordNum: normalCount,
            title: "正常",
            percent: normalPercent,
            color: Colors.green);
        this._bloodPeiChartList..add(high)..add(low)..add(normal);
      }

      /// 构建空腹血糖饼图数据.

      if (stats.fpgBloodSugarRecordNum > 0) {
        /// 构建血糖饼图数据.
        double highPercent = double.parse(NumberFormat('####.##').format(
                stats.fpgHighBloodSugarRecordNum *
                    1.0 /
                    stats.fpgBloodSugarRecordNum)) *
            100;
        PieChartData high = PieChartData(
            recordNum: stats.fpgHighBloodSugarRecordNum,
            title: "高血糖",
            percent: highPercent,
            color: Colors.redAccent);

        double lowPercent = double.parse(NumberFormat('####.##').format(
                stats.fpgLowBloodSugarRecordNum *
                    1.0 /
                    stats.fpgBloodSugarRecordNum)) *
            100;
        PieChartData low = PieChartData(
            recordNum: stats.fpgLowBloodSugarRecordNum,
            title: "低血糖",
            percent: lowPercent,
            color: Colors.blue);

        double fpgNormalPercent = 100.0 - highPercent - lowPercent;
        int fpgNormalCount = stats.fpgBloodSugarRecordNum -
            stats.fpgHighBloodSugarRecordNum -
            stats.fpgLowBloodSugarRecordNum;

        PieChartData normal = PieChartData(
            recordNum: fpgNormalCount,
            title: "正常",
            percent: fpgNormalPercent,
            color: Colors.green);
        this._fpgBloodPeiChartList..add(high)..add(low)..add(normal);
      }

      /// 构建餐后血糖饼图数据.
      if (stats.hpgBloodSugarRecordNum > 0) {
        /// 构建血糖饼图数据.
        double highPercent = double.parse(NumberFormat('####.##').format(
                stats.hpgHighBloodSugarRecordNum *
                    1.0 /
                    stats.hpgBloodSugarRecordNum)) *
            100;
        PieChartData high = PieChartData(
            recordNum: stats.hpgHighBloodSugarRecordNum,
            title: "高血糖",
            percent: highPercent,
            color: Colors.redAccent);

        double lowPercent = double.parse(NumberFormat('####.##').format(
                stats.hpgLowBloodSugarRecordNum *
                    1.0 /
                    stats.hpgBloodSugarRecordNum)) *
            100;
        PieChartData low = PieChartData(
            recordNum: stats.hpgLowBloodSugarRecordNum,
            title: "低血糖",
            percent: lowPercent,
            color: Colors.blue);
        double hpgNormalPercent = 100.0 - highPercent - lowPercent;
        int hpgNormalCount = stats.hpgBloodSugarRecordNum -
            stats.hpgHighBloodSugarRecordNum -
            stats.hpgLowBloodSugarRecordNum;

        PieChartData normal = PieChartData(
            recordNum: hpgNormalCount,
            title: "正常",
            percent: hpgNormalPercent,
            color: Colors.green);
        this._hpgBloodPeiChartList..add(high)..add(low)..add(normal);
      }

      this._statsData = stats;

      if (mounted) {
        setState(() {});
      }
    } catch (exception) {
      showNotification(
          type: NotificationType.ERROR,
          message: (exception as ErrorData).message);
    }

    cancelFunc();
  }

  void _dataRefresh() {
    if (this._currentUser.id != Global.currentUser!.id) {
      this._currentUser = Global.currentUser!;
      this._loadData();
    }
  }
}

/// 统计类型枚举.
enum StatEnum {
  /// 总览
  ALL,

  /// 月报
  MONTH,

  /// 年报
  YEAR,

  /// 自定义，默认近7天，最多30天.
  CUSTOM,
}
