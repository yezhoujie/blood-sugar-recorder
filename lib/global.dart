import 'dart:io';

import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'domain/domain.dart';

/// 全局配置初始化类.
class Global {
  /// 用户信息.
  static User? currentUser;

  /// 程序版本（是否是发布版本）
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// 是否第一次打开程序
  static bool isFirstOpen = false;

  /// 是否 是IOS
  static bool isIOS = Platform.isIOS;

  /// android设备信息
  static AndroidDeviceInfo? androidDeviceInfo;

  /// IOS设备信息
  static IosDeviceInfo? iosDeviceInfo;

  /// app 安装包信息
  static PackageInfo? packageInfo;

  /// 数据库database;
  static late final database;

  ///初始化全局信息.
  static Future init() async {
    /// 保证程序启动前先初始化.
    WidgetsFlutterBinding.ensureInitialized();

    /// 初始化本地数据库.
    database = openDatabase(
      join(await getDatabasesPath(), "blood_sugar_recorder_database.db"),
      version: 1,
      onCreate: (db, version) async {
        // return db
        //     .execute(await rootBundle.loadString("resource/database/init.sql"));
        String sql = await rootBundle.loadString("resource/database/init.sql");
        List<String> scripts = sql.split(";");
        scripts.forEach((v) {
          if (v.isNotEmpty) {
            print(v.trim());
            db.execute(v.trim());
          }
        });
      },
    );

    /// 本地存储初始化
    await StorageUtil.init();

    ///读取当前操作的用户.
    var _profileJson = StorageUtil().getJSON(CURRENT_USER_ID_KEY);
    if (_profileJson != null) {
      currentUser = User.fromJson(_profileJson);
    }

    // 检测是否用户第一打开APP.
    isFirstOpen = null == currentUser;

    /// 初始化获取设备信息插件.
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    /// 获取设备信息.
    if (Global.isIOS) {
      Global.iosDeviceInfo = await deviceInfoPlugin.iosInfo;
    } else {
      Global.androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    }

    /// 获取安装包信息.
    Global.packageInfo = await PackageInfo.fromPlatform();
  }

  /// 存储当前操作用户信息.
  static Future<bool> saveCurrentUser(User user) {
    currentUser = user;
    return StorageUtil().setJson(CURRENT_USER_ID_KEY, user.toJson());
  }
}
