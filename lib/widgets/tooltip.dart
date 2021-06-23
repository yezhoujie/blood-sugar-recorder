import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

CancelFunc showTooltip({
  BuildContext? context,
  Offset? target,
  PreferDirection preferDirection = PreferDirection.leftCenter,
  Color backgroundColor = Colors.transparent,
  String content = "tooltip",
  double fontSize = 20,
  Color fontColor = Colors.white,
  Color cardColor = Colors.black,
  Duration? duration,
}) {
  if (content.isEmpty) {
    return () {};
  }
  return BotToast.showAttachedWidget(
      target: target,
      targetContext: context,
      verticalOffset: 0,
      horizontalOffset: 0,
      duration: duration ?? Duration(seconds: 5),
      animationDuration: Duration(milliseconds: 200),
      animationReverseDuration: Duration(milliseconds: 200),
      preferDirection: preferDirection,
      ignoreContentClick: true,
      onlyOne: true,
      allowClick: true,
      enableSafeArea: true,
      backgroundColor: backgroundColor,
      attachedBuilder: (cancel) => (Card(
          color: cardColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: RadiusConstant.k6pxRadius,
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: fontSize.sp,
                color: fontColor,
              ),
            ),
            margin: EdgeInsets.all(20.w),
          ))));
}
