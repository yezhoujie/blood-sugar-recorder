import 'package:flutter/material.dart';

/// 统计饼图数据结构.
class PieChartData {
  /// 记录数.
  int recordNum;

  String title;

  /// 百分比.
  double percent;

  Color color;

  PieChartData({
    required this.recordNum,
    required this.title,
    required this.percent,
    required this.color,
  });
}
