import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/widgets/avatar.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> userList = [];

  /// 当前用户.
  User _currentUser = Global.currentUser!;

  final List<Color> _defaultColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    // 获取所有用户列表.
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    /// 监听用户切换事件，触发rebuild.
    Provider.of<UserSwitchState>(context);
    _currentUser = Global.currentUser!;
    AutoRouter.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: Text(
        "用户列表",
        style: TextStyle(
          fontSize: 30.sp,
          color: AppColor.primaryText,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColor.primaryText,
          size: 35.sp,
        ),
        onPressed: () {
          AutoRouter.of(context)
              .pushAndPopUntil(MainRoute(tabIndex: 3), predicate: (_) => false);
        },
      ),
    );
  }

  /// 构建药物列表.
  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xf5f5f7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildUserList(),
      ),
    );
  }

  List<Widget> _buildUserList() {
    return [
      Padding(padding: EdgeInsets.only(top: 10.h)),
      Card(
        color: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 500.h,
            maxHeight: 500.h,
          ),
          child: _buildUserItems(),
        ),
      ),
      SizedBox(
        height: 100.h,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: seFlatButton(
            onPressed: () {
              /// 跳转到创建用户页面.
              AutoRouter.of(context).push(UserSettingRoute(
                init: false,
                create: true,
              ));
            },
            title: "添加用户",
            width: 300.w,
            height: 70.h,
            fontSize: 25.sp,
            bgColor: Colors.amber,
            fontColor: Colors.black54,
            fontWeight: FontWeight.w900,
          ),
        ),
      )
    ];
  }

  Widget _buildUserItems() {
    Random random = Random();
    return this.userList.isEmpty
        ? Align(
            alignment: Alignment.center,
            child: Text(
              "还没有任何用户，赶快创建吧",
              style: TextStyle(
                color: AppColor.thirdElementText,
                fontSize: 20.sp,
              ),
            ),
          )
        : ListView(
            children: ListTile.divideTiles(
                context: context,
                tiles: this.userList.map(
                      (e) => ListTile(
                        horizontalTitleGap: 30.w,
                        leading: Container(
                          margin: EdgeInsets.only(top: 5.h),
                          width: 70.w,
                          height: 40.w,
                          child: Row(
                            children: [
                              Icon(
                                Icons.done,
                                size: 30.w,
                                color: e.id == this._currentUser.id
                                    ? Colors.green
                                    : Colors.transparent,
                              ),
                              getCircleAvatarByName(
                                fontSize: 20,
                                name: e.name,
                                radius: 20,
                                backgroundColor: e.id == this._currentUser.id
                                    ? Colors.amber
                                    : this._defaultColors[random.nextInt(19)],
                              )
                            ],
                          ),
                        ),
                        title: Text(
                          e.name,
                          style: TextStyle(
                            fontSize: 20.sp,
                          ),
                        ),
                        trailing: PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: RadiusConstant.k6pxRadius,
                          ),
                          offset: Offset(0, 40.h),
                          iconSize: 30.sp,
                          itemBuilder: (BuildContext bc) {
                            const operationList = [
                              {
                                "key": "edit",
                                "title": "修改",
                                "icon": Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                )
                              },
                              {
                                "key": "delete",
                                "title": "删除",
                                "icon": Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )
                              },
                              {
                                "key": "switch",
                                "title": "设置为当前用户",
                                "icon": Icon(
                                  Icons.switch_account,
                                  color: Colors.blue,
                                )
                              }
                            ];
                            return operationList
                                .map((operation) => PopupMenuItem(
                                      enabled: !(e.id == this._currentUser.id &&
                                          operation['key'] == "delete"),
                                      child: Row(
                                        children: [
                                          operation["icon"] as Widget,
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10.w)),
                                          Text(
                                            operation["title"].toString(),
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value: operation['key'].toString(),
                                    ))
                                .toList();
                          },
                          onSelected: (value) async {
                            if (value == "edit") {
                              context.pushRoute(
                                  UserSettingRoute(init: false, userId: e.id));
                            } else if (value == "delete") {
                              _handleDelete(e);
                            } else {
                              /// 切换用户.
                              if (e.id != _currentUser.id) {
                                Global.saveCurrentUser(e);
                                Provider.of<UserSwitchState>(context,
                                        listen: false)
                                    .switchCurrentUserTo(e);
                              }
                              showNotification(
                                  type: NotificationType.SUCCESS,
                                  message: "用户切换成功");
                            }
                          },
                        ),
                      ),
                    )).toList(),
          );
  }

  ///////////////事件，数据处理区域////////////////

  /// 初始化获取药物列表.
  _loadData() async {
    List<User> userList = await UserService().findAll();
    this.userList = userList;
    if (mounted) {
      setState(() {});
    }
  }

  void _handleDelete(User e) async {
    // 删除提示框.
    OkCancelResult res = await showOkCancelAlertDialog(
      context: this.context,
      title: "确定要删除吗？",
      message: "将会删除以下信息且不可恢复：\n 1.用户信息 \n 2.该用户的配置信息 \n 3.该用户下的所有记录数据",
      okLabel: "确定",
      cancelLabel: "取消",
      barrierDismissible: false,
    );

    if (res.index == OkCancelResult.ok.index) {
      await UserService().deleteById(e.id!);
      showNotification(type: NotificationType.SUCCESS, message: "删除成功");

      /// 刷新页面.
      AutoRouter.of(context).popAndPush(UserListRoute());
    }
  }
}
