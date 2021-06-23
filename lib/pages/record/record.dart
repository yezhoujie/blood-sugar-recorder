import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/pages/record/record_item_widget.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/config/config_service.dart';
import 'package:blood_sugar_recorder/service/record/cycle_record.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';

/// 单周期，血糖，药物，进餐记录入口页面
class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  User _currentUser = Global.currentUser!;

  /// 血糖标准.
  late UserBloodSugarConfig _standard;

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
                            context: context,
                            itemList: this._currentCycle!.itemList,
                            standard: this._standard,
                            itemDeleteCallback: (_) {
                              this._refreshCurrentCycle();
                            },
                          )).toList(),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 20.w,
                    child: IconButton(
                      iconSize: 25.sp,
                      tooltip: "分享",
                      alignment: Alignment.center,
                      onPressed: () {
                        Share.share(
                            CycleRecord.toShareText(this._currentCycle!),
                            subject: '【血糖记录器】分享数据');
                      },
                      icon: Icon(
                        Icons.share,
                        color: AppColor.thirdElementText,
                      ),
                    ),
                  ),
                  PopupMenuButton(
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
                      if (value == "close") {
                        _handleCloseCycle(this._currentCycle!);
                      } else if (value == "delete") {
                        /// 删除整个周期的数据记录.
                        _handleDeleteCycle(this._currentCycle!);
                      }
                    },
                  ),
                ],
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
              if (!await _canAdd()) {
                showNotification(
                    type: NotificationType.ERROR,
                    message: "一个周期内最多只能添加10条明细记录");
                return;
              }

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
              if (!await _canAdd()) {
                showNotification(
                    type: NotificationType.ERROR,
                    message: "一个周期内最多只能添加10条明细记录");
                return;
              }
              context.pushRoute(
                  FoodRecordRoute(autoSave: true, returnWithPop: false));
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
            onPressed: () async {
              if (!await _canAdd()) {
                showNotification(
                    type: NotificationType.ERROR,
                    message: "一个周期内最多只能添加10条明细记录");
                return;
              }
              context.pushRoute(BloodSugarRecordRoute(
                autoSave: true,
                returnWithPop: false,
              ));
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

    this._standard = await ConfigService().getStandard(this._currentUser.id!);
    this._initDone = true;
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
      context
          .pushRoute(MedicineRecordRoute(autoSave: true, returnWithPop: false));
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

  Future<bool> _canAdd() async {
    if (null == this._currentCycle) {
      return true;
    } else {
      if (this._currentCycle!.closed) {
        return true;
      } else {
        return CycleRecordService().canAddItem(this._currentCycle!.id!);
      }
    }
  }
}
