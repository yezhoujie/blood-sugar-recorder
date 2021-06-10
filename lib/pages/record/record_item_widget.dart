import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/pages/record/record_item_handler.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///构建周期内每个明细记录的时间显示列.
Widget timeColumn(RecordItem item) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        new DateFormat("yyyy-MM-dd").format(item.recordTime),
        style: TextStyle(
          fontSize: 19.sp,
          color: AppColor.thirdElementText,
        ),
      ),
      Text(
        new DateFormat("HH:mm").format(item.recordTime),
        style: TextStyle(
          fontSize: 30.sp,
        ),
      ),
    ],
  );
}

/// 构架周期内每个明细记录的操作按钮.
/// [context] BuildContext.
/// [item] 明细记录数据.
/// [callback] 删除记录后的回调函数.
Widget itemPopUpMenu({
  required BuildContext context,
  required RecordItem item,
  required Function callback,
}) {
  return PopupMenuButton(
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
      if (value == "edit") {
        handleRecordItemEdit(context, item);
      } else if (value == "delete") {
        handleRecordItemDelete(context, item, callback);
      }
    },
  );
}

/// 构建每个周期内的进食明细记录.
/// [context] BuildContext
/// [item] FoodRecordItem 明细记录数据.
/// [itemDeleteCallback] 记录删除后的回调函数.
Widget buildFoodRecordItem(
    BuildContext context, FoodRecordItem item, Function itemDeleteCallback) {
  return Container(
    // margin: EdgeInsets.only(right: 20.w),
    height: 60.h,
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Icon(
            Iconfont.jinshi,
            size: 32.sp,
            color: Colors.green,
          ),
        ),
        Expanded(
          flex: 3,
          child: timeColumn(item),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 135.w,
                    child: Builder(
                      builder: (itemContext) {
                        return InkWell(
                          onTap: () => showTooltip(
                            context: itemContext,
                            content: item.foodInfo ?? "",
                            preferDirection: PreferDirection.bottomCenter,
                          ),
                          child: Text(
                            '${item.foodInfo}',
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                width: 135.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.comment,
                      color: AppColor.thirdElementText,
                      size: 20.sp,
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                      left: 0.5.w,
                    )),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 110.w,
                      ),
                      child: Builder(
                        builder: (commentContext) {
                          return InkWell(
                            onTap: () => showTooltip(
                              context: commentContext,
                              content: item.comment ?? "",
                              preferDirection: PreferDirection.bottomCenter,
                            ),
                            child: Text(
                              '${null != item.comment && item.comment!.isNotEmpty ? item.comment : "暂无备注"}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColor.thirdElementText,
                                fontSize: 16.sp,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: itemPopUpMenu(
              context: context, item: item, callback: itemDeleteCallback),
        ),
      ],
    ),
  );
}

/// 构建每个周期内的药物使用明细记录.
/// [context] BuildContext
/// [item] MedicineRecordItem 明细记录数据.
/// [itemDeleteCallback] 记录删除后的回调函数.
Widget buildMedicineRecordItem(BuildContext context, MedicineRecordItem item,
    Function itemDeleteCallback) {
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
                    context: leadingContext, content: "${item.medicine!.name}");
              },
              child: Icon(
                item.medicine!.type == MedicineType.INS
                    ? Iconfont.yidaosu
                    : Iconfont.yaowu,
                size: 40.sp,
                color: Color(
                  int.parse(item.medicine!.color, radix: 16),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: timeColumn(item),
        ),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: medicineRecordTags(item),
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
                    '${item.medicine!.unit}',
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
          child: itemPopUpMenu(
              context: context, item: item, callback: itemDeleteCallback),
        ),
      ],
    ),
  );
}

List<Widget> buildDetailRecordItem(BuildContext context,
    List<RecordItem> itemList, Function itemDeleteCallback) {
  return itemList.map((item) {
    switch (item.runtimeType) {
      case MedicineRecordItem:
        {
          return buildMedicineRecordItem(
              context, item as MedicineRecordItem, itemDeleteCallback);
        }
      case FoodRecordItem:
        {
          return buildFoodRecordItem(
              context, item as FoodRecordItem, itemDeleteCallback);
        }
      default:
        return Container();
    }
  }).toList();
}

List<Widget> medicineRecordTags(MedicineRecordItem item) {
  List<Widget> list = [];
  if (item.extra) {
    list.add(
      Container(
        margin: EdgeInsets.only(top: 2.h),
        color: Colors.amber,
        height: 22.w,
        width: 22.w,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "补",
            style: TextStyle(
              color: Colors.pink,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
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
