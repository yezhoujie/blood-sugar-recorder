import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/pages/main/custom_auto_route_observer.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 单周期，血糖，药物，进餐记录入口页面
class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  User _currentUser = Global.currentUser!;

  @override
  Widget build(BuildContext context) {
    /// 注册监听
    UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);

    _dataRefresh();
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          /// 如果只设计局部页面改变，不设计数据拉取.
          // Consumer<UserSwitchState>(
          //     builder: (context, state, child) =>
          //         Text("${state.currentUser!.name}")),
          // Text("${userSwitchState.currentUser!.name}"),
          Text("${Global.currentUser!.name}"),
        ],
      )),
    );
  }

  void _dataRefresh() {
    if (this._currentUser.id != Global.currentUser!.id) {
      this._currentUser = Global.currentUser!;
      print("reload data");
      // todo reload data.
    }
  }

  @override
  void initState() {
    super.initState();
    print("init");
  }

  @override
  void dispose() {
    print("disposed");
    super.dispose();
  }
}
