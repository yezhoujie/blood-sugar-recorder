import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 显示loading
/// 要取消loading 请调用该方法的返回[CancelFunc]
CancelFunc showLoading() {
  return BotToast.showCustomLoading(
      clickClose: false,
      allowClick: false,
      backButtonBehavior: BackButtonBehavior.none,
      ignoreContentClick: true,
      animationDuration: Duration(milliseconds: 200),
      animationReverseDuration: Duration(milliseconds: 200),
      duration: null,
      backgroundColor: Color(0x42000000),
      align: Alignment.center,
      toastBuilder: (cancelFunc) {
        return _CustomLoadWidget(cancelFunc: cancelFunc);
      });
}

class _CustomLoadWidget extends StatefulWidget {
  final CancelFunc cancelFunc;

  const _CustomLoadWidget({Key? key, required this.cancelFunc})
      : super(key: key);

  @override
  __CustomLoadWidgetState createState() => __CustomLoadWidgetState();
}

class __CustomLoadWidgetState extends State<_CustomLoadWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: RadiusConstant.k6pxRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FadeTransition(
              opacity: animationController,
              child: Icon(Iconfont.xietang, color: Colors.redAccent, size: 60),
            ),
            Padding(
              padding: EdgeInsets.all(8.0.h),
              child: Text(
                "处理中....",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColor.thirdElementText,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
