import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/constant/error.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 用户药物设置页面.
class MedicineSettingPage extends StatefulWidget {
  /// 当前药物ID.
  final int? id;

  final bool init;

  MedicineSettingPage({
    Key? key,
    this.id,
    required this.init,
  }) : super(key: key);

  @override
  _MedicineSettingPageState createState() => _MedicineSettingPageState();
}

class _MedicineSettingPageState extends State<MedicineSettingPage> {
  /// 性别枚举对应显示文字Map.
  final Map<MedicineType, String> _medicineTypeEnumMap = {
    MedicineType.INS: '胰岛素',
    MedicineType.PILL: '口服药物',
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _nameController = TextEditingController();

  TextEditingController _unitController = TextEditingController();

  bool _nameInputValid = true;

  late UserMedicineConfig _currentConfig;

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
              /// 药物名称.
              _buildNameInput(),

              /// 药物类型.
              _buildMediTypePicker(),

              /// 颜色标记.
              _buildColorPicker(),

              /// 药物使用单位
              _buildUnitField(),

              ///按钮区域.
              _buildButtons(),
            ],
          ).toList(),
        ),
      ),
    );
  }

  /// 构建药物名称输入框.
  Widget _buildNameInput() {
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
                "名称",
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ],
          ),

          ///药物名称输入框.
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

  /// 构建药物类型选择器.
  Widget _buildMediTypePicker() {
    return ListTile(
      title: getMainText(value: "药物类型"),
      trailing: SizedBox(
        width: 120.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            getMainText(
              value: this
                  ._medicineTypeEnumMap
                  .entries
                  .firstWhere((element) => element.key == _currentConfig.type)
                  .value,
              color: AppColor.thirdElementText,
              fontSize: 20.sp,
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
                    data: jsonEncode(List.of(_medicineTypeEnumMap.values)),
                    selected: [
                      List.of(_medicineTypeEnumMap.keys)
                          .indexOf(_currentConfig.type)
                    ],
                    onConfirm: (pick, selected) {
                      setState(() {
                        this._currentConfig.type = List.of(
                            this._medicineTypeEnumMap.keys)[selected[0]];
                      });
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建颜色选择器.
  Widget _buildColorPicker() {
    return ListTile(
      title: getMainText(value: "颜色标记"),
      trailing: SizedBox(
        width: 120.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              color: Color(int.parse(_currentConfig.color, radix: 16)),
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: AppColor.thirdElementText,
              ),
              onPressed: () {
                ColorPicker.showColorPicker(
                    context: context,
                    selectedColor:
                        Color(int.parse(_currentConfig.color, radix: 16)),
                    onConfirm: (Color selectedColor) {
                      setState(() {
                        _currentConfig.color =
                            selectedColor.value.toRadixString(16);
                      });
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建药物单位输入框.
  Widget _buildUnitField() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "使用单位",
            style: TextStyle(
              fontSize: 30.sp,
            ),
          ),

          ///药物使用单位输入框.
          getAutoCompleteInputField(
            controller: _unitController,
            width: 150.w,
            height: 70.h,
            keyboardType: TextInputType.text,
            hintText: "8个以内的中英文数字或下划线",
            maxLength: 8,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            maxLines: 1,
            isValid: true,
            optionsBuilder: (textEditingValue) {
              return ['单位', '片'];
            },
            displayStringForOption: (Object option) {
              return option.toString();
            },
            onSelected: (selected) {
              _unitController..text = selected as String;
            },
          ),
        ],
      ),
    );
  }

  /// 构建按钮区域.
  Widget _buildButtons() {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      height: 380.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 保存并继续添加.
          seFlatButton(
            onPressed: () async {
              /// 保存数据.
              bool success = await _handleSaveConfig();

              /// 刷新页面.
              if (success) {
                String newName =
                    "${_currentConfig.name}${_currentConfig.id! + 1}";
                UserMedicineConfig newConfig =
                    UserMedicineConfig.byDefault(_currentConfig.userId);
                newConfig.name = newName;
                setState(() {
                  _currentConfig = newConfig;
                  _nameController..text = _currentConfig.name;
                  _unitController..text = _currentConfig.unit ?? "";
                });
              }
            },
            title: "保存并继续添加",
            width: 300.w,
            height: 70.h,
            fontSize: 25.sp,
            bgColor: Colors.greenAccent,
            fontColor: Colors.black54,
            fontWeight: FontWeight.w900,
          ),

          /// 完成设置.
          seFlatButton(
            onPressed: () async {
              /// 保存数据
              bool success = await _handleSaveConfig();
              if (success) {
                context.pushRoute(BloodSugarSettingRoute(
                  init: true,
                ));
              }
            },
            title: "完成",
            width: 300.w,
            height: 70.h,
            fontSize: 25.sp,
            bgColor: Colors.amber,
            fontColor: Colors.black54,
            fontWeight: FontWeight.w900,
          ),

          /// 跳过设置.
          widget.init
              ? seFlatButton(
                  onPressed: () async {
                    context.pushRoute(BloodSugarSettingRoute(
                      init: true,
                    ));
                  },
                  title: "不需要药物干预，跳过",
                  width: 300.w,
                  height: 70.h,
                  fontSize: 25.sp,
                  bgColor: Colors.redAccent,
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w900,
                )
              : Container(
                  height: 70.h,
                ),
        ],
      ),
    );
  }

  /// 头部导航栏.
  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: Text(
        "药物设置",
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
    if (null == widget.id) {
      /// 新增
      _currentConfig = UserMedicineConfig.byDefault(Global.currentUser!.id!);
    } else {
      /// 从数据库获取配置项.
      try {
        _currentConfig = await MedicineService().getById(widget.id!);
      } catch (errorData) {
        showNotification(
            type: NotificationType.ERROR,
            message: errorData is ErrorData
                ? errorData.message
                : DEFAULT_ERROR_MESSAGE);
      }
    }

    /// 设置输入框药物名称
    this._nameController.text = this._currentConfig.name;

    /// 设置输入框药物使用单位
    this._unitController.text = this._currentConfig.unit ?? "";

    if (mounted) {
      setState(() {});
    }
  }

  ///////////////////事件处理////////////////////
  Future<bool> _handleSaveConfig() async {
    String name = this._nameController.value.text;

    /// 验证姓名输入.
    if (name.trim().isEmpty) {
      setState(() {
        this._nameInputValid = false;
      });
      showNotification(type: NotificationType.ERROR, message: "名称不能为空");
      return false;
    }

    if (name.length > 10) {
      showNotification(type: NotificationType.ERROR, message: "名称不能超过10个字符");
      return false;
    }

    setState(() {
      this._nameInputValid = true;
    });

    /// 保存用户以及其他默认配置到本地数据库.
    CancelFunc cancelFunc = showLoading();

    _currentConfig.name = name;
    String unit = _unitController.value.text.trim();
    if (unit.isNotEmpty) {
      _currentConfig.unit = unit;
    }
    await MedicineService().save(_currentConfig);

    cancelFunc();

    /// 显示提示.
    showNotification(
      type: NotificationType.SUCCESS,
      message: "保存成功",
    );
    return true;
  }
}
