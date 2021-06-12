import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/record/blood_sugar_record.dart';
import 'package:blood_sugar_recorder/service/record/food_record.dart';
import 'package:blood_sugar_recorder/service/record/medicine_record.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

///记录明细处理
void defaultHandleRecordItemEdit(BuildContext context, RecordItem item) {
  switch (item.runtimeType) {
    case MedicineRecordItem:
      {
        AutoRouter.of(context).push(MedicineRecordRoute(
            autoSave: true, medicineRecordItem: item as MedicineRecordItem));
        break;
      }
    case FoodRecordItem:
      {
        AutoRouter.of(context).push(FoodRecordRoute(
            autoSave: true, foodRecordItem: item as FoodRecordItem));
        break;
      }
    case BloodSugarRecordItem:
      {
        AutoRouter.of(context).push(BloodSugarRecordRoute(
            autoSave: true,
            bloodSugarRecordItem: item as BloodSugarRecordItem,
            returnWithPop: false));
        break;
      }
  }
}

void defaultHandleRecordItemDelete(
    BuildContext context, RecordItem item, Function callback) async {
  // 删除提示框.
  OkCancelResult res = await showOkCancelAlertDialog(
    context: context,
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
          await MedicineRecordService().delete(item as MedicineRecordItem);
          break;
        }
      case FoodRecordItem:
        {
          await FoodRecordService().delete(item as FoodRecordItem);
          break;
        }
      case BloodSugarRecordItem:
        {
          await BloodSugarRecordService().delete(item as BloodSugarRecordItem);
          break;
        }
    }

    showNotification(type: NotificationType.SUCCESS, message: "删除成功");

    cancel();

    /// 刷新页面.
    callback();
  }
}
