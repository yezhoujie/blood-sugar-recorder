import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/record/cycle_record.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 单周期，血糖，药物，进餐记录入口页面
class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  User _currentUser = Global.currentUser!;

  CycleRecord? _currentCycle;

  @override
  Widget build(BuildContext context) {
    /// 注册监听
    UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);

    _dataRefresh();
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 10.h),
        width: double.infinity,
        height: 590.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._buildCycleCard(),
            _buildItemButtons(),
          ],
        ),
      ),
    );
  }

  void _dataRefresh() {
    if (this._currentUser.id != Global.currentUser!.id) {
      this._currentUser = Global.currentUser!;
      this._refreshCurrentCycle();
    }
  }

  @override
  void initState() {
    super.initState();
    this._getCurrentCycle();
  }

  @override
  void dispose() {
    print("disposed");
    super.dispose();
  }

  ////////////////UI构建区域//////////////////
  List<Widget> _buildCycleCard() {
    if (null == this._currentCycle) {
      return [
        SizedBox(
          height: 480.h,
          child: Card(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "还没有任何记录，赶快来创建吧",
                style: TextStyle(
                  color: AppColor.thirdElementText,
                  fontSize: 25.sp,
                ),
              ),
            ),
          ),
        ),
      ];
    } else {
      return [
        //// 周期记录卡片.
        SizedBox(
          height: 430.h,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: RadiusConstant.k6pxRadius,
            ),
            child: ListView(
              children:
                  ListTile.divideTiles(context: context, tiles: []).toList(),
            ),
          ),
        ),

        /// 周期操作按钮
        this._buildCycleOperation(),
      ];
    }
  }

  /// 构建当前周期的操作按钮区域.
  _buildCycleOperation() {
    return Container(
      margin: EdgeInsets.only(right: 5.w),
      height: 50.h,
      child: Align(
        alignment: Alignment.centerRight,
        child: OutlinedButton(
          onPressed: this._currentCycle!.closed
              ? null
              : () {
                  /// todo 结束周期.
                },
          style: OutlinedButton.styleFrom(
            primary: Colors.white,
            backgroundColor:
                this._currentCycle!.closed ? Colors.grey : Colors.pink,
            textStyle: TextStyle(
              fontSize: 20.sp,
            ),
          ),
          child: Text(
            "${this._currentCycle!.closed ? "该周期已结束" : "结束该周期"}",
          ),
        ),
      ),
    );
  }

  /// 构建底部添加各种记录的按钮.
  Widget _buildItemButtons() {
    return SizedBox(
      height: 110.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton.icon(
            icon: Icon(Iconfont.yaowu),
            onPressed: () async {
              /// 跳转到添加药物记录页面.
              await _handleToMedicinePage();
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.amber,
              textStyle: TextStyle(
                fontSize: 25.sp,
              ),
            ),
            label: Text(
              "药物",
            ),
          ),
          OutlinedButton.icon(
            icon: Icon(Iconfont.jinshi),
            onPressed: () async {
              // todo 跳转到记录用餐记录页面.
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.green,
              textStyle: TextStyle(
                fontSize: 25.sp,
              ),
            ),
            label: Text(
              "用餐",
            ),
          ),
          OutlinedButton.icon(
            icon: Icon(Iconfont.xietang),
            onPressed: () {
              /// todo 结束周期.
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.redAccent,
              textStyle: TextStyle(
                fontSize: 25.sp,
              ),
            ),
            label: Text(
              "测血糖",
            ),
          ),
        ],
      ),
    );
  }

  ////////////////事件处理区域////////////////
  _getCurrentCycle() async {
    /// 从数据库获取当前或者最近一次周期记录.
    await this._refreshCurrentCycle();

    if (mounted) {
      setState(() {});
    }
  }

  /// 从数据库中获取当前周期记录.
  _refreshCurrentCycle() async {
    this._currentCycle =
        await CycleRecordService().getCurrentByUserId(this._currentUser.id!);
  }

  /// 处理跳转到创建药物记录页面.
  Future<void> _handleToMedicinePage() async {
    List<UserMedicineConfig> medicineConfigList =
        await UserMedicineConfigDatasource()
            .findByUserId(this._currentUser.id!);
    if (medicineConfigList.isEmpty) {
      OkCancelResult res = await showOkCancelAlertDialog(
        context: this.context,
        title: "您还没有设置任何药物信息",
        message: "现在就去创建药物信息吗？",
        okLabel: "确定",
        cancelLabel: "取消",
        barrierDismissible: false,
      );

      if (res.index == OkCancelResult.ok.index) {
        /// 跳转到药物信息设置页面.
        AutoRouter.of(context).pushAll([
          MedicineListRoute(),
          MedicineSettingRoute(
            init: false,
          )
        ]);
      }
    } else {
      /// 跳转到创建药物使用记录页面.
      context.pushRoute(MedicineRecordRoute(autoSave: true));
    }
  }
}
