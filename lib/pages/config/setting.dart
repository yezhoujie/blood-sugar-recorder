import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/appColor.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// 设置入口页面.
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  User _currentUser = Global.currentUser!;
  final TextStyle settingItemTextStyle = TextStyle(
    fontSize: 20.sp,
  );

  @override
  Widget build(BuildContext context) {
    /// 初始化路由.
    AutoRouter.of(context);

    /// 如果用户切换，应该初始化页面的数据.
    _dataRefresh();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xf5f5f7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(padding: EdgeInsets.only(top: 10.h)),
            Text(
              '个人设置',
              style: TextStyle(
                color: AppColor.thirdElementText,
                fontSize: 15.sp,
              ),
            ),

            /// 用户设置卡片.
            _buildPersonalSettingCard(),

            Padding(padding: EdgeInsets.only(top: 30.h)),
            Text(
              '用户管理',
              style: TextStyle(
                color: AppColor.thirdElementText,
                fontSize: 15.sp,
              ),
            ),

            /// 用户设置设置卡片.
            _buildUserSettingCard(),

            Padding(padding: EdgeInsets.only(top: 30.h)),
            Text(
              '关于',
              style: TextStyle(
                color: AppColor.thirdElementText,
                fontSize: 15.sp,
              ),
            ),

            /// 关于卡片.
            _buildAboutCard(),

          ],
        ),
      ),
    );
  }

  Widget _getTextTrailing({
    required String text,
    Function()? onPress,
  }) {
    return SizedBox(
      width: 210.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _getMainText(
            value: text,
            color: AppColor.thirdElementText,
            fontSize: 20.sp,
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: AppColor.thirdElementText,
            ),
            onPressed: onPress,
          ),
        ],
      ),
    );
  }

  Widget _getMainText({
    required String value,
    Color? color,
    double? fontSize,
  }) {
    return Text(value,
        style: TextStyle(
          fontSize: fontSize ?? 30.sp,
          color: color ?? Colors.black,
        ));
  }


  Widget _buildAboutCard(){
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              '版本号',
              style: this.settingItemTextStyle,
            ),
            trailing: _getMainText(
              value: Global.packageInfo!.version,
              color: AppColor.thirdElementText,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSettingCard() {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              '用户管理',
              style: this.settingItemTextStyle,
            ),
            trailing: _getTextTrailing(
              text: "",
              onPress: () => context.pushRoute(UserListRoute()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalSettingCard() {
    /// 监听当前用户的切换状态.
    UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);

    return Card(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              '个人信息',
              style: this.settingItemTextStyle,
            ),
            trailing: _getTextTrailing(
              text: userSwitchState.currentUser!.name,
              onPress: () => context.pushRoute(
                UserSettingRoute(
                  init: false,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              '药物设置',
              style: this.settingItemTextStyle,
            ),
            trailing: _getTextTrailing(
              text: "",
              onPress: () => context.pushRoute(MedicineListRoute()),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              '血糖指标设置',
              style: this.settingItemTextStyle,
            ),
            trailing: _getTextTrailing(
              text: "",
              onPress: () => context.pushRoute(
                BloodSugarSettingRoute(
                  init: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///////////////////事件处理区域///////////////////////
  void _dataRefresh() {
    if (this._currentUser.id != Global.currentUser!.id) {
      this._currentUser = Global.currentUser!;
      print("reload data");

      /// todo reload data.
    }
  }
}
