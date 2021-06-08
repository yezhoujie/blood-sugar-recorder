import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/record/cycle_record.dart';
import 'package:blood_sugar_recorder/service/record/medicine_record.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  List<UserMedicineConfig> _medicineList = [];

  /// 当前所在页面.
  PageRouteInfo _currentPage = MainRoute(tabIndex: 0);

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
    this._medicineList = [];
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
          height: 480.h,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: RadiusConstant.k6pxRadius,
            ),
            child: SizedBox(
              height: 430.h,
              child: Column(
                children: [
                  _buildCycleOperation(),
                  Divider(
                    thickness: 5,
                    height: 1.h,
                    color: Colors.amber,
                  ),
                  Expanded(
                    child: ListView(
                      children: ListTile.divideTiles(
                              context: context, tiles: _buildDetailRecordItem())
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }
  }

  /// 构建当前周期的操作按钮区域.
  _buildCycleOperation() {
    /// todo change it to popup menu.
    return Container(
      margin: EdgeInsets.only(right: 5.w),
      height: 50.h,
      child: Align(
        alignment: Alignment.bottomRight,
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
              /// todo 跳转记录血糖页面.
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

  List<Widget> _buildDetailRecordItem() {
    return this._currentCycle!.itemList.map((item) {
      if (item is MedicineRecordItem) {
        return Container(
          // margin: EdgeInsets.only(right: 20.w),
          height: 60.h,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Builder(
                  builder: (leadingContext) => InkWell(
                    onTap: () {
                      showTooltip(
                          context: leadingContext,
                          content:
                              "${this._medicineList.where((medicine) => medicine.id == item.medicineId).first.name}");
                    },
                    child: Icon(
                      this
                                  ._medicineList
                                  .where((medicine) =>
                                      medicine.id == item.medicineId)
                                  .first
                                  .type ==
                              MedicineType.INS
                          ? Iconfont.yidaosu
                          : Iconfont.yaowu,
                      size: 40.sp,
                      color: Color(
                        int.parse(
                            this
                                ._medicineList
                                .where((medicine) =>
                                    medicine.id == item.medicineId)
                                .first
                                .color,
                            radix: 16),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      new DateFormat("yyyy-MM-dd").format(item.recordTime),
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    Text(
                      new DateFormat("HH:mm").format(item.recordTime),
                      style: TextStyle(
                        fontSize: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: _tagMedicineRecordTags(item),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${item.usage}',
                          style: TextStyle(
                            fontSize: 30.sp,
                          ),
                        ),
                        Text(
                          '${this._medicineList.where((medicine) => medicine.id == item.medicineId).first.unit}',
                          style: TextStyle(
                            color: AppColor.thirdElementText,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: RadiusConstant.k6pxRadius,
                  ),
                  offset: Offset(0, 40.h),
                  iconSize: 30.sp,
                  itemBuilder: (BuildContext bc) {
                    const operationList = [
                      {
                        "key": "edit",
                        "title": "修改",
                        "icon": Icon(
                          Icons.edit,
                          color: Colors.green,
                        )
                      },
                      {
                        "key": "delete",
                        "title": "删除",
                        "icon": Icon(
                          Icons.delete,
                          color: Colors.red,
                        )
                      },
                    ];
                    return operationList
                        .map((operation) => PopupMenuItem(
                              child: Row(
                                children: [
                                  operation["icon"] as Widget,
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.w)),
                                  Text(
                                    operation["title"].toString(),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ],
                              ),
                              value: operation['key'].toString(),
                            ))
                        .toList();
                  },
                  onSelected: (value) async {
                    if (value == "edit") {
                      _handleRecordItemEdit(item);
                    } else if (value == "delete") {
                      _handleRecordItemDelete(item);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    }).toList();
  }

  _tagMedicineRecordTags(MedicineRecordItem item) {
    List<Widget> list = [];
    if (item.extra) {
      list.add(
        Container(
          margin: EdgeInsets.only(top: 2.h),
          color: Colors.amber,
          height: 22.w,
          width: 22.w,
          child: Text(
            " 补",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      list.add(
        Container(
          margin: EdgeInsets.only(top: 2.h),
          height: 22.w,
          width: 22.w,
        ),
      );
    }
    return list;
  }

  ////////////////事件处理区域////////////////
  _getCurrentCycle() async {
    /// 从数据库获取当前或者最近一次周期记录.
    await this._refreshCurrentCycle();
  }

  /// 从数据库中获取当前周期记录.
  _refreshCurrentCycle() async {
    CancelFunc cancel = showLoading();
    this._currentCycle =
        await CycleRecordService().getCurrentByUserId(this._currentUser.id!);

    this._medicineList =
        await MedicineService().findByUserId(this._currentUser.id!);

    if (mounted) {
      setState(() {});
    }
    cancel();
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

  void _handleRecordItemEdit(MedicineRecordItem item) {
    switch (item.runtimeType) {
      case MedicineRecordItem:
        {
          context.pushRoute(
              MedicineRecordRoute(autoSave: true, medicineRecordItem: item));
          break;
        }
      // todo more runtimeType.
    }
  }

  void _handleRecordItemDelete(MedicineRecordItem item) async {
    // 删除提示框.
    OkCancelResult res = await showOkCancelAlertDialog(
      context: this.context,
      title: "确定要删除吗？",
      okLabel: "确定",
      cancelLabel: "取消",
      barrierDismissible: false,
    );

    if (res.index == OkCancelResult.ok.index) {
      CancelFunc cancel = showLoading();
      switch (item.runtimeType) {
        case MedicineRecordItem:
          {
            await MedicineRecordService().delete(item);
          }
        // todo more runtimeType.
      }

      showNotification(type: NotificationType.SUCCESS, message: "删除成功");

      cancel();

      /// 刷新页面.
      this._refreshCurrentCycle();
    }
  }
}
