import 'package:flutter/material.dart';
/// 数字滚动效果.
class NumberSlideAnimation extends StatefulWidget {
  /// The number that should be displayed
  ///
  /// It should fit following constraints:
  ///
  /// number != null
  /// number should contain ONLY of numeric values
  final String number;

  /// The TextStyle of each number tile
  ///
  /// defaults to: TextStyle(fontSize: 16.0)
  final TextStyle textStyle;

  /// The duration of the whole animation
  ///
  /// defaults to: const Duration(milliseconds: 1500)
  final Duration duration;

  /// The Curve in which the animation is displayed
  ///
  /// defaults to: Curves.easeIn
  final Curve curve;

  NumberSlideAnimation({
    required this.number,
    this.textStyle = const TextStyle(fontSize: 16.0),
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeIn,
  });

  @override
  _NumberSlideAnimationState createState() => _NumberSlideAnimationState();
}

class _NumberSlideAnimationState extends State<NumberSlideAnimation> {
  double _width = 1000.0;

  GlobalKey _rowKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // print(getRowSize().width.toString());
      setState(() {
        _width = getRowSize().width;
      });

      // print(_width.toString());
    });
  }

  Size getRowSize() {
    final RenderBox box =
        _rowKey.currentContext!.findRenderObject() as RenderBox;
    return box.size;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      key: _rowKey,
      children: List.generate(widget.number.length, (position) {
        if (int.tryParse(widget.number[position]) == null) {
          return Text(
            widget.number[position],
            style: widget.textStyle,
          );
        }
        return NumberCol(
          animateTo: int.parse(widget.number[position]),
          textStyle: widget.textStyle,
          duration: widget.duration,
          curve: widget.curve,
        );
      }),
    );
  }
}

/// Each [NumberCol] has the numbers 0-9 stacked inside of a [SingleChildScrollView]
/// via a [ScrollController] the position will be animated to the requested number
class NumberCol extends StatefulWidget {
  /// The number the col should animate to
  final int animateTo;

  /// The [TextStyle] of the number
  final TextStyle textStyle;

  // The [Duration] the animation will take to slide the number into place
  final Duration duration;

  // The curve that is used during the animation
  final Curve curve;

  NumberCol({
    required this.animateTo,
    required this.textStyle,
    required this.duration,
    required this.curve,
  }) : assert(animateTo >= 0 && animateTo < 10);

  @override
  _NumberColState createState() => _NumberColState();
}

class _NumberColState extends State<NumberCol>
    with SingleTickerProviderStateMixin {
  ScrollController? _scrollController;

  double _elementSize = 0.0;

  @override
  void initState() {
    _scrollController = new ScrollController();

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _elementSize = _scrollController!.position.maxScrollExtent / 10;
      setState(() {});

      _scrollController!.animateTo(_elementSize * widget.animateTo,
          duration: widget.duration, curve: widget.curve);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: _elementSize),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: List.generate(10, (position) {
              return Text(position.toString(), style: widget.textStyle);
            }),
          ),
        ),
      ),
    );
  }
}
