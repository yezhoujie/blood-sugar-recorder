import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/constant/error.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 血糖指标设置页面.
class BloodSugarSettingPage extends StatefulWidget {
  final bool init;

  const BloodSugarSettingPage({
    Key? key,
    required this.init,
  }) : super(key: key);

  @override
  _BloodSugarSettingPageState createState() => _BloodSugarSettingPageState();
}

class _BloodSugarSettingPageState extends State<BloodSugarSettingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 空腹下限指标输入控制器.
  TextEditingController _fpgMinController = TextEditingController();

  /// 空腹上限指标输入控制器.
  TextEditingController _fpgMaxController = TextEditingController();

  /// 餐后2小时下限指标输入控制器.
  TextEditingController _hpg2MinController = TextEditingController();

  /// 餐后2小时上限指标输入控制器.
  TextEditingController _hpg2MaxController = TextEditingController();

  bool _fpgMinInputValid = true;
  bool _fpgMaxInputValid = true;
  bool _hpg2MinInputValid = true;
  bool _hpg2MaxInputValid = true;

  late UserBloodSugarConfig _currentConfig;

  @override
  void initState() {
    super.initState();
    _loadInitDate();
  }

  @override
  Widget build(BuildContext context) {
    AutoRouter.of(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 25.h),
        width: double.infinity,
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: <Widget>[
              /// 空腹.
              _buildFgpInput(),

              /// 餐后2小时.
              _buildHgpInput(),
              //
              // ///按钮区域.
              _buildButton(),
            ],
          ).toList(),
        ),
      ),
    );
  }

  /// 构建空腹指标输入框.
  Widget _buildFgpInput() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 10.w),
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
                "空腹指标",
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ],
          ),

          ///下限输入框.
          getInputField(
            controller: _fpgMinController,
            width: 80.w,
            height: 70.h,
            keyboardType: TextInputType.number,
            hintText: "",
            textInputFormatters: [
              FilteringTextInputFormatter.allow(
                /// 只允许整数或小数.
                RegExp(r'^\d+(\.)?[0-9]{0,2}'),
              )
            ],
            maxLength: 5,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: 1,
            isValid: _fpgMinInputValid,
          ),
          Text(
            "~",
            style: TextStyle(
              fontSize: 30.sp,
            ),
          ),

          ///上限输入框.
          getInputField(
            controller: _fpgMaxController,
            width: 80.w,
            height: 70.h,
            keyboardType: TextInputType.number,
            hintText: "数字或小数点",
            textInputFormatters: [
              FilteringTextInputFormatter.allow(
                /// 只允许整数或小数.
                RegExp(r'^\d+(\.)?[0-9]{0,2}'),
              )
            ],
            maxLength: 4,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: 1,
            isValid: _fpgMaxInputValid,
          ),
        ],
      ),
    );
  }

  /// 构建餐后2小时血糖指标输入区域.
  Widget _buildHgpInput() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 10.w),
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
                "餐后指标",
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ],
          ),

          ///下限输入框.
          getInputField(
            controller: _hpg2MinController,
            width: 80.w,
            height: 70.h,
            keyboardType: TextInputType.number,
            hintText: "",
            textInputFormatters: [
              FilteringTextInputFormatter.allow(
                /// 只允许整数或小数.
                RegExp(r'^\d+(\.)?[0-9]{0,2}'),
              )
            ],
            maxLength: 5,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: 1,
            isValid: _hpg2MinInputValid,
          ),
          Text(
            "~",
            style: TextStyle(
              fontSize: 30.sp,
            ),
          ),

          ///上限输入框.
          getInputField(
            controller: _hpg2MaxController,
            width: 80.w,
            height: 70.h,
            keyboardType: TextInputType.number,
            hintText: "数字或小数点",
            textInputFormatters: [
              FilteringTextInputFormatter.allow(
                /// 只允许整数或小数.
                RegExp(r'^\d+(\.)?[0-9]{0,2}'),
              )
            ],
            maxLength: 4,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: 1,
            isValid: _hpg2MaxInputValid,
          ),
        ],
      ),
    );
  }

  /// 构建按钮区域.
  Widget _buildButton() {
    return Container(
      height: 450.h,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: seFlatButton(
          onPressed: () {
            /// 保存配置，跳转到完成页面.
            _handleSave();
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

  /// 头部导航栏.
  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: Text(
        "血糖指标设置",
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
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5.h, right: 5.w),
          child: GestureDetector(
            onTapDown: (details) {
              showTooltip(
                target: details.globalPosition,
                content:
                    '''一般的血糖指标为：\n空腹：3.92～6.16mmol/L\n餐后：5.1~7.0mmol/L\n指标设置请遵医嘱''',
              );
            },
            child: Icon(
              Icons.info_outline,
              size: 35.sp,
              color: Colors.amber,
            ),
          ),
        ),
      ],
    );
  }

  Widget getMainText({
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

  /// 装载初始化数据.
  void _loadInitDate() async {
    try {
      _currentConfig =
          await BloodSugarConfigService().getByUserId(Global.currentUser!.id!);
    } catch (errorData) {
      showNotification(
          type: NotificationType.ERROR,
          message: errorData is ErrorData
              ? errorData.message
              : DEFAULT_ERROR_MESSAGE);
    }

    /// 设置空腹血糖下限
    this._fpgMinController..text = "${this._currentConfig.fpgMin}";

    /// 设置空腹血糖上限
    this._fpgMaxController..text = "${this._currentConfig.fpgMax}";

    /// 设置餐后2小时血糖下限
    this._hpg2MinController..text = "${this._currentConfig.hpg2Min}";

    /// 设置餐后2小时血糖上限
    this._hpg2MaxController..text = "${this._currentConfig.hpg2Max}";

    if (mounted) {
      setState(() {});
    }
  }

///////////////////事件处理////////////////////
  Future<bool> _handleSave() async {
    double fpgMin;
    try {
      fpgMin = double.parse(this._fpgMinController.value.text);
      setState(() {
        this._fpgMinInputValid = true;
      });
    } catch (exception) {
      setState(() {
        this._fpgMinInputValid = false;
      });
      showNotification(type: NotificationType.ERROR, message: "请输入正确的指标值");
      return false;
    }

    double fpgMax;
    try {
      fpgMax = double.parse(this._fpgMaxController.value.text);
      setState(() {
        this._fpgMaxInputValid = true;
      });
    } catch (exception) {
      setState(() {
        this._fpgMaxInputValid = false;
      });
      showNotification(type: NotificationType.ERROR, message: "请输入正确的指标值");
      return false;
    }

    double hpg2Min;
    try {
      hpg2Min = double.parse(this._hpg2MinController.value.text);
      setState(() {
        this._hpg2MinInputValid = true;
      });
    } catch (exception) {
      setState(() {
        this._hpg2MinInputValid = false;
      });
      showNotification(type: NotificationType.ERROR, message: "请输入正确的指标值");
      return false;
    }

    double hpg2Max;
    try {
      hpg2Max = double.parse(this._hpg2MaxController.value.text);
      setState(() {
        this._hpg2MaxInputValid = true;
      });
    } catch (exception) {
      setState(() {
        this._hpg2MaxInputValid = false;
      });
      showNotification(type: NotificationType.ERROR, message: "请输入正确的指标值");
      return false;
    }

    /// 验证姓名输入.
    UserBloodSugarConfig config = UserBloodSugarConfig(
        userId: this._currentConfig.userId,
        fpgMin: fpgMin,
        fpgMax: fpgMax,
        hpg2Min: hpg2Min,
        hpg2Max: hpg2Max);

    setState(() {
      this._currentConfig = config;
    });

    /// 保存用户以及其他默认配置到本地数据库.
    CancelFunc cancelFunc = showLoading();

    await BloodSugarConfigService().save(_currentConfig);

    cancelFunc();

    /// 显示提示.
    showNotification(
      type: NotificationType.SUCCESS,
      message: "保存成功",
    );

    if (widget.init) {
      /// 跳转到配置完成页面
    } else {
      context.popRoute();
    }
    return true;
  }
}
