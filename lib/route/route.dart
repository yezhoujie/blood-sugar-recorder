import 'package:auto_route/annotations.dart';
import 'package:blood_sugar_recorder/main.dart';
import 'package:blood_sugar_recorder/pages/config/medicine_setting.dart';
import 'package:blood_sugar_recorder/pages/config/user_setting.dart';
import 'package:blood_sugar_recorder/pages/index/index.dart';
import 'package:blood_sugar_recorder/pages/welcome/welcome.dart';
import 'package:flutter/material.dart';

@MaterialAutoRouter(
  preferRelativeImports: false,
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    /// 首页. 没有实质性内容，负责根据app状态进行页面跳转.
    AutoRoute(page: IndexPage, initial: true),

    /// 欢迎介绍页面.
    AutoRoute(page: WelcomePage),
    CustomRoute(page: UserSettingPage, transitionsBuilder: slideTransition),
    CustomRoute(page: MedicineSettingPage, transitionsBuilder: slideTransition),
    AutoRoute(page: MyHomePage),
  ],
)
class $AppRoute {}

/// 页面跳转动画1
Widget zoomInTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondAnimation, Widget child) {
  return ScaleTransition(
    scale: animation,
    child: child,
  );
}

/// 页面跳转动画2
Widget slideTransition(BuildContext context, Animation<double> animation,
    Animation<double> secondAnimation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}
