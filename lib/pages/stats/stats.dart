import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 统计分页页面.
class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  /// 默认统计类型为总览.
  StatEnum _type = StatEnum.ALL;

  @override
  Widget build(BuildContext context) {
    /// 注册监听
    UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);

    return Scaffold(
      body: Container(
          child: Column(
        children: [
          _buildTabButtons(),
          _buildStatPage(),
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    return Padding(
        padding: EdgeInsets.only(right: 25.w, left: 25.w, top: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 时间区间选择区域.
              if (this._type != StatEnum.ALL) Row(),

              /// 连续记录天数，中断记录天数行
              _buildRecordDaysRow(),
              SizedBox(
                height: 20.h,
              ),

              /// 血糖记录次数.
              _buildBloodSugarDaysRow(),

              SizedBox(
                height: 20.h,
              ),

              /// 血糖，空腹/餐后次数
              _buildFpgBloodSugarRow(),
            ],
          ),
        ));
  }

  /// 构建记录天数，中断天数数据行.
  _buildRecordDaysRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 记录天数
        _getNumItem("记录天数", 298, Colors.green, "天"),

        /// 中断天数.
        _getNumItem("中断天数", 90000000, Colors.redAccent, "天"),
      ],
    );
  }

  /// 构建药物，用餐，血糖明细记录数据
  _buildBloodSugarDaysRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 记录天数
        _getNumItem("血糖记录次数", 9999, Colors.green, "次"),
      ],
    );
  }
}

/// 构建空腹血糖检测次数.
_buildFpgBloodSugarRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// 空腹监测次数.
      _getNumItem("空腹检测数", 9999, Colors.blue, "次",),
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
                    child: Text(
                      "${formatNum(num)}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: numSize ?? 35.sp,
                        color: numColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
