import 'package:auto_route/annotations.dart';
import 'package:blood_sugar_recorder/main.dart';
import 'package:blood_sugar_recorder/pages/config/blood_sugar_setting.dart';
import 'package:blood_sugar_recorder/pages/config/medicine_list.dart';
import 'package:blood_sugar_recorder/pages/config/medicine_setting.dart';
import 'package:blood_sugar_recorder/pages/config/setting_complete.dart';
import 'package:blood_sugar_recorder/pages/config/user_list.dart';
import 'package:blood_sugar_recorder/pages/config/user_setting.dart';
import 'package:blood_sugar_recorder/pages/index/index.dart';
import 'package:blood_sugar_recorder/pages/main/main.dart';
import 'package:blood_sugar_recorder/pages/record/medicine_record.dart';
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

    /// 用户列表页面.
    CustomRoute(
        page: UserListPage,
        transitionsBuilder: slideTransition,
        maintainState: false),

    /// 用户新增，编辑页面.
    CustomRoute(page: UserSettingPage, transitionsBuilder: slideTransition),

    /// 药物设置列表页.
    CustomRoute(
        page: MedicineListPage,
        transitionsBuilder: slideTransition,
        maintainState: false),

    /// 用户药物新增，编辑页面.
    CustomRoute(
        page: MedicineSettingPage,
        transitionsBuilder: slideTransition,
        maintainState: false),

    /// 用户血糖指标设置页面.
    CustomRoute(
        page: BloodSugarSettingPage, transitionsBuilder: slideTransition),

    /// 初始化设置完成页面.
    CustomRoute(page: SettingCompletePage, transitionsBuilder: slideTransition),

    /// 程序主页面.
    CustomRoute(
      page: MainPage,
      transitionsBuilder: slideTransition,
    ),
    /// 药物使用记录新增修改页面.
    CustomRoute(
        page: MedicineRecordPage,
        transitionsBuilder: slideTransition,
        maintainState: false),
    // CustomRoute(
    //     page: MainPage,
    //     transitionsBuilder: slideTransition,
    //     children: ([
    //       /// 数据记录入口.
    //       AutoRoute(page: RecordPage, maintainState: false),
    //
    //       /// 历史记录列表页面.
    //       AutoRoute(page: HistoryPage),
    //
    //       /// 统计分析页面.
    //       AutoRoute(page: StatsPage),
    //
    //       /// 设置入口页面
    //       AutoRoute(page: SettingPage),
    //     ])),
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
