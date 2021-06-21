/// 统计饼图数据结构.
class PieChartData {
  /// 记录数.
  int recordNum;

  String title;

  /// 百分比.
  double percent;

  PieChartData({
    required this.recordNum,
    required this.title,
    required this.percent,
  });
}
