import 'dart:convert';

import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showPicker({
  required BuildContext context,
  required ScaffoldState scaffoldState,
  required String data,
  Function(Picker picker, List<int> selected)? onConfirm,
  List<int>? selected,
}) {
  Picker picker = Picker(
    adapter: PickerDataAdapter<String>(pickerdata: JsonDecoder().convert(data)),
    changeToFirst: false,
    textAlign: TextAlign.center,
    textStyle: TextStyle(color: AppColor.thirdElement, fontSize: 18.sp),
    selectedTextStyle: TextStyle(color: Colors.red, fontSize: 30.sp),
    columnPadding: EdgeInsets.all(8.h),
    confirmText: "确定",
    confirmTextStyle: TextStyle(
      fontSize: 25.sp,
      color: Colors.red,
    ),
    cancelText: "取消",
    cancelTextStyle: TextStyle(
      fontSize: 25.sp,
      color: AppColor.thirdElementText,
    ),
    itemExtent: 60.h,
    selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
      background: Colors.transparent,
    ),
    onConfirm: onConfirm,
    selecteds: selected,
  );
  picker.show(scaffoldState);
}

showPickerDate({
  required BuildContext context,
  required ScaffoldState scaffoldState,
  DateTime? beginDate,
  DateTime? endDate,
  DateTime? selected,
  Function(Picker picker, List selected)? onConfirm,
}) {
  Picker(
    adapter: DateTimePickerAdapter(
      type: PickerDateTimeType.kYMD,
      isNumberMonth: true,
      yearSuffix: "年",
      monthSuffix: "月",
      daySuffix: "日",
      minValue: beginDate,
      maxValue: endDate,
      value: selected ?? DateTime.now(),
    ),
    title: Text(""),
    textAlign: TextAlign.right,
    selectedTextStyle: TextStyle(
      color: Colors.red,
      fontSize: 30.sp,
    ),
    itemExtent: 60.h,
    selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
      background: Colors.transparent,
    ),
    delimiter: [
      PickerDelimiter(
          column: 3,
          child: Container(
            width: 16.0.w,
            alignment: Alignment.center,
            color: Colors.white,
          ))
    ],
    confirmText: "确定",
    confirmTextStyle: TextStyle(
      fontSize: 25.sp,
      color: Colors.red,
    ),
    cancelText: "取消",
    cancelTextStyle: TextStyle(
      fontSize: 25.sp,
      color: AppColor.thirdElementText,
    ),
    onConfirm: onConfirm,
  ).show(scaffoldState);
}
