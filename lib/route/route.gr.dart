// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:blood_sugar_recorder/main.dart' as _i8;
import 'package:blood_sugar_recorder/pages/config/medicine_setting.dart' as _i7;
import 'package:blood_sugar_recorder/pages/config/user_setting.dart' as _i5;
import 'package:blood_sugar_recorder/pages/index/index.dart' as _i3;
import 'package:blood_sugar_recorder/pages/welcome/welcome.dart' as _i4;
import 'package:blood_sugar_recorder/route/route.dart' as _i6;
import 'package:flutter/material.dart' as _i2;

class AppRoute extends _i1.RootStackRouter {
  AppRoute([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    IndexRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.IndexPage();
        }),
    WelcomeRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i4.WelcomePage();
        }),
    UserSettingRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<UserSettingRouteArgs>();
          return _i5.UserSettingPage(key: args.key, init: args.init);
        },
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    MedicineSettingRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MedicineSettingRouteArgs>(
              orElse: () => const MedicineSettingRouteArgs());
          return _i7.MedicineSettingPage(key: args.key, id: args.id);
        },
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    MyHomeRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MyHomeRouteArgs>();
          return _i8.MyHomePage(key: args.key, title: args.title);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(IndexRoute.name, path: '/'),
        _i1.RouteConfig(WelcomeRoute.name, path: '/welcome-page'),
        _i1.RouteConfig(UserSettingRoute.name, path: '/user-setting-page'),
        _i1.RouteConfig(MedicineSettingRoute.name,
            path: '/medicine-setting-page'),
        _i1.RouteConfig(MyHomeRoute.name, path: '/my-home-page')
      ];
}

class IndexRoute extends _i1.PageRouteInfo {
  const IndexRoute() : super(name, path: '/');

  static const String name = 'IndexRoute';
}

class WelcomeRoute extends _i1.PageRouteInfo {
  const WelcomeRoute() : super(name, path: '/welcome-page');

  static const String name = 'WelcomeRoute';
}

class UserSettingRoute extends _i1.PageRouteInfo<UserSettingRouteArgs> {
  UserSettingRoute({_i2.Key? key, required bool init})
      : super(name,
            path: '/user-setting-page',
            args: UserSettingRouteArgs(key: key, init: init));

  static const String name = 'UserSettingRoute';
}

class UserSettingRouteArgs {
  const UserSettingRouteArgs({this.key, required this.init});

  final _i2.Key? key;

  final bool init;
}

class MedicineSettingRoute extends _i1.PageRouteInfo<MedicineSettingRouteArgs> {
  MedicineSettingRoute({_i2.Key? key, int? id})
      : super(name,
            path: '/medicine-setting-page',
            args: MedicineSettingRouteArgs(key: key, id: id));

  static const String name = 'MedicineSettingRoute';
}

class MedicineSettingRouteArgs {
  const MedicineSettingRouteArgs({this.key, this.id});

  final _i2.Key? key;

  final int? id;
}

class MyHomeRoute extends _i1.PageRouteInfo<MyHomeRouteArgs> {
  MyHomeRoute({_i2.Key? key, required String title})
      : super(name,
            path: '/my-home-page',
            args: MyHomeRouteArgs(key: key, title: title));

  static const String name = 'MyHomeRoute';
}

class MyHomeRouteArgs {
  const MyHomeRouteArgs({this.key, required this.title});

  final _i2.Key? key;

  final String title;
}
