import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/record/food_record.dart';
import 'package:blood_sugar_recorder/utils/alarm_clock.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// 创建或编辑用餐记录页面.
/// [foodRecordItem] 编辑时传入的被编辑数据对象.
/// [autoSave] 点击保存按钮是否自动保存后台.
class FoodRecordPage extends StatefulWidget {
  /// 当前的进食记录信息.
  final FoodRecordItem? foodRecordItem;

  /// 点击按钮是否自动后台保存.
  final bool autoSave;

  const FoodRecordPage({
    Key? key,
    this.foodRecordItem,
    required this.autoSave,
  }) : super(key: key);

  @override
  _FoodRecordPageState createState() => _FoodRecordPageState();
}

class _FoodRecordPageState extends State<FoodRecordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 当前编辑的用餐记录.
  late FoodRecordItem _foodRecordItem;

  /// 食物信息输入控制器
  TextEditingController _foodController = TextEditingController();

  /// 备注信息输入控制器
  TextEditingController _commentController = TextEditingController();

  /// 用餐情况输入校验状态.
  bool _foodInputValid = true;

  /// 用备注况输入校验状态.
  bool _commentInputValid = true;

  @override
  void initState() {
    super.initState();

    /// 初始化药物记录信息.
    this._foodRecordItem = widget.foodRecordItem ??
        FoodRecordItem(
          userId: Global.currentUser!.id!,
          recordTime: DateTime.now(),
        );

    if (null != widget.foodRecordItem) {
      if (null != widget.foodRecordItem!.foodInfo) {
        this._foodController.text = widget.foodRecordItem!.foodInfo!;
      }
      if (null != widget.foodRecordItem!.comment) {
        this._commentController.text = widget.foodRecordItem!.comment!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AutoRouter.of(context);
    return Scaffold(
      key: this._scaffoldKey,
      // resizeToAvoidBottomInset: false,
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

              /// 用餐情况.
              ..._buildFoodInfoInput(),

              /// 备注信息.
              ..._buildCommentInput(),

              /// 是否创建闹钟提醒.
              _buildAlert(),

              ///按钮区域.
              _buildButtons(),
            ],
          ).toList(),
        ),
      ),
    );
  }

  //////// UI构建区域///////////
  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: Text(
        "记录用餐情况",
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

  _buildRecordTime() {
    return ListTile(
      title: getMainText(
        value: "用餐时间",
        fontSize: 25.sp,
      ),
      trailing: SizedBox(
        width: 213.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              new DateFormat("yyyy-MM-dd HH:mm")
                  .format(this._foodRecordItem.recordTime),
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
                    selected: this._foodRecordItem.recordTime,
                    onConfirm: (picker, selected) {
                      setState(() {
                        this._foodRecordItem.recordTime =
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

  _buildButtons() {
    return SizedBox(
      height: 100.h,
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
          bgColor: Colors.green,
          fontColor: Colors.black54,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildAlert() {
    DateTime hour2 = this._foodRecordItem.recordTime.add(Duration(hours: 2));
    if (hour2.isBefore(DateTime.now())) {
      return SizedBox(
        height: 35.h,
      );
    }

    /// 构建药物类型选择器.
    return ListTile(
      title: getMainText(
        value: "创建餐后血糖闹钟",
        fontSize: 25.sp,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.arrow_forward_ios,
          color: AppColor.thirdElementText,
        ),
        onPressed: () {
          createAlarmTimer(
            this._foodRecordItem.recordTime.add(Duration(hours: 2)),
            message: "该测血糖啦",
          );
        },
      ),
    );
  }

  _buildFoodInfoInput() {
    return [
      ListTile(
        title: getMainText(
          value: "用餐情况",
          fontSize: 25.sp,
        ),
      ),
      Container(
        height: 160.h,
        margin: EdgeInsets.only(left: 5.w, right: 5.w),
        child: getInputField(
            keyboardType: TextInputType.text,
            isValid: this._foodInputValid,
            hintText: "记录一下用餐的情况吧",
            controller: this._foodController,
            maxLength: 250,
            maxLines: 5),
      )
    ];
  }

  _buildCommentInput() {
    return [
      ListTile(
        title: getMainText(
          value: "备注信息",
          fontSize: 25.sp,
        ),
      ),
      Container(
        height: 160.h,
        margin: EdgeInsets.only(left: 5.w, right: 5.w),
        child: getInputField(
            keyboardType: TextInputType.text,
            isValid: this._commentInputValid,
            hintText: "写点备注信息吧",
            controller: this._commentController,
            maxLength: 250,
            maxLines: 5),
      )
    ];
  }

  ///////////事件处理区域/////////////////
  void _handleSave() async {
    /// 输入校验.
    if (this._foodController.value.text.length > 250) {
      setState(() {
        this._foodInputValid = false;
      });
      return;
    }

    if (this._commentController.value.text.length > 250) {
      setState(() {
        this._commentInputValid = false;
      });
      return;
    }

    /// 保存数据库.
    CancelFunc cancelFunc = showLoading();

    /// 设置输入值.
    this._foodRecordItem.foodInfo = this._foodController.value.text;
    this._foodRecordItem.comment = this._commentController.value.text;

    if (widget.autoSave) {
      /// 保存数据到数据库.
      try {
        await FoodRecordService().save(this._foodRecordItem);

        /// 显示提示.
        showNotification(
          type: NotificationType.SUCCESS,
          message: "保存成功",
        );
        cancelFunc();

        /// 返回到列表页面.
        AutoRouter.of(context)
            .pushAndPopUntil(MainRoute(tabIndex: 0), predicate: (_) => false);
      } catch (errorData) {
        showNotification(
          type: NotificationType.ERROR,
          message: (errorData as ErrorData).message,
        );
        cancelFunc();
      }
    } else {
      /// todo 将保存的数据传给上层页面.
      cancelFunc();
    }
  }
}
