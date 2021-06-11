import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/record/blood_sugar_record.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

///创建、修改血糖记录页面.

class BloodSugarRecordPage extends StatefulWidget {
  /// 当前的血糖记录信息.
  final BloodSugarRecordItem? bloodSugarRecordItem;

  /// 点击按钮是否自动后台保存.
  final bool autoSave;

  /// 是否返回在pop页面时返回保存后的数据.
  final bool returnWithPop;

  const BloodSugarRecordPage({
    Key? key,
    this.bloodSugarRecordItem,
    required this.autoSave,
    required this.returnWithPop,
  }) : super(key: key);

  @override
  _BloodSugarRecordPageState createState() => _BloodSugarRecordPageState();
}

class _BloodSugarRecordPageState extends State<BloodSugarRecordPage> {
  late BloodSugarRecordItem _bloodSugarRecordItem;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 血糖数值输入框控制器.
  TextEditingController _bloodSugarController = TextEditingController();

  /// 血糖数值输入框验证器.
  bool _bloodSugarInputValid = true;

  @override
  void initState() {
    super.initState();

    /// 初始化药物记录信息.
    _bloodSugarRecordItem = widget.bloodSugarRecordItem ??
        BloodSugarRecordItem(
          userId: Global.currentUser!.id!,
          recordTime: DateTime.now(),
          fpg: false,
        );

    if (null != widget.bloodSugarRecordItem) {
      this._bloodSugarController.text =
          widget.bloodSugarRecordItem!.bloodSugar.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 25.h),
        width: double.infinity,
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: <Widget>[
              ///记录时间.
              _buildRecordTime(),

              ///血糖数值输入
              _buildBloodSugar(),

              /// 是否为空腹.
              _buildFpg(),
              //
              //
              ///按钮区域.
              _buildButtons(),
            ],
          ).toList(),
        ),
      ),
    );
  }

  ////////////UI构建区///////////////////
  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: Text(
        "血糖测量记录",
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
              .pushAndPopUntil(MainRoute(tabIndex: 0), predicate: (_) => false);
        },
      ),
    );
  }

  _buildRecordTime() {
    return ListTile(
      title: getMainText(
        value: "测量时间",
        fontSize: 25.sp,
      ),
      trailing: SizedBox(
        width: 213.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              new DateFormat("yyyy-MM-dd HH:mm")
                  .format(this._bloodSugarRecordItem.recordTime),
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
                showPickerDateTime(
                    endDate: DateTime.now(),
                    context: context,
                    scaffoldState: _scaffoldKey.currentState!,
                    selected: this._bloodSugarRecordItem.recordTime,
                    onConfirm: (picker, selected) {
                      setState(() {
                        this._bloodSugarRecordItem.recordTime =
                            DateFormat("yyyy-MM-dd HH:mm")
                                .parse(picker.adapter.text);
                      });
                    });
              },
            ),
          ],
        ),
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

  Widget _buildBloodSugar() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 5.h, bottom: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "血糖测量值",
            style: TextStyle(
              fontSize: 25.sp,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///药物使用剂量输入框.
              getInputField(
                controller: this._bloodSugarController,
                width: 80.w,
                height: 60.h,
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
                isValid: this._bloodSugarInputValid,
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.w),
              ),
              Text(
                "mmol/L",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: AppColor.thirdElementText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFpg() {
    /// 构建药物类型选择器.
    return ListTile(
      title: getMainText(
        value: "是否空腹",
        fontSize: 25.sp,
      ),
      trailing: Transform.scale(
        scale: 1.8,
        child: Switch(
          value: this._bloodSugarRecordItem.fpg!,
          onChanged: (bool value) {
            setState(() {
              this._bloodSugarRecordItem.fpg = value;
            });
          },
        ),
      ),
    );
  }

  _buildButtons() {
    return SizedBox(
      height: 370.h,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: seFlatButton(
          onPressed: () {
            _handleSave();
          },
          title: "完成",
          width: 300.w,
          height: 70.h,
          fontSize: 25.sp,
          bgColor: Colors.redAccent,
          fontColor: Colors.black54,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  /////////事件处理区域///////////////
  /// 处理完成药物使用记录,保存操作.
  void _handleSave() async {
    /// 整合、验证数据.
    String bloodSugar = this._bloodSugarController.value.text;

    /// 验证姓名输入.
    if (bloodSugar.trim().isEmpty) {
      setState(() {
        this._bloodSugarInputValid = false;
      });
      showNotification(type: NotificationType.ERROR, message: "血糖值不能为空");
      return;
    }

    if (bloodSugar.length > 5) {
      setState(() {
        this._bloodSugarInputValid = false;
      });
      showNotification(type: NotificationType.ERROR, message: "血糖值输入不正确");
      return;
    }

    CancelFunc cancelFunc = showLoading();

    this._bloodSugarRecordItem.bloodSugar = double.parse(bloodSugar);

    if (widget.autoSave) {
      /// 保存数据到数据库.
      try {
        await BloodSugarRecordService().save(this._bloodSugarRecordItem);

        /// 显示提示.
        showNotification(
          type: NotificationType.SUCCESS,
          message: "保存成功",
        );
      } catch (errorData) {
        showNotification(
          type: NotificationType.ERROR,
          message: (errorData as ErrorData).message,
        );
      }
    } else {
      /// todo 将保存的数据传给上层页面.
    }

    cancelFunc();

    /// 返回到列表页面.
    AutoRouter.of(context)
        .pushAndPopUntil(MainRoute(tabIndex: 0), predicate: (_) => false);
  }
}
