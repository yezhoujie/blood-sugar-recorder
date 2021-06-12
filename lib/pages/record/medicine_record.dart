import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/error/error_data.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/record/medicine_record.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// 创建药物使用记录页面.
/// [medicineRecordItem] 编辑时传入的被编辑数据对象.
/// [autoSave] 点击保存按钮是否自动保存后台.
class MedicineRecordPage extends StatefulWidget {
  /// 当前的药物使用记录信息.
  final MedicineRecordItem? medicineRecordItem;

  /// 新增记录时的所属周期ID.
  final int? cycleId;

  /// 点击按钮是否自动后台保存.
  final bool autoSave;

  MedicineRecordPage({
    Key? key,
    this.medicineRecordItem,
    this.cycleId,
    required this.autoSave,
  }) : super(key: key);

  @override
  _MedicineRecordPageState createState() => _MedicineRecordPageState();
}

class _MedicineRecordPageState extends State<MedicineRecordPage> {
  late MedicineRecordItem _medicineRecordItem;

  List<UserMedicineConfig> _medicineList = [];

  final Map<MedicineType, String> _medicineTypeEnumMap = {
    MedicineType.INS: '胰岛素',
    MedicineType.PILL: '口服药物',
  };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usageController = TextEditingController();

  bool _usageInputValid = true;

  CancelFunc? _cancelLoading;

  @override
  Widget build(BuildContext context) {
    AutoRouter.of(context);
    return this._medicineList.isEmpty ? _buildLoading() : _buildPage();
  }

  @override
  void initState() {
    super.initState();

    /// 初始化药物记录信息.
    _medicineRecordItem = widget.medicineRecordItem ??
        MedicineRecordItem(
          userId: Global.currentUser!.id!,
          recordTime: DateTime.now(),
          cycleRecordId: widget.cycleId,
        );

    if (null != widget.medicineRecordItem) {
      this._usageController.text = widget.medicineRecordItem!.usage.toString();
    }

    /// 获取用户配置的药物列表.
    _loadMedicineList();
  }

  ////////////widget构建区域//////////
  _buildLoading() {
    this._cancelLoading = showLoading();
    return Container();
  }

  @override
  void dispose() {
    this._usageController.dispose();
    if (null != this._cancelLoading) {
      this._cancelLoading!();
      this._cancelLoading = null;
    }
    super.dispose();
  }

