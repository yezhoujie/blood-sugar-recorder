import 'dart:math';

import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/avatar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// 显示切换用户浮动窗口.
CancelFunc showUserSelector({
  required BuildContext context,
  PreferDirection preferDirection = PreferDirection.bottomRight,
  Color backgroundColor = Colors.transparent,
}) {
  return BotToast.showAttachedWidget(
      targetContext: context,
      verticalOffset: 0,
      horizontalOffset: 5.w,
      animationDuration: Duration(milliseconds: 200),
      animationReverseDuration: Duration(milliseconds: 200),
      preferDirection: preferDirection,
      ignoreContentClick: false,
      onlyOne: true,
      allowClick: true,
      enableSafeArea: true,
      backgroundColor: backgroundColor,
      attachedBuilder: (cancel) => UserSelectionCard(
            cancelFunc: cancel,
          ));
}

/// 用户切换卡片.
class UserSelectionCard extends StatefulWidget {
  final CancelFunc cancelFunc;

  UserSelectionCard({Key? key, required this.cancelFunc}) : super(key: key);

  @override
  _UserSelectionCardState createState() => _UserSelectionCardState();
}

class _UserSelectionCardState extends State<UserSelectionCard> {
  // final List
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

  final List<User> _userList = [
    Global.currentUser!,
  ];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 250.h,
          maxWidth: 300.w,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: RadiusConstant.k6pxRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              ),
            ],
          ),
          child: Card(
            child: ListView(
              shrinkWrap: true,
              children: ListTile.divideTiles(
                context: context,
                tiles: _buildUserList(),
              ).toList(),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _loadOtherUsers();
  }

  Future _loadOtherUsers() async {
    List<User> userList = await UserService().findAll();
    _userList.addAll(userList
        .where((element) => element.id != (Global.currentUser?.id ?? -1))
        .toList());
    if (mounted) {
      setState(() {});
    }
  }

  /// 构建用户选择列表.
  List<Widget> _buildUserList() {
    Random random = Random();
    return this._userList.asMap().entries.map((e) {
      if (e.key == 0) {
        /// 当前用户.
        return ListTile(
          onTap: () => widget.cancelFunc(),
          horizontalTitleGap: 30.w,
          leading: getCircleAvatarByName(name: e.value.name, radius: 30),
          title: Text(
            e.value.name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            _getAge(e.value.birthday),
            style: TextStyle(
              fontSize: 20.sp,
              color: AppColor.thirdElementText,
            ),
          ),
          trailing: Icon(
            Icons.done,
            size: 40.w,
            color: Colors.green,
          ),
        );
      } else {
        /// 其他用户.
        return ListTile(
          onTap: () async {
            /// 切换用户.
            await Global.saveCurrentUser(e.value);
            // todo provider 切换用户.
            Provider.of<UserSwitchState>(context, listen: false).switchCurrentUserTo(e.value);

            widget.cancelFunc();
          },
          leading: getCircleAvatarByName(
              name: e.value.name,
              radius: 30,
              backgroundColor: this._defaultColors[random.nextInt(19)]),
          horizontalTitleGap: 30.w,
          title: Text(
            e.value.name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            _getAge(e.value.birthday),
            style: TextStyle(
              fontSize: 20.sp,
              color: AppColor.thirdElementText,
            ),
          ),
        );
      }
    }).toList();
  }

  String _getAge(DateTime birthday) {
    return "${getAge(birthday)}岁";
  }
}
