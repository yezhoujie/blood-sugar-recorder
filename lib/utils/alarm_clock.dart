import 'package:android_intent_plus/android_intent.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// 创建系统闹钟
/// [time] 要创建的时间.
/// [message] 闹钟显示的提醒内容.
/// [vibrate] 是否震动
createAlarmClock(DateTime time, {String? message, bool vibrate = true}) async {
  if (time.isBefore(DateTime.now())) {
    /// 如果时间早于当前时间，跳过闹钟设置.
    return;
  }
  if (!Global.isIOS) {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.SET_ALARM',
      data: 'https://play.google.com/store/apps/details?'
          'id=com.google.android.apps.myapp',
      arguments: <String, dynamic>{
        // 'android.intent.extra.alarm.DAYS': <int>[2, 3, 4, 5, 6],
        'android.intent.extra.alarm.HOUR': time.hour,
        'android.intent.extra.alarm.MINUTES': time.minute,
        'android.intent.extra.alarm.SKIP_UI': true,
        'android.intent.extra.alarm.MESSAGE': message ?? "",
        'android.intent.extra.alarm.VIBRATE': vibrate,
      },
    );
    await intent.launch();
  }
}

createAlarmTimer(DateTime time, {String? message}) async {
  DateTime now = DateTime.now();
  if (time.isBefore(now)) {
    /// 如果时间早于当前时间，跳过闹钟设置.
    showTooltip(content: "无法设置早于当前时间的提醒");
    return;
  }
  int seconds = time.difference(now).inSeconds;
  if (seconds > 60 * 60 * 24) {
    /// 大于24小时.
    showTooltip(content: "无法设置24小时以后的提醒");
    return;
  }
  if (!Global.isIOS) {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.SET_TIMER',
      arguments: <String, dynamic>{
        // 'android.intent.extra.alarm.DAYS': <int>[2, 3, 4, 5, 6],
        'android.intent.extra.alarm.LENGTH': seconds,
        'android.intent.extra.alarm.SKIP_UI': false,
        'android.intent.extra.alarm.MESSAGE': message ?? "",
      },
    );
    await intent.launch();
  } else {
    /// todo 自动设定计时器信息.
    const url = 'Clock-timer://';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showNotification(
        type: NotificationType.ERROR,
        message: "打开定时器失败了",
      );
    }
  }
}

cancelAlarmClock(DateTime time) async {
  if (time.isBefore(DateTime.now())) {
    /// 如果时间早于当前时间，跳过闹钟设置.
    return;
  }
  if (!Global.isIOS) {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.DISMISS_ALARM',
      arguments: <String, dynamic>{
        "android.intent.extra.alarm.SEARCH_MODE": "android.label",
        'android.intent.extra.alarm.MESSAGE': '该测血糖啦',
        'android.intent.extra.alarm.SKIP_UI': true,
      },
    );
    await intent.launch();
  }
}

cancelAlarmTimer(DateTime time) async {
  if (time.isBefore(DateTime.now())) {
    /// 如果时间早于当前时间，跳过闹钟设置.
    return;
  }
  if (!Global.isIOS) {
    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.DISMISS_TIMER',
    );
    await intent.launch();
  }
}
