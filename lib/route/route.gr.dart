// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:blood_sugar_recorder/main.dart' as _i3;
import 'package:flutter/material.dart' as _i2;

class AppRoute extends _i1.RootStackRouter {
  AppRoute([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    MyHomeRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MyHomeRouteArgs>();
          return _i3.MyHomePage(key: args.key, title: args.title);
        })
  };

  @override
  List<_i1.RouteConfig> get routes =>
      [_i1.RouteConfig(MyHomeRoute.name, path: '/')];
}

class MyHomeRoute extends _i1.PageRouteInfo<MyHomeRouteArgs> {
  MyHomeRoute({_i2.Key? key, required String title})
      : super(name, path: '/', args: MyHomeRouteArgs(key: key, title: title));

  static const String name = 'MyHomeRoute';
}

class MyHomeRouteArgs {
  const MyHomeRouteArgs({this.key, required this.title});

  final _i2.Key? key;

  final String title;
}
