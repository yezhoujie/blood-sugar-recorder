import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/pages/record/record_item_widget.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/record/cycle_record.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 补填历史周期记录页面.
class HistoryAddPage extends StatefulWidget {
  const HistoryAddPage({Key? key}) : super(key: key);

  @override
  _HistoryAddPageState createState() => _HistoryAddPageState();
}

class _HistoryAddPageState extends State<HistoryAddPage> {
  /// 当前要创建的历史周期.
  CycleRecord _cycle = CycleRecord.byDefault(Global.currentUser!.id!);
  UserBloodSugarConfig _standard =
      UserBloodSugarConfig.byDefault(Global.currentUser!.id!);

  @override
  void initState() {
    super.initState();

    /// 设置周期明细.
    this._cycle.itemList = [];
    this._loadStandard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 10.h),
        width: double.infinity,
        height: 610.h,
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

  /////////////////////UI 构建区域/////////////////////

  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: Text(
        "历史周期信息补填",
        style: TextStyle(
          fontSize: 30.sp,
          color: AppColor.primaryText,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColor.primaryText,
          size: 35.sp,
        ),
        onPressed: () async {
          if (this._cycle.itemList.isNotEmpty) {
            OkCancelResult res = await showOkCancelAlertDialog(
              context: this.context,
              title: "确定要返回么？",
              message: "返回将不对添加的明细数据进行保存",
              okLabel: "确定",
              cancelLabel: "取消",
              barrierDismissible: false,
            );

            if (res.index != OkCancelResult.ok.index) {
              return;
            }
          }
          AutoRouter.of(context)
              .pushAndPopUntil(MainRoute(tabIndex: 1), predicate: (_) => false);
        },
      ),
    );
  }

  List<Widget> _buildCycleCard() {
    if (this._cycle.itemList.isEmpty) {
      return [
        SizedBox(
          height: 440.h,
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
          height: 440.h,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: RadiusConstant.k6pxRadius,
            ),
            child: SizedBox(
              height: 430.h,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: ListTile.divideTiles(
                          context: context,
                          tiles: buildDetailRecordItem(
                            context: context,
                            itemList: this._cycle.itemList,
                            standard: this._standard,
                            itemDeleteCallback: (recordItem) {
                              this._cycle.itemList.remove(recordItem);
                              setState(() {});
                            },
                            handleRecordItemEdit: _pushItemEditPage,
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

  /// 构建底部添加各种记录的按钮.
  Widget _buildItemButtons() {
    return SizedBox(
        height: 150.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
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
                    dynamic newItem = await AutoRouter.of(context).push(
                        FoodRecordRoute(autoSave: false, returnWithPop: true));
                    if (null != newItem) {
                      await this._handleAddNewRecordItem(newItem);
                    }
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
                    dynamic newItem =
                        await AutoRouter.of(context).push(BloodSugarRecordRoute(
                      autoSave: false,
                      returnWithPop: true,
                      showCloseButton: false,
                    ));

                    if (null != newItem) {
                      await this._handleAddNewRecordItem(newItem);
                    }
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
            seFlatButton(
              onPressed: _handleSaveCycle,
              title: "完成",
              fontSize: 25.sp,
              width: 310.w,
              height: 45.h,
            ),
          ],
        ));
  }

  /////////////////////事件处理区域///////////////////////////
  void _loadStandard() async {
    this._standard = await ConfigService().getStandard(Global.currentUser!.id!);
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> _canAdd() async {
    return this._cycle.itemList.length < 10;
  }

  /// 处理跳转到创建药物记录页面.
  Future<void> _handleToMedicinePage() async {
    List<UserMedicineConfig> medicineConfigList =
        await UserMedicineConfigDatasource()
            .findByUserId(Global.currentUser!.id!);
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
      dynamic newItem = await AutoRouter.of(context)
          .push(MedicineRecordRoute(autoSave: false, returnWithPop: true));
      if (null != newItem) {
        await this._handleAddNewRecordItem(newItem);
      }
    }
  }

  /// 将新加的记录放入周期明细列表，并根据时间进行排序.
  _handleAddNewRecordItem(RecordItem newItem) async {
    if (newItem is MedicineRecordItem) {
      /// 获取药物信息.
      if (null == newItem.medicineId) {
        return;
      }
      newItem.medicine = await MedicineService().getById(newItem.medicineId!);
    }
    this._cycle.itemList
      ..add(newItem)
      ..sort((a, b) => a.recordTime.compareTo(b.recordTime));

    if (mounted) {
      setState(() {});
    }
  }

  /// 跳转周期内明细编辑页面.
  _pushItemEditPage(BuildContext context, RecordItem item, int index) async {
    dynamic res;
    switch (item.runtimeType) {
      case MedicineRecordItem:
        {
          res = await AutoRouter.of(context).push(MedicineRecordRoute(
            autoSave: false,
            returnWithPop: true,
            medicineRecordItem: item as MedicineRecordItem,
          ));
          break;
        }
      case FoodRecordItem:
        {
          res = await AutoRouter.of(context).push(FoodRecordRoute(
            autoSave: false,
            foodRecordItem: item as FoodRecordItem,
            returnWithPop: true,
          ));
          break;
        }
      case BloodSugarRecordItem:
        {
          res = await AutoRouter.of(context).push(BloodSugarRecordRoute(
            autoSave: false,
            bloodSugarRecordItem: item as BloodSugarRecordItem,
            returnWithPop: true,
            showCloseButton: false,
          ));
          break;
        }
    }
    if (null != res) {
      await this._handleEditRecordItem(res, index);
    }
  }

  /// 处理明细数据编辑后，替换明细列表中的数据.
  _handleEditRecordItem(updatedItem, index) async {
    if (updatedItem is MedicineRecordItem) {
      /// 获取药物信息.
      if (null == updatedItem.medicineId) {
        return;
      }
      updatedItem.medicine =
          await MedicineService().getById(updatedItem.medicineId!);
    }
    this._cycle.itemList[index] = updatedItem;
    this._cycle.itemList.sort((a, b) => a.recordTime.compareTo(b.recordTime));

    if (mounted) {
      setState(() {});
    }
  }

  /// 保存补填的周期记录.
  void _handleSaveCycle() async {
    if (this._cycle.itemList.isEmpty) {
      showNotification(type: NotificationType.ERROR, message: "请先添加明细记录");
      return;
    }

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
        this._cycle.comment = text.first;
      }

      ///进行后台保存.
      CancelFunc cancelFunc = showLoading();
      try {
        await CycleRecordService()
            .saveWithItems(this._cycle, this._cycle.itemList);
        showNotification(type: NotificationType.SUCCESS, message: "补填完成");
      } catch (exception) {
        showNotification(type: NotificationType.ERROR, message: "糟糕，程序出错啦");
      }

      cancelFunc();
      AutoRouter.of(context).pushAndPopUntil(
          MainRoute(
            tabIndex: 1,
          ),
          predicate: (_) => false);
    }
  }
}
