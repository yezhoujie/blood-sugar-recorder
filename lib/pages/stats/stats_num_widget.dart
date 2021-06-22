import 'package:animated_digit/animated_digit.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/utils/number_format.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 统计中待滚动动画的数字项.
/// [title] 统计项名称.
/// [num] 展示的数字 int 或者 double 或者为null
/// [numColor] 数字展示的颜色.
/// [unit] 数字后面的单位.
/// [titleSize] 统计项名称的字体大小.
/// [numSize] 数字展示的字体大小.
///
class StatsNumWidget extends StatefulWidget {
  final String title;
  final dynamic num;
  final Color numColor;
  final String unit;
  final double? titleSize;
  final double? numSize;

  const StatsNumWidget({
    Key? key,
    required this.title,
    this.num,
    required this.numColor,
    required this.unit,
    this.titleSize,
    this.numSize,
  })  : assert(null == num || num is int || num is double),
        super(key: key);

  @override
  _StatsNumWidgetState createState() => _StatsNumWidgetState();
}

class _StatsNumWidgetState extends State<StatsNumWidget> {
  /// 展示滚动的数字
  dynamic _showNum = 0;

  /// 展示滚动的数字后面的单位: 万/亿
  String? _showNumUnit;
  AnimatedDigitController _controller = AnimatedDigitController(0);

  @override
  Widget build(BuildContext context) {
    this._setNum();
    return Expanded(
      flex: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: widget.titleSize ?? 23.sp,
              color: AppColor.thirdElementText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 0.1.h,
          ),
          SizedBox(
            height: 50.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(
                  builder: (numContext) {
                    return InkWell(
                      onTap: () {
                        showTooltip(
                            context: numContext,
                            content: "${widget.num}",
                            preferDirection: PreferDirection.bottomCenter);
                      },
                      child: _getNumItem(),
                    );
                  },
                ),
                SizedBox(
                  width: 5.w,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Text(
                    widget.unit,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.thirdElementText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._setNum();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  Widget _getNumItem() {
    List<Widget> children = [];
    children.add(
      AnimatedDigitWidget(
        controller: _controller,
        textStyle: TextStyle(
          fontSize: widget.numSize ?? 30.sp,
          color: widget.numColor,
          fontWeight: FontWeight.bold,
        ),
        fractionDigits: (this._showNum is int) ? 0 : 2,
        enableDigitSplit: false,
      ),
    );
    if (this._showNumUnit != null) {
      children.add(Text(
        this._showNumUnit!,
        style: TextStyle(
          fontSize: widget.numSize ?? 24.sp,
          color: widget.numColor,
          fontWeight: FontWeight.bold,
        ),
      ));
    }

    return Row(
      children: children,
    );
  }

  _setNum() {
    if (null != widget.num) {
      if (widget.num is int) {
        String formatted = formatNum(widget.num as int);
        String last = formatted[formatted.length - 1];
        if (int.tryParse(last) == null) {
          /// 数字后面有单位.
          this._showNumUnit = last;
          this._showNum =
              double.parse(formatted.substring(0, formatted.length - 1));
        } else {
          this._showNumUnit = null;
          this._showNum = widget.num;
        }
      } else if (widget.num is double) {
        this._showNum = widget.num;
      }
      this._controller.resetValue(this._showNum);
    }

    if (mounted) {
      setState(() {});
    }
  }
}