  _buildPage() {
    if (null != this._cancelLoading) {
      this._cancelLoading!();
      this._cancelLoading = null;
    }
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
              /// 药物类型.
              _buildMediType(),

              /// 药物选择.
              _buildMedicinePicker(),

              /// 药物使用单位
              _buildUsage(),

              /// 是否为补充使用.
              _buildExtra(),

              ///记录时间.
              _buildRecordTime(),

              ///按钮区域.
              _buildButtons(),
            ],
          ).toList(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: Text(
        "记录药物使用",
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

  /// 构建药物类型选择器.
  Widget _buildMediType() {
    return ListTile(
      title: getMainText(
        value: "药物类型",
        fontSize: 25.sp,
      ),
      trailing: SizedBox(
        width: 120.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            getMainText(
              value: this
                  ._medicineTypeEnumMap
                  .entries
                  .firstWhere((element) =>
                      element.key ==
                      (this
                          ._medicineList
                          .where((element) =>
                              element.id == this._medicineRecordItem.medicineId)
                          .first
                          .type))
                  .value,
              color: AppColor.thirdElementText,
              fontSize: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建药物选择器.
  Widget _buildMedicinePicker() {
    return ListTile(
      title: getMainText(
        value: "使用药物",
        fontSize: 25.sp,
      ),
      trailing: SizedBox(
        width: 220.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5.h),
              width: 25.w,
              height: 25.w,
              color: Color(int.parse(
                  this
                      ._medicineList
                      .where((element) =>
                          element.id == this._medicineRecordItem.medicineId)
                      .first
                      .color,
                  radix: 16)),
            ),
            Padding(
                padding: EdgeInsets.only(
              right: 5.w,
            )),
            getMainText(
              value: this
                  ._medicineList
                  .where((element) =>
                      element.id == this._medicineRecordItem.medicineId)
                  .first
                  .name,
              color: AppColor.thirdElementText,
              fontSize: 18.sp,
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: AppColor.thirdElementText,
              ),
              onPressed: () {
                showCustomPicker(
                    context: context,
                    scaffoldState: this._scaffoldKey.currentState!,
                    dataList: this._buildMedicinePickerData(),
                    columnFlex: const [3, 7],
                    onConfirm: (pick, selected) {
                      int medicineId = pick.getSelectedValues()[1];
                      setState(() {
                        this._medicineRecordItem.medicineId = medicineId;
                      });
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsage() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 5.h, bottom: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "使用剂量",
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
                controller: this._usageController,
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
                isValid: this._usageInputValid,
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.w),
              ),
              Text(
                this
                        ._medicineList
                        .where((element) =>
                            element.id == this._medicineRecordItem.medicineId!)
                        .first
                        .unit ??
                    "",
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

  Widget _buildExtra() {
    /// 构建药物类型选择器.
    return ListTile(
      title: getMainText(
        value: "是否为额外补充",
        fontSize: 25.sp,
      ),
      trailing: Transform.scale(
        scale: 1.8,
        child: Switch(
          value: this._medicineRecordItem.extra,
          onChanged: (bool value) {
            setState(() {
              this._medicineRecordItem.extra = value;
            });
          },
        ),
      ),
    );
  }

  _buildButtons() {
    return SizedBox(
      height: 350.h,
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
          bgColor: Colors.amber,
          fontColor: Colors.black54,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  _buildRecordTime() {
    return ListTile(
      title: getMainText(
        value: "使用时间",
        fontSize: 25.sp,
      ),
      trailing: SizedBox(
        width: 212.w,
        child: Row(
          children: [
            Text(
              new DateFormat("yyyy-MM-dd HH:mm")
                  .format(this._medicineRecordItem.recordTime),
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
                    context: context,
                    scaffoldState: _scaffoldKey.currentState!,
                    selected: this._medicineRecordItem.recordTime,
                    onConfirm: (picker, selected) {
                      setState(() {
                        this._medicineRecordItem.recordTime =
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

  ////////////事件处理区域/////////////
  /// 获取用户配置的药物信息.
  _loadMedicineList() async {
    CancelFunc cancel = showLoading();

    /// 数据库获取药物列表.
    List<UserMedicineConfig> medicineList =
        await MedicineService().findByUserId(Global.currentUser!.id!);

    this._medicineList = medicineList;
    if (null == widget.medicineRecordItem) {
      /// 如果是新增记录，设置默认值.
      this._medicineRecordItem = MedicineRecordItem(
          userId: Global.currentUser!.id!,
          recordTime: DateTime.now(),
          medicineId: medicineList.first.id);
    }

    if (mounted) {
      setState(() {});
    }
    cancel();
  }

  _buildMedicinePickerData() {
    Set<MedicineType> pickerDataSet =
        this._medicineList.map((medicine) => medicine.type).toSet();

    List<PickerItem> pickerDataList = pickerDataSet
        .map((type) => PickerItem(
            value: this
                ._medicineTypeEnumMap
                .entries
                .where((element) => element.key == type)
                .first
                .value,
            children: []))
        .toList();

    pickerDataList = pickerDataList
        .map((typeData) => PickerItem(
            text: typeData.text,
            value: typeData.value,
            children: this
                ._medicineList
                .where((medicine) =>
                    this
                        ._medicineTypeEnumMap
                        .entries
                        .where((entry) => entry.key == medicine.type)
                        .first
                        .value ==
                    typeData.value)
                .map((medicine) => PickerItem(
                      text: Container(
                        width: 200.w,
                        child: Row(
                          children: [
                            Container(
                              width: 25.w,
                              height: 25.w,
                              color:
                                  Color(int.parse(medicine.color, radix: 16)),
                            ),
                            Padding(padding: EdgeInsets.only(right: 5.w)),
                            Text(
                              medicine.name,
                            )
                          ],
                        ),
                      ),
                      value: medicine.id,
                    ))
                .toList()))
        .toList();

    return pickerDataList;
  }

  /// 处理完成药物使用记录,保存操作.
  void _handleSave() async {
    /// 整合、验证数据.
    String usage = this._usageController.value.text;

    /// 验证姓名输入.
    if (usage.trim().isEmpty) {
      setState(() {
        this._usageInputValid = false;
      });
      showNotification(type: NotificationType.ERROR, message: "使用剂量不能为空");
      return;
    }

    CancelFunc cancelFunc = showLoading();

    this._medicineRecordItem.usage = double.parse(usage);

    if (widget.autoSave) {
      /// 保存数据到数据库.
      try {
        await MedicineRecordService().save(this._medicineRecordItem);

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
