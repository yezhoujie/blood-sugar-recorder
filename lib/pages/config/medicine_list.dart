import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/datasource/datasource.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// 药物设置列表页面.
class MedicineListPage extends StatefulWidget {
  MedicineListPage({Key? key}) : super(key: key);

  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  List<UserMedicineConfig> medicineList = [];

  /// 当前用户.
  User _currentUser = Global.currentUser!;

  @override
  void initState() {
    super.initState();
    // 获取当前用户的药物列表.
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    AutoRouter.of(context);

    // UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);
    //
    // _reloadData();

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: Text(
        "药物列表",
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

  /// 构建药物列表.
  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xf5f5f7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildMedicineList(),
      ),
    );
  }

  List<Widget> _buildMedicineList() {
    return [
      Padding(padding: EdgeInsets.only(top: 10.h)),
      Text(
        '胰岛素',
        style: TextStyle(
          color: AppColor.thirdElementText,
          fontSize: 20.sp,
        ),
      ),
      Card(
        color: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 200.h,
            maxHeight: 200.h,
          ),
          child: _buildMedicineItems(MedicineType.INS),
        ),
      ),
      Text(
        '口服药物',
        style: TextStyle(
          color: AppColor.thirdElementText,
          fontSize: 20.sp,
        ),
      ),
      Card(
        color: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 200.h,
            maxHeight: 200.h,
          ),
          child: _buildMedicineItems(MedicineType.PILL),
        ),
      ),
      SizedBox(
        height: 150.h,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: seFlatButton(
            onPressed: () {
              /// 跳转到新建药物页面.
              AutoRouter.of(context).push(MedicineSettingRoute(init: false));
            },
            title: "添加药物",
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

  Widget _buildMedicineItems(MedicineType medicineType) {
    List<UserMedicineConfig> targetList = this
        .medicineList
        .where((element) => element.type == medicineType)
        .toList();
    return targetList.isEmpty
        ? Align(
            alignment: Alignment.center,
            child: Text(
              "还没有设置的${medicineType == MedicineType.INS ? "胰岛素" : "口服药物"}",
              style: TextStyle(
                color: AppColor.thirdElementText,
                fontSize: 20.sp,
              ),
            ),
          )
        : ListView(
            children: ListTile.divideTiles(
                context: context,
                tiles: targetList.map(
                  (e) => ListTile(
                    leading: Container(
                      margin: EdgeInsets.only(top: 5.h),
                      width: 25.w,
                      height: 25.w,
                      color: Color(int.parse(e.color, radix: 16)),
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
                          }
                        ];
                        return operationList
                            .map((e) => PopupMenuItem(
                                  child: Row(
                                    children: [
                                      e["icon"] as Widget,
                                      Padding(
                                          padding:
                                              EdgeInsets.only(right: 10.w)),
                                      Text(
                                        e["title"].toString(),
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  value: e['key'].toString(),
                                ))
                            .toList();
                      },
                      onSelected: (value) async {
                        if (value == "edit") {
                          context.pushRoute(
                              MedicineSettingRoute(init: false, id: e.id));
                        } else {
                          _handleDelete(e);
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
    List<UserMedicineConfig> mediList =
        await MedicineService().findByUserId(Global.currentUser!.id!);
    this.medicineList = mediList;
    if (mounted) {
      setState(() {});
    }
  }

  // /// 切换用户后，重新拉取数据.
  // _reloadData() async {
  //   if (this._currentUser.id != Global.currentUser!.id) {
  //     /// 切换当前用户.
  //     this._currentUser = Global.currentUser!;
  //
  //     /// 重新获取用户的药物列表.
  //     List<UserMedicineConfig> mediList =
  //         await MedicineService().findByUserId(Global.currentUser!.id!);
  //     this.medicineList = mediList;
  //   }
  // }

  void _handleDelete(UserMedicineConfig e) async {
    // 删除提示框.
    OkCancelResult res = await showOkCancelAlertDialog(
      context: this.context,
      title: "确定要删除吗？",
      okLabel: "确定",
      cancelLabel: "取消",
      barrierDismissible: false,
    );

    if (res.index == OkCancelResult.ok.index) {
      await MedicineService().deleteById(e.id!);
      showNotification(type: NotificationType.SUCCESS, message: "删除成功");

      /// 刷新页面.
      AutoRouter.of(context).popAndPush(MedicineListRoute());
    }
  }
}
