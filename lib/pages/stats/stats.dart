import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 统计分页页面.
class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    /// 注册监听
    UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);

    return Scaffold(
      body: Container(
        child: Text("统计分析"),
      ),
    );
  }
}
