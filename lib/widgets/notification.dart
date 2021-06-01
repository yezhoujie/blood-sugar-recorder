import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///显示顶部成功失败提示.
CancelFunc showNotification(
    {required NotificationType type, required String message}) {
  return BotToast.showNotification(
    leading: (cancel) => SizedBox.fromSize(
        size: const Size(40, 40),
        child: IconButton(
          icon: _getIcon(type),
          onPressed: cancel,
        )),
    title: (_) => Text(
      message,
      style: TextStyle(
        fontSize: 18.sp,
        color: Colors.white,
      ),
    ),
    enableSlideOff: true,
    backButtonBehavior: BackButtonBehavior.none,
    crossPage: true,
    contentPadding: EdgeInsets.all(2.w),
    onlyOne: false,
    animationDuration: Duration(milliseconds: 200),
    animationReverseDuration: Duration(milliseconds: 200),
    duration: Duration(seconds: 5),
    backgroundColor: _getBackgroundColor(type),
  );
}

Color _getBackgroundColor(NotificationType type) {
  switch (type) {
    case NotificationType.SUCCESS:
      return Colors.green;
    case NotificationType.ERROR:
      return Color(0xFFB80606);
    default:
      return Colors.white;
  }
}

Icon _getIcon(NotificationType type) {
  switch (type) {
    case NotificationType.SUCCESS:
      return Icon(
        Iconfont.chenggong,
        size: 22,
        color: Colors.white,
      );
    case NotificationType.ERROR:
      return Icon(
        Iconfont.shibai,
        size: 20,
        color: Colors.white,
      );
    default:
      return Icon(
        Icons.warning,
        size: 20,
      );
  }
}

enum NotificationType {
  SUCCESS,
  ERROR,
}
