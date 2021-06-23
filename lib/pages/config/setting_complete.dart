import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 初始化设置完成页面.
class SettingCompletePage extends StatefulWidget {
  const SettingCompletePage({Key? key}) : super(key: key);

  @override
  _SettingCompletePageState createState() => _SettingCompletePageState();
}

class _SettingCompletePageState extends State<SettingCompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.amber,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "设置完成啦!",
                        style: TextStyle(
                          fontSize: 35.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(),
                          flex: 1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.w, left: 20.w),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "提示:\n 1.本程序采用周期记录方式\n 2.一个周期的流程一般为[药物使用]->[用餐]->[血糖测量]\n 3.每个周期内最多包含10条明细记录\n 4.所有配置项可在设置页面中重新修改",
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  color: AppColor.thirdElementText,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          flex: 7,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      /// 跳转到设置页面
                                      AutoRouter.of(context).pushAndPopUntil(
                                        MainRoute(tabIndex: 3),
                                        predicate: (route) => false,
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      primary: Colors.pink,
                                      side: BorderSide(
                                        color: Colors.pink,
                                        width: 1.8,
                                      ),
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    child: Text(
                                      "修改配置",
                                    ),
                                  ),
                                  width: 120.w,
                                  height: 50.h,
                                ),
                                SizedBox(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      /// 跳转到程序主页面
                                      AutoRouter.of(context).pushAndPopUntil(
                                        MainRoute(
                                          tabIndex: 0,
                                        ),
                                        predicate: (route) => false,
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: Colors.pink,
                                      textStyle: TextStyle(
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    child: Text(
                                      "开始记录",
                                    ),
                                  ),
                                  width: 120.w,
                                  height: 50.h,
                                ),
                              ],
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                  flex: 7,
                ),
              ],
            ),
            Positioned(
              bottom: ((812.0 - 44 - 24) * 0.7 - (100.sp / 2)).h,
              left: (375.w / 2) - (100.sp / 2),
              child: Icon(
                Iconfont.wancheng,
                size: 100.sp,
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }
}
