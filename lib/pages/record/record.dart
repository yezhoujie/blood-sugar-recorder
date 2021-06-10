import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/pages/record/record_item_widget.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/record/cycle_record.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
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

  /// 当前所在页面.
  PageRouteInfo _currentPage = MainRoute(tabIndex: 0);

  /// 数据状态完成状态.
  bool _initDone = false;

  CancelFunc? _cancelLoading;

  @override
  Widget build(BuildContext context) {
    /// 注册监听
    UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);

    _dataRefresh();
    return this._initDone ? _buildPage() : _buildLoading();
  }

  void _dataRefresh() {
    if (this._currentUser.id != Global.currentUser!.id) {
      this._currentUser = Global.currentUser!;
      this._initDone = false;
      this._refreshCurrentCycle();
    }
  }

  @override
  void initState() {
    super.initState();
    this._initDone = false;
    this._refreshCurrentCycle();
  }

  @override
  void dispose() {
    if (null != this._cancelLoading) {
      this._cancelLoading!();
      this._cancelLoading = null;
    }
    super.dispose();
  }

  ////////////////UI构建区域//////////////////

  _buildPage() {
    if (null != this._cancelLoading) {
      this._cancelLoading!();
      this._cancelLoading = null;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

  _buildLoading() {
    if (null == this._cancelLoading) {
      this._cancelLoading = showLoading();
    }
    return Container();
  }

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
                              context: context,
                              tiles: buildDetailRecordItem(
                                  context,
                                  this._currentCycle!.itemList,
                                  this._refreshCurrentCycle))
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
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "${this._currentCycle!.closed ? "该周期已结束" : "周期正在进行中"}",
                style: TextStyle(
                  fontSize: 25.sp,
                  color: AppColor.thirdElementText,
                ),
              ),
            ),
            flex: 6,
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton(
                icon: Icon(
                  Icons.settings,
                  color: AppColor.thirdElementText,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: RadiusConstant.k6pxRadius,
                ),
                offset: Offset(0, 40.h),
                iconSize: 30.sp,
                itemBuilder: (BuildContext bc) {
                  const operationList = [
                    {
                      "key": "close",
                      "title": "结束该周期",
                      "icon": Icon(
                        Icons.done,
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
                            enabled: (operation["key"] != "close" ||
                                !this._currentCycle!.closed),
                            child: Row(
                              children: [
                                operation["icon"] as Widget,
                                Padding(padding: EdgeInsets.only(right: 10.w)),
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
                  if (value == "close") {
                    _handleCloseCycle(this._currentCycle!);
                  } else if (value == "delete") {
                    /// 删除整个周期的数据记录.
                    _handleDeleteCycle(this._currentCycle!);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部添加各种记录的按钮.
  Widget _buildItemButtons() {
    return SizedBox(
      height: 80.h,
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
              context.pushRoute(FoodRecordRoute(autoSave: true));
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

  ////////////////事件处理区域////////////////

  /// 从数据库中获取当前周期记录.
  _refreshCurrentCycle() async {
    CancelFunc cancel = showLoading();
    this._currentCycle =
        await CycleRecordService().getCurrentByUserId(this._currentUser.id!);
    if (mounted) {
      setState(() {
        this._initDone = true;
      });
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

  /// 删除当前周期以及周期下的所有明细记录.
  void _handleDeleteCycle(CycleRecord cycleRecord) async {
    // 删除提示框.
    OkCancelResult res = await showOkCancelAlertDialog(
      context: this.context,
      title: "确定要删除吗？",
      message: "删除周期将一同删除周期下所有的明细记录",
      okLabel: "确定",
      cancelLabel: "取消",
      barrierDismissible: false,
    );

    if (res.index == OkCancelResult.ok.index) {
      CancelFunc cancel = showLoading();

      await CycleRecordService().deleteWithItemsById(cycleRecord.id!);

      showNotification(type: NotificationType.SUCCESS, message: "删除成功");

      cancel();

      /// 刷新页面.
      this._refreshCurrentCycle();
    }
  }

  /// 关闭当前记录周期.
  void _handleCloseCycle(CycleRecord cycleRecord) async {
    /// 弹出备注记录dialog
    final text = await showTextInputDialog(
      fullyCapitalizedForMaterial: false,
      okLabel: "确定结束该周期",
      cancelLabel: "取消",
      context: context,
      textFields: const [
        DialogTextField(
          hintText: "给这个周期写点备注吧",
          minLines: 3,
          maxLines: 3,
        ),
      ],
    );

    if (null != text) {
      if (text.isNotEmpty) {
        this._currentCycle!.comment = text.first;
      }
      CancelFunc cancel = showLoading();

      await CycleRecordService().close(this._currentCycle!);

      showNotification(type: NotificationType.SUCCESS, message: "操作成功");

      cancel();

      /// 刷新页面；
      this._refreshCurrentCycle();
    }
  }
}
