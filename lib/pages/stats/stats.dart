import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
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

  DateTime begin =
      DateFormat("yyyy-mm-dd HH:mm:ss").parse("1900-01-01 00:00:00");

  DateTime end = DateFormat("yyyy-mm-dd HH:mm:ss").parse("3000-12-31 23:59:59");

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
                '${DateFormat("yyyy-MM-dd HH:mm").format(time)} \n ${data}mmol/L',
                style: TextStyle(
                  fontSize: 25.sp,
                  color: Colors.white,
                ),
              ),
            )
          : Container();
    },
  );

  @override
  Widget build(BuildContext context) {
    /// 注册监听
    UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            _buildTabButtons(),
            _buildStatPage(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
                      setState(() {
                        this._type = e;
                      });
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
            /// 时间区间选择区域.
            if (this._type != StatEnum.ALL) Row(),

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
            /// todo 所有血糖指标饼图.
            this._buildPieChart(
              context,
              title: "血糖分布",
              dataList: this._bloodPeiChartList,
            ),

            /// todo 空腹血糖指标饼图.
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

            /// todo 空腹血糖变化折线图.
            // if (this._type == StatEnum.MONTH || this._type == StatEnum.CUSTOM)
            SizedBox(
              height: 10.h,
            ),
            this._buildLineChart(context),

            Divider(
              thickness: 1.5,
            ),
            SizedBox(
              height: 40.h,
            ),

            /// todo 餐后血糖指标饼图.
            this._buildPieChart(
              context,
              title: "餐后血糖分布",
              dataList: this._hpgBloodPeiChartList,
            ),

            /// todo 空腹血糖变化折线图.
            if (this._type == StatEnum.MONTH || this._type == StatEnum.CUSTOM)
              Row(),
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
        _getNumItem("记录天数", this._statsData.recordDays, Colors.green, "天"),

        /// 中断天数.
        _getNumItem("中断天数", this._statsData.breakDays, Colors.redAccent, "天"),
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
        _getNumItem(
            "血糖记录次数", this._statsData.bloodSugarRecordNum, Colors.green, "次"),
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
        _getNumItem(
          "空腹检测数",
          this._statsData.fpgHighBloodSugarRecordNum,
          Colors.green,
          "次",
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
        /// 空腹监测次数.
        _getNumItem(
          "空腹高血糖",
          this._statsData.fpgHighBloodSugarRecordNum,
          Colors.redAccent,
          "次",
        ),
        _getNumItem(
          "空腹低血糖",
          this._statsData.fpgLowBloodSugarRecordNum,
          Colors.blue,
          "次",
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
        _getNumItem(
          "空腹血糖最高",
          0,
          Colors.redAccent,
          "mmol/L",
          doubleNum: this._statsData.fpgBloodSugarMax,
          empty: null == this._statsData.fpgBloodSugarMax,
        ),
        _getNumItem(
          "空腹血糖最低",
          0,
          Colors.blue,
          "mmol/L",
          doubleNum: this._statsData.fpgBloodSugarMin,
          empty: null == this._statsData.fpgBloodSugarMin,
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
        _getNumItem(
          "餐后检测数",
          this._statsData.hpgBloodSugarRecordNum,
          Colors.green,
          "次",
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
        _getNumItem(
          "餐后高血糖",
          this._statsData.hpgHighBloodSugarRecordNum,
          Colors.redAccent,
          "次",
        ),

        /// 餐后低血糖监测次数.
        _getNumItem(
          "餐后低血糖",
          this._statsData.hpgLowBloodSugarRecordNum,
          Colors.blue,
          "次",
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
        _getNumItem(
          "餐后血糖最高",
          0,
          Colors.redAccent,
          "mmol/L",
          doubleNum: this._statsData.hpgBloodSugarMax,
          empty: null == this._statsData.hpgBloodSugarMax,
        ),
        _getNumItem(
          "餐后血糖最低",
          0,
          Colors.blue,
          "mmol/L",
          doubleNum: this._statsData.hpgBloodSugarMin,
          empty: null == this._statsData.hpgBloodSugarMin,
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
        _getNumItem(
          "用药记录数",
          this._statsData.medicineRecordNum,
          Colors.green,
          "次",
        ),
        _getNumItem(
          "用餐记录数",
          this._statsData.foodRecordNum,
          Colors.green,
          "次",
        ),
      ],
    );
  }

  Widget _getNumItem(
    String title,
    int num,
    Color numColor,
    String unit, {
    double? titleSize,
    double? numSize,
    double? doubleNum,
    bool empty = false,
  }) {
    return Expanded(
      flex: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize ?? 23.sp,
              color: AppColor.thirdElementText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            height: 50.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(
                  builder: (numContext) {
                    return InkWell(
                      onTap: () {
                        showTooltip(
                            context: numContext,
                            content: "$num",
                            preferDirection: PreferDirection.bottomCenter);
                      },
                      child: NumberSlideAnimation(
                        number:
                            "${empty ? '--' : (null != doubleNum ? NumberFormat('####.##').format(doubleNum) : formatNum(num))}",
                        textStyle: TextStyle(
                          fontSize: numSize ?? 35.sp,
                          color: numColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Text(
                      //   "${null != doubleNum ? NumberFormat('####.##').format(doubleNum) : formatNum(num)}",
                      //   overflow: TextOverflow.ellipsis,
                      //   style: TextStyle(
                      //     fontSize: numSize ?? 35.sp,
                      //     color: numColor,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    );
                  },
                ),
                SizedBox(
                  width: 5.w,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Text(
                    unit,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.thirdElementText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建饼图.
  Widget _buildPieChart(BuildContext context,
      {required String title, required List<PieChartData> dataList}) {
    List<int> data = [1000, 1000, 1];
    Widget chart;
    if (dataList.isNotEmpty) {
      chart = SfCircularChart(
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
        series: <PieSeries<int, String>>[
          PieSeries<int, String>(
            pointColorMapper: (int data, index) => [
              Colors.redAccent,
              Colors.blue,
              Colors.green,
              Colors.amber
            ][index],
            enableSmartLabels: true,
            dataSource: data,
            enableTooltip: true,

            /// legend label.
            xValueMapper: (int data, _) => "$data",

            /// 数据.
            yValueMapper: (int data, _) => data,
            dataLabelMapper: (int data, _) => "高血糖:\n${data}次\n50%",
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
  Widget _buildLineChart(BuildContext context) {
    List<double> dataList = [
      6.6,
      7.7,
      8.8,
      2.3,
      10.65,
      6.6,
      7.7,
      8.8,
      2.3,
      10.65,
      6.6,
      7.7,
      8.8,
      2.3,
      10.65,
      6.6,
      7.7,
      8.8,
      2.3,
      10.65
    ];
    List<double> maxLine = dataList.map((e) => 10.3).toList();
    List<double> minLine = dataList.map((e) => 6.5).toList();
    return Container(
      height: 300.h,
      width: MediaQuery.of(context).size.width,
      child: SfCartesianChart(
        palette: <Color>[Colors.amber, Colors.redAccent, Colors.blue],
        // Chart title text
        title: ChartTitle(
            text: '空腹血糖趋势',
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
          FastLineSeries<double, DateTime>(
            name: "空腹血糖",
            dataSource: dataList,

            /// x轴, 时间.
            xValueMapper: (sales, index) =>
                DateTime.now().add(Duration(days: index)),
            yValueMapper: (sales, _) => sales,
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
            xValueMapper: (sales, index) =>
                DateTime.now().add(Duration(days: index)),
            yValueMapper: (sales, _) => sales,
            dataLabelSettings: DataLabelSettings(
              isVisible: false,
            ),
          ),

          /// 指标线下限
          FastLineSeries<double, DateTime>(
            name: "下线指标",
            dataSource: minLine,

            /// x轴, 时间.
            xValueMapper: (sales, index) =>
                DateTime.now().add(Duration(days: index)),
            yValueMapper: (sales, _) => sales,
            dataLabelSettings: DataLabelSettings(
              isVisible: false,
            ),
          ),
        ],
      ),
    );
  }

  ///////////////////////事件处理区域//////////////////////
  _loadData() async {
    /// 统计数据.

    if (mounted) {
      setState(() {});
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
