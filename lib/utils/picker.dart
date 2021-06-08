import 'dart:convert';

import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' hide PickerItem;
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


showPickerDateTime({
  required BuildContext context,
  required ScaffoldState scaffoldState,
  DateTime? beginDate,
  DateTime? endDate,
  DateTime? selected,
  Function(Picker picker, List selected)? onConfirm,
}) {
  Picker(
    adapter: DateTimePickerAdapter(
      type: PickerDateTimeType.kYMDHM,
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
          column: 5,
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

/// 显示自定义选择器.
showCustomPicker({
  required BuildContext context,
  required ScaffoldState scaffoldState,
  Function(Picker picker, List selected)? onConfirm,
  List<PickerItem> dataList = const [],
  List<int>? columnFlex,
  List<int>? selected,
}) {
  Picker(
    adapter: PickerDataAdapter(data: dataList),
    title: Text(""),
    textAlign: TextAlign.right,
    // textStyle: TextStyle(
    //   color: Colors.blue,
    // ),
    selectedTextStyle: TextStyle(
      color: Colors.red,
      fontSize: 21.sp,
    ),
    itemExtent: 60.h,
    selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
      background: Colors.transparent,
    ),
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
    columnFlex: columnFlex,
    selecteds: selected,
  ).show(scaffoldState);
}

typedef ColorPickerItem = Widget Function(Color color);

class ColorPicker {
  static late PersistentBottomSheetController _controller;

  /// 显示颜色选择器.
  static showColorPicker({
    required ScaffoldState scaffoldState,
    Color? selectedColor,
    Function(Color selectedColor)? onConfirm,
    Function()? onCancel,
  }) {
    Color tempColor = selectedColor ?? Colors.orange;

    _controller = scaffoldState.showBottomSheet(
      (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              // height: 100.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: null == onCancel
                            ? () => _controller.close()
                            : () {
                                onCancel();
                                _controller.close();
                              },
                        child: Text(
                          "取消",
                          style: TextStyle(
                            fontSize: 25.sp,
                            color: AppColor.thirdElementText,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: null == onConfirm
                            ? () {
                                _controller.close();
                              }
                            : () {
                                onConfirm(tempColor);
                                _controller.close();
                              },
                        child: Text(
                          "确定",
                          style: TextStyle(
                            fontSize: 25.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  BlockPicker(
                    layoutBuilder: _colorLayoutBuilder,
                    itemBuilder: _colorItemBuilder,
                    pickerColor: selectedColor ?? Colors.orange,
                    onColorChanged: (Color color) => tempColor = color,
                  ),
                ],
              ),
            ),
          ],
        );
      },
      backgroundColor: Colors.white,
    );
  }

  static Widget _colorItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.8),
            offset: Offset(1.0, 2.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(50.0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 210),
            opacity: isCurrentColor ? 1.0 : 0.0,
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _colorLayoutBuilder(
      BuildContext context, List<Color> colors, ColorPickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      width: orientation == Orientation.portrait ? 300.0 : 300.0,
      height: orientation == Orientation.portrait ? 360.0 : 200.0,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 5 : 6,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        children: colors.map((Color color) => child(color)).toList(),
      ),
    );
  }
}
