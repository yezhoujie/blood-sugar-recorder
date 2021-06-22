import 'package:intl/intl.dart';

String formatNum(int number) {
  if (number < 10000) {
    return "$number";
  } else if (number < 100000000) {
    double target = number / 10000.0;
    return "${NumberFormat('####.0#').format(target)}万";
  }
  double target = number / 10000.0 / 10000.0;
  return "${NumberFormat('####.0#').format(target)}亿";
}
