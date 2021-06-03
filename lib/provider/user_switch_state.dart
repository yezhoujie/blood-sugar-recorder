import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:flutter/material.dart';

/// 全局用户切换状态，在provider中使用.
class UserSwitchState with ChangeNotifier {
  User? _currentUser;

  UserSwitchState({User? currentUser}) {
    this._currentUser = currentUser;
  }

  User? get currentUser => _currentUser;

  void switchCurrentUserTo(User? user) {
    this._currentUser = user;
    // 通知所有监听改状态的组件触发刷新.
    notifyListeners();
  }
}
