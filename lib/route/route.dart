import 'package:auto_route/annotations.dart';
import 'package:blood_sugar_recorder/main.dart';
import 'package:flutter/material.dart';

@MaterialAutoRouter(
  preferRelativeImports: false,
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: MyHomePage, initial: true),
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
