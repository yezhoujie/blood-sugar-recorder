// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:blood_sugar_recorder/domain/domain.dart' as _i18;
import 'package:blood_sugar_recorder/main.dart' as _i16;
import 'package:blood_sugar_recorder/pages/config/blood_sugar_setting.dart'
    as _i10;
import 'package:blood_sugar_recorder/pages/config/medicine_list.dart' as _i8;
import 'package:blood_sugar_recorder/pages/config/medicine_setting.dart' as _i9;
import 'package:blood_sugar_recorder/pages/config/setting_complete.dart'
    as _i11;
import 'package:blood_sugar_recorder/pages/config/user_list.dart' as _i5;
import 'package:blood_sugar_recorder/pages/config/user_setting.dart' as _i7;
import 'package:blood_sugar_recorder/pages/history/history.dart' as _i17;
import 'package:blood_sugar_recorder/pages/index/index.dart' as _i3;
import 'package:blood_sugar_recorder/pages/main/main.dart' as _i12;
import 'package:blood_sugar_recorder/pages/record/blood_sugar_record.dart'
    as _i15;
import 'package:blood_sugar_recorder/pages/record/food_record.dart' as _i14;
import 'package:blood_sugar_recorder/pages/record/medicine_record.dart' as _i13;
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
          return _i12.MainPage(
              key: args.key,
              tabIndex: args.tabIndex,
              historyFilterConfig: args.historyFilterConfig);
        },
        maintainState: false,
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    MedicineRecordRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MedicineRecordRouteArgs>();
          return _i13.MedicineRecordPage(
              key: args.key,
              medicineRecordItem: args.medicineRecordItem,
              cycleId: args.cycleId,
              autoSave: args.autoSave,
              parentRouter: args.parentRouter,
              returnWithPop: args.returnWithPop);
        },
        maintainState: false,
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    FoodRecordRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<FoodRecordRouteArgs>();
          return _i14.FoodRecordPage(
              key: args.key,
              foodRecordItem: args.foodRecordItem,
              cycleId: args.cycleId,
              autoSave: args.autoSave,
              parentRouter: args.parentRouter,
              returnWithPop: args.returnWithPop);
        },
        maintainState: false,
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    BloodSugarRecordRoute.name: (routeData) => _i1.CustomPage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<BloodSugarRecordRouteArgs>();
          return _i15.BloodSugarRecordPage(
              key: args.key,
              bloodSugarRecordItem: args.bloodSugarRecordItem,
              cycleId: args.cycleId,
              autoSave: args.autoSave,
              returnWithPop: args.returnWithPop,
              parentRouter: args.parentRouter,
              showCloseButton: args.showCloseButton);
        },
        maintainState: false,
        transitionsBuilder: _i6.slideTransition,
        opaque: true,
        barrierDismissible: false),
    MyHomeRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<MyHomeRouteArgs>();
          return _i16.MyHomePage(key: args.key, title: args.title);
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
        _i1.RouteConfig(MedicineRecordRoute.name,
            path: '/medicine-record-page'),
        _i1.RouteConfig(FoodRecordRoute.name, path: '/food-record-page'),
        _i1.RouteConfig(BloodSugarRecordRoute.name,
            path: '/blood-sugar-record-page'),
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
  MainRoute(
      {_i2.Key? key,
      required int tabIndex,
      _i17.HistoryFilterConfig? historyFilterConfig})
      : super(name,
            path: '/main-page',
            args: MainRouteArgs(
                key: key,
                tabIndex: tabIndex,
                historyFilterConfig: historyFilterConfig));

  static const String name = 'MainRoute';
}

class MainRouteArgs {
  const MainRouteArgs(
      {this.key, required this.tabIndex, this.historyFilterConfig});

  final _i2.Key? key;

  final int tabIndex;

  final _i17.HistoryFilterConfig? historyFilterConfig;
}

class MedicineRecordRoute extends _i1.PageRouteInfo<MedicineRecordRouteArgs> {
  MedicineRecordRoute(
      {_i2.Key? key,
      _i18.MedicineRecordItem? medicineRecordItem,
      int? cycleId,
      required bool autoSave,
      _i1.PageRouteInfo<dynamic>? parentRouter,
      required bool returnWithPop})
      : super(name,
            path: '/medicine-record-page',
            args: MedicineRecordRouteArgs(
                key: key,
                medicineRecordItem: medicineRecordItem,
                cycleId: cycleId,
                autoSave: autoSave,
                parentRouter: parentRouter,
                returnWithPop: returnWithPop));

  static const String name = 'MedicineRecordRoute';
}

class MedicineRecordRouteArgs {
  const MedicineRecordRouteArgs(
      {this.key,
      this.medicineRecordItem,
      this.cycleId,
      required this.autoSave,
      this.parentRouter,
      required this.returnWithPop});

  final _i2.Key? key;

  final _i18.MedicineRecordItem? medicineRecordItem;

  final int? cycleId;

  final bool autoSave;

  final _i1.PageRouteInfo<dynamic>? parentRouter;

  final bool returnWithPop;
}

class FoodRecordRoute extends _i1.PageRouteInfo<FoodRecordRouteArgs> {
  FoodRecordRoute(
      {_i2.Key? key,
      _i18.FoodRecordItem? foodRecordItem,
      int? cycleId,
      required bool autoSave,
      _i1.PageRouteInfo<dynamic>? parentRouter,
      required bool returnWithPop})
      : super(name,
            path: '/food-record-page',
            args: FoodRecordRouteArgs(
                key: key,
                foodRecordItem: foodRecordItem,
                cycleId: cycleId,
                autoSave: autoSave,
                parentRouter: parentRouter,
                returnWithPop: returnWithPop));

  static const String name = 'FoodRecordRoute';
}

class FoodRecordRouteArgs {
  const FoodRecordRouteArgs(
      {this.key,
      this.foodRecordItem,
      this.cycleId,
      required this.autoSave,
      this.parentRouter,
      required this.returnWithPop});

  final _i2.Key? key;

  final _i18.FoodRecordItem? foodRecordItem;

  final int? cycleId;

  final bool autoSave;

  final _i1.PageRouteInfo<dynamic>? parentRouter;

  final bool returnWithPop;
}

class BloodSugarRecordRoute
    extends _i1.PageRouteInfo<BloodSugarRecordRouteArgs> {
  BloodSugarRecordRoute(
      {_i2.Key? key,
      _i18.BloodSugarRecordItem? bloodSugarRecordItem,
      int? cycleId,
      required bool autoSave,
      required bool returnWithPop,
      _i1.PageRouteInfo<dynamic>? parentRouter,
      bool? showCloseButton})
      : super(name,
            path: '/blood-sugar-record-page',
            args: BloodSugarRecordRouteArgs(
                key: key,
                bloodSugarRecordItem: bloodSugarRecordItem,
                cycleId: cycleId,
                autoSave: autoSave,
                returnWithPop: returnWithPop,
                parentRouter: parentRouter,
                showCloseButton: showCloseButton));

  static const String name = 'BloodSugarRecordRoute';
}

class BloodSugarRecordRouteArgs {
  const BloodSugarRecordRouteArgs(
      {this.key,
      this.bloodSugarRecordItem,
      this.cycleId,
      required this.autoSave,
      required this.returnWithPop,
      this.parentRouter,
      this.showCloseButton});

  final _i2.Key? key;

  final _i18.BloodSugarRecordItem? bloodSugarRecordItem;

  final int? cycleId;

  final bool autoSave;

  final bool returnWithPop;

  final _i1.PageRouteInfo<dynamic>? parentRouter;

  final bool? showCloseButton;
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
