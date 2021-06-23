import 'package:intl/intl.dart';

String formatDateline(DateTime? date) {
  if (null == date) {
    return "Unknown";
  }
  var now = DateTime.now();
  var diff = now.difference(date);

  // 一天以内
  if (diff.inHours < 24) {
    return "${diff.inHours} hours ago";
  }
  // 30天以内
  else if (diff.inDays < 30) {
    return "${diff.inDays} days ago";
  }
  // 一年内 显示 MM-dd
  else if (diff.inDays < 365) {
    final DateFormat format = new DateFormat("MM-dd");
    return format.format(date);
  }
  // 显示 yyyy-MM-dd
  else {
    final DateFormat format = new DateFormat("yyyy-MM-dd");
    return format.format(date);
  }
}

/// 获取年龄.
int getAge(DateTime birthday) {
  return DateTime.now().year - birthday.year;
}
