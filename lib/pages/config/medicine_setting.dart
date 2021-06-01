import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/constant/error.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 用户药物设置页面.
class MedicineSettingPage extends StatefulWidget {
  /// 当前药物ID.
  final int? id;

  MedicineSettingPage({Key? key, this.id}) : super(key: key);

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
          children: ListTile.divideTiles(context: context, tiles: [
            Padding(
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
            ),
            ListTile(
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
                            .firstWhere(
                                (element) => element.key == _currentConfig.type)
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
                              data: jsonEncode(
                                  List.of(_medicineTypeEnumMap.values)),
                              selected: [
                                List.of(_medicineTypeEnumMap.keys)
                                    .indexOf(_currentConfig.type)
                              ],
                              onConfirm: (pick, selected) {
                                setState(() {
                                  this._currentConfig.type =
                                      List.of(this._medicineTypeEnumMap.keys)[
                                          selected[0]];
                                });
                              });
                        },
                      ),
                    ],
                  ),
                )),
            ListTile(
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
                                _currentConfig.color = selectedColor.value.toRadixString(16);
                              });
                            });
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('Sheep'),
            ),
            ListTile(
              title: Text('Goat'),
            ),
          ]).toList(),
        ),
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
    this._nameController..text = this._currentConfig.name;

    if (mounted) {
      setState(() {});
    }
  }
}
