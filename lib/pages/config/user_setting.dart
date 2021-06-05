import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// 用户设置页面，创建或编辑.
class UserSettingPage extends StatefulWidget {
  final bool init;
  final int? userId;
  final bool? create;

  UserSettingPage({
    Key? key,
    required this.init,
    this.userId,
    this.create = false,
  }) : super(key: key);

  @override
  _UserSettingPageState createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  /// 性别枚举对应显示文字Map.
  final Map<Gender, String> _genderTextEnumMap = {
    Gender.MALE: '男',
    Gender.FEMALE: '女',
    Gender.UNKNOWN: '未知',
  };

  /// 当前用户.
  User? _currentUser;

  /// 姓名输入是否正确.
  bool _nameInputValid = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 姓名输入控制器
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /// 注册路由.
    AutoRouter.of(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 25.h),
        width: double.infinity,
        child: Column(
          children: [
            _buildNameConfig(),
            Divider(),
            _buildGenderConfig(),
            Divider(),
            _buildBirthdayConfig(),
            Divider(),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    if (null == widget.userId) {
      if (widget.create ?? false) {
        /// 创建新用户.
        _currentUser = User(
            name: "新建用户", gender: Gender.UNKNOWN, birthday: DateTime.now());
      } else {
        /// 获取当前用户.
        _currentUser = Global.currentUser ??
            User(
                name: "新建用户", gender: Gender.UNKNOWN, birthday: DateTime.now());
      }
      this._nameController..text = this._currentUser!.name;
    } else {
      /// 通过id 获取用户.
      _loadUserById();
    }

    // print(this._currentUser!.id);
  }

  /// 通过id 获取用户信息.
  void _loadUserById() async {
    _currentUser = await UserService().getById(widget.userId!);
    this._nameController..text = this._currentUser!.name;
    if (mounted) {
      setState(() {});
    }
  }

  /// 头部导航栏.
  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: Text(
        null == _currentUser?.id ? "创建用户" : "编辑用户",
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
          context.popRoute();
        },
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      height: 300.h,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: seFlatButton(
          onPressed: () {
            /// 跳转到创建用户页面.
            _handleSaveUserProfile();
          },
          title: "完成",
          width: 300.w,
          height: 70.h,
          fontSize: 25.sp,
          bgColor: Colors.amber,
          fontColor: Colors.black54,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  /// 构造生日设置项.
  Widget _buildBirthdayConfig() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, bottom: 0.h, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "*",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                ),
              ),
              Text(
                "生日",
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ],
          ),
          Container(
            height: 70.h,
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                Text(
                  new DateFormat("yyyy-MM-dd")
                      .format(this._currentUser?.birthday ?? DateTime.now()),
                  style: TextStyle(
                    color: AppColor.thirdElementText,
                    fontSize: 20.sp,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.thirdElementText,
                  ),
                  onPressed: () {
                    showPickerDate(
                        context: context,
                        scaffoldState: _scaffoldKey.currentState!,
                        selected: this._currentUser?.birthday,
                        onConfirm: (picker, selected) {
                          setState(() {
                            this._currentUser!.birthday =
                                DateFormat("yyyy-MM-dd")
                                    .parse(picker.adapter.text);
                          });
                        });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构造性别配置项.
  Widget _buildGenderConfig() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, bottom: 20.h, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "*",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                ),
              ),
              Text(
                "性别",
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ],
          ),
          Container(
            height: 70.h,
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                Text(
                  null != _currentUser?.gender
                      ? _genderTextEnumMap.entries
                          .firstWhere(
                              (element) => element.key == _currentUser!.gender)
                          .value
                      : "未知",
                  style: TextStyle(
                    color: AppColor.thirdElementText,
                    fontSize: 20.sp,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.thirdElementText,
                  ),
                  onPressed: () {
                    showPicker(
                        context: context,
                        scaffoldState: _scaffoldKey.currentState!,
                        data: jsonEncode(List.of(_genderTextEnumMap.values)),
                        selected: null != _currentUser?.gender
                            ? [
                                List.of(_genderTextEnumMap.keys)
                                    .indexOf(_currentUser!.gender)
                              ]
                            : [],
                        onConfirm: (pick, selected) {
                          setState(() {
                            this._currentUser!.gender = List.of(
                                this._genderTextEnumMap.keys)[selected[0]];
                          });
                        });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameConfig() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, bottom: 20.h, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "*",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30.sp,
                ),
              ),
              Text(
                "姓名",
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ],
          ),

          ///姓名输入框.
          getInputField(
            controller: _nameController,
            width: 250.w,
            height: 70.h,
            keyboardType: TextInputType.text,
            hintText: "10个以内的中英文数字或下划线",
            textInputFormatters: [
              FilteringTextInputFormatter.allow(
                /// 只允许中文，英文，数字，下划线.
                RegExp("^[\u4e00-\u9fa5_a-zA-Z0-9\\s]+\$"),
              )
            ],
            maxLength: 10,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: 1,
            isValid: _nameInputValid,
          ),
        ],
      ),
    );
  }

  ///////////////////事件处理////////////////////
  _handleSaveUserProfile() async {
    String name = this._nameController.value.text;

    /// 验证姓名输入.
    if (name.trim().isEmpty) {
      setState(() {
        this._nameInputValid = false;
      });
      showNotification(
        type: NotificationType.ERROR,
        message: "姓名不能为空",
      );
      return;
    } else {
      setState(() {
        this._nameInputValid = true;
      });
    }

    _currentUser!.name = name;

    /// 保存用户以及其他默认配置到本地数据库.
    CancelFunc cancelFunc = showLoading();
    if (null == widget.userId) {
      /// 如果是初始化，或者创建新用户.
      await ConfigService().saveInitConfig(_currentUser!);

      /// 切换用户.
      Provider.of<UserSwitchState>(context, listen: false)
          .switchCurrentUserTo(_currentUser);

    } else {
      await UserService().save(_currentUser!);
    }

    showNotification(type: NotificationType.SUCCESS, message: "保存成功");
    cancelFunc();

    /// 页面跳转到药物设置页面.
    if (widget.init) {
      /// 跳转到药物设置页面.
      context.pushRoute(MedicineSettingRoute(
        init: true,
      ));
    } else {
      context.popRoute();
    }
  }
}
