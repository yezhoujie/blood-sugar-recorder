// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:blood_sugar_recorder/main.dart' as _i13;
import 'package:blood_sugar_recorder/pages/config/blood_sugar_setting.dart'
    as _i10;
import 'package:blood_sugar_recorder/pages/config/medicine_list.dart' as _i8;
import 'package:blood_sugar_recorder/pages/config/medicine_setting.dart' as _i9;
import 'package:blood_sugar_recorder/pages/config/setting_complete.dart'
    as _i11;
import 'package:blood_sugar_recorder/pages/config/user_list.dart' as _i5;
import 'package:blood_sugar_recorder/pages/config/user_setting.dart' as _i7;
import 'package:blood_sugar_recorder/pages/index/index.dart' as _i3;
import 'package:blood_sugar_recorder/pages/main/main.dart' as _i12;
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
    UserListRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i5.UserListPage();
        },
        maintainState: false,
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    UserSettingRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<UserSettingRouteArgs>();
          return _i7.UserSettingPage(
              key: args.key,
              init: args.init,
              userId: args.userId,
              create: args.create);
        },
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    MedicineListRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MedicineListRouteArgs>(
              orElse: () => const MedicineListRouteArgs());
          return _i8.MedicineListPage(key: args.key);
        },
        maintainState: false,
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    MedicineSettingRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MedicineSettingRouteArgs>();
          return _i9.MedicineSettingPage(
              key: args.key, id: args.id, init: args.init);
        },
        maintainState: false,
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    BloodSugarSettingRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<BloodSugarSettingRouteArgs>();
          return _i10.BloodSugarSettingPage(key: args.key, init: args.init);
        },
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    SettingCompleteRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return const _i11.SettingCompletePage();
        },
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    MainRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MainRouteArgs>();
          return _i12.MainPage(key: args.key, tabIndex: args.tabIndex);
        },
        maintainState: false,
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    MyHomeRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MyHomeRouteArgs>();
          return _i13.MyHomePage(key: args.key, title: args.title);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(IndexRoute.name, path: '/'),
        _i1.RouteConfig(WelcomeRoute.name, path: '/welcome-page'),
        _i1.RouteConfig(UserListRoute.name, path: '/user-list-page'),
        _i1.RouteConfig(UserSettingRoute.name, path: '/user-setting-page'),
        _i1.RouteConfig(MedicineListRoute.name, path: '/medicine-list-page'),
        _i1.RouteConfig(MedicineSettingRoute.name,
            path: '/medicine-setting-page'),
        _i1.RouteConfig(BloodSugarSettingRoute.name,
            path: '/blood-sugar-setting-page'),
        _i1.RouteConfig(SettingCompleteRoute.name,
            path: '/setting-complete-page'),
        _i1.RouteConfig(MainRoute.name, path: '/main-page'),
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

class UserListRoute extends _i1.PageRouteInfo {
  const UserListRoute() : super(name, path: '/user-list-page');

  static const String name = 'UserListRoute';
}

class UserSettingRoute extends _i1.PageRouteInfo<UserSettingRouteArgs> {
  UserSettingRoute(
      {_i2.Key? key, required bool init, int? userId, bool? create})
      : super(name,
            path: '/user-setting-page',
            args: UserSettingRouteArgs(
                key: key, init: init, userId: userId, create: create));

  static const String name = 'UserSettingRoute';
}

class UserSettingRouteArgs {
  const UserSettingRouteArgs(
      {this.key, required this.init, this.userId, this.create});

  final _i2.Key? key;

  final bool init;

  final int? userId;

  final bool? create;
}

class MedicineListRoute extends _i1.PageRouteInfo<MedicineListRouteArgs> {
  MedicineListRoute({_i2.Key? key})
      : super(name,
            path: '/medicine-list-page', args: MedicineListRouteArgs(key: key));

  static const String name = 'MedicineListRoute';
}

class MedicineListRouteArgs {
  const MedicineListRouteArgs({this.key});

  final _i2.Key? key;
}

class MedicineSettingRoute extends _i1.PageRouteInfo<MedicineSettingRouteArgs> {
  MedicineSettingRoute({_i2.Key? key, int? id, required bool init})
      : super(name,
            path: '/medicine-setting-page',
            args: MedicineSettingRouteArgs(key: key, id: id, init: init));

  static const String name = 'MedicineSettingRoute';
}

class MedicineSettingRouteArgs {
  const MedicineSettingRouteArgs({this.key, this.id, required this.init});

  final _i2.Key? key;

  final int? id;

  final bool init;
}

class BloodSugarSettingRoute
    extends _i1.PageRouteInfo<BloodSugarSettingRouteArgs> {
  BloodSugarSettingRoute({_i2.Key? key, required bool init})
      : super(name,
            path: '/blood-sugar-setting-page',
            args: BloodSugarSettingRouteArgs(key: key, init: init));

  static const String name = 'BloodSugarSettingRoute';
}

class BloodSugarSettingRouteArgs {
  const BloodSugarSettingRouteArgs({this.key, required this.init});

  final _i2.Key? key;

  final bool init;
}

class SettingCompleteRoute extends _i1.PageRouteInfo {
  const SettingCompleteRoute() : super(name, path: '/setting-complete-page');

  static const String name = 'SettingCompleteRoute';
}

class MainRoute extends _i1.PageRouteInfo<MainRouteArgs> {
  MainRoute({_i2.Key? key, required int tabIndex})
      : super(name,
            path: '/main-page',
            args: MainRouteArgs(key: key, tabIndex: tabIndex));

  static const String name = 'MainRoute';
}

class MainRouteArgs {
  const MainRouteArgs({this.key, required this.tabIndex});

  final _i2.Key? key;

  final int tabIndex;
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
