import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showToast({
  required String msg,
  Color bgColor = Colors.black,
  Color textColor = Colors.white,
  Alignment? position,
}) {
  BotToast.showText(
      text: msg,
      align: position ?? Alignment(0, -0.9),
      duration: Duration(seconds: 5),
      contentColor: bgColor,
      textStyle: TextStyle(
        color: textColor,
        fontSize: 16.sp,
      ));
}
