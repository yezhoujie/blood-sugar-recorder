import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/pages/record/record_item_widget.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/service/record/cycle_record.dart';
import 'package:blood_sugar_recorder/service/service.dart';
import 'package:blood_sugar_recorder/utils/picker.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:share/share.dart';

/// 历史周期记录页面.
class HistoryPage extends StatefulWidget {
  final HistoryFilterConfig? filterConfig;

  HistoryPage({Key? key, this.filterConfig}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  /// 当前用户.
  User _currentUser = Global.currentUser!;

  /// 总过滤菜单标题列表.
  List<String> _dropDownHeaderItemStrings = [];

  HistoryFilterConfig _filterConfig = HistoryFilterConfig.byDefault();

  ///下拉过滤器控制器.
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey _stackKey = GlobalKey();

  /// 给整个ListView设置Rect信息获取能力
  var listViewKey = RectGetter.createGlobalKey();

  /// 每个周期的key.
  var _keys = {};

  /// 周期列表数据.
  List<CycleRecord> _cycleList = [];

  /// 血糖标准.
  late UserBloodSugarConfig _standard;

  ScrollController scrollController = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();

    /// 设置默认过滤条件.
    this._filterConfig = widget.filterConfig ?? HistoryFilterConfig.byDefault();

    /// 构建过滤菜单列表.
    this._buildFilterMenuTitles();

    _initCycles();
  }

  @override
  Widget build(BuildContext context) {
    /// 注册监听
    UserSwitchState userSwitchState = Provider.of<UserSwitchState>(context);

    /// 切换用户时刷新数据.
    this._dataRefresh();
    return Scaffold(
      key: this._scaffoldKey,
      // GZXDropDownMenu目前只能在Stack内，后续有时间会改进，以及支持CustomScrollView和NestedScrollView
      body: Stack(
        key: _stackKey,
        children: <Widget>[
          Column(
            children: <Widget>[
              // 下拉菜单头部
              GZXDropDownHeader(
                // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
                items: [
                  GZXDropDownHeaderItem(
                    _dropDownHeaderItemStrings[0],
                    iconData: Icons.keyboard_arrow_down,
                    iconDropDownData: Icons.keyboard_arrow_up,
                  ),
                  GZXDropDownHeaderItem(
                    _dropDownHeaderItemStrings[1],
                    iconData: Icons.keyboard_arrow_down,
                    iconDropDownData: Icons.keyboard_arrow_up,
                  ),
                  GZXDropDownHeaderItem(_dropDownHeaderItemStrings[2],
                      iconData:
                          this._filterConfig.detailConditions[2].isSelected
                              ? Icons.keyboard_arrow_down
                              : Icons.block,
                      iconDropDownData: Icons.keyboard_arrow_up,
                      style: TextStyle(
                        color: this._filterConfig.detailConditions[2].isSelected
                            ? Colors.black
                            : AppColor.thirdElementText,
                      )),
                ],
                // GZXDropDownHeader对应第一父级Stack的key
                stackKey: _stackKey,
                // controller用于控制menu的显示或隐藏
                controller: _dropdownMenuController,
                // 当点击头部项的事件，在这里可以进行页面跳转或openEndDrawer
                onItemTap: (index) {
                  if (index == 0) {
                    this._dropdownMenuController.hide();
                    setState(() {});
                    showPickerDate(
                        endDate: DateTime.now(),
                        context: context,
                        scaffoldState: _scaffoldKey.currentState!,
                        selected: this._filterConfig.startTime,
                        onConfirm: (picker, selected) {
                          String pickTime = picker.adapter.text;
                          pickTime = pickTime.split(" ")[0] + " 00:00:00";
                          setState(() {
                            this._filterConfig.startTime =
                                DateFormat("yyyy-MM-dd HH:mm").parse(pickTime);
                          });
                          this._buildFilterMenuTitles();
                          this._initCycles();
                        });
                  } else if (index == 2) {
                    /// 如果明细过滤中，不显示血糖，那么禁用指标过滤
                    if (!this._filterConfig.detailConditions[2].isSelected) {
                      this._dropdownMenuController.hide();
                      setState(() {});
                    }
                  }
                },
//                // 头部的高度
//                height: 40,
//                // 头部背景颜色
//                color: Colors.red,
//                // 头部边框宽度
                borderWidth: 2,
//                // 头部边框颜色
                borderColor: Colors.amber,
//                // 分割线高度
//                dividerHeight: 20,
//                // 分割线颜色
//                dividerColor: Color(0xFFeeede6),
//                // 文字样式
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
//                // 下拉时文字样式
                dropDownStyle: TextStyle(
                  fontSize: 18.sp,
                  color: Theme.of(context).primaryColor,
                ),
//                // 图标大小
//                iconSize: 20,
//                // 图标颜色
//                iconColor: Color(0xFFafada7),
//                // 下拉时图标颜色
//                iconDropDownColor: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: _buildCycleList(),
              ),
            ],
          ),
          // 下拉菜单，注意GZXDropDownMenu目前只能在Stack内，后续有时间会改进，以及支持CustomScrollView和NestedScrollView
          GZXDropDownMenu(
            // controller用于控制menu的显示或隐藏
            controller: _dropdownMenuController,
            // 下拉菜单显示或隐藏动画时长
            animationMilliseconds: 300,
            // 下拉后遮罩颜色
//          maskColor: Theme.of(context).primaryColor.withOpacity(0.5),
//          maskColor: Colors.red.withOpacity(0.5),
//             dropdownMenuChanging: (isShow, index) {
//               setState(() {
//                 _dropdownMenuChange = '(正在${isShow ? '显示' : '隐藏'}$index)';
//                 print(_dropdownMenuChange);
//               });
//             },
            dropdownMenuChanged: (isShow, index) {
              if (!isShow && index != 0) {
                /// 不需要干任何事情.
              }
            },
            // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
            menus: [
              GZXDropdownMenuBuilder(
                dropDownHeight: 40 * 8.0,
                dropDownWidget: Container(),
              ),
              GZXDropdownMenuBuilder(
                dropDownHeight:
                    40.0 * this._filterConfig.detailConditions.length,
                dropDownWidget: _buildConditionListWidget(
                  this._filterConfig.detailConditions,
                  (value) {
                    if (this
                            ._filterConfig
                            .detailConditions
                            .where((element) => element.isSelected)
                            .length >
                        1) {
                      this._filterConfig.detailConditions.forEach((element) {
                        if (element == value) {
                          element.isSelected = !element.isSelected;
                        }
                      });
                      setState(() {});
                    } else {
                      this._filterConfig.detailConditions.forEach((element) {
                        if (element == value && !element.isSelected) {
                          element.isSelected = !element.isSelected;
                          setState(() {});
                        }
                      });
                    }
                  },
                ),
              ),
              GZXDropdownMenuBuilder(
                dropDownHeight:
                    40.0 * this._filterConfig.standardConditions.length,
                dropDownWidget: _buildConditionListWidget(
                  this._filterConfig.standardConditions,
                  (value) {
                    if (this
                            ._filterConfig
                            .standardConditions
                            .where((element) => element.isSelected)
                            .length >
                        1) {
                      this._filterConfig.standardConditions.forEach((element) {
                        if (element == value) {
                          element.isSelected = !element.isSelected;
                        }
                      });
                      setState(() {});
                    } else {
                      this._filterConfig.standardConditions.forEach((element) {
                        if (element == value && !element.isSelected) {
                          element.isSelected = !element.isSelected;
                          setState(() {});
                        }
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///构建筛选菜单内的筛选列表.
  _buildConditionListWidget(
      items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      // item 的个数
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0),
      // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        return gestureDetector(items, index, itemOnTap, context);
      },
    );
  }

  ///构建筛选列表内的每个选项.
  GestureDetector gestureDetector(items, int index,
      void itemOnTap(SortCondition sortCondition), BuildContext context) {
    SortCondition goodsSortCondition = items[index];
    return GestureDetector(
      onTap: () {
        itemOnTap(goodsSortCondition);
      },
      child: Container(
        //            color: Colors.blue,
        height: 40,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                goodsSortCondition.name,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: goodsSortCondition.isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ),
            ),
            goodsSortCondition.isSelected
                ? Icon(
                    Icons.check,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  )
                : SizedBox(),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建过滤器菜单标题.
  void _buildFilterMenuTitles() {
    setState(() {
      _dropDownHeaderItemStrings = [
        DateFormat("yyyy-MM-dd").format(this._filterConfig.startTime),
        '明细过滤',
        '指标过滤'
      ];
    });
  }

  /// 构建周期里列表.
  _buildCycleList() {
    return this._cycleList.isEmpty
        ? Container(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "暂无数据",
                style: TextStyle(
                  color: AppColor.thirdElementText,
                  fontSize: 25.sp,
                ),
              ),
            ),
          )
        : NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              /// 将时间过滤条件随着列表滚动而改变.
              List<int> itemIndexList = getVisible();
              if (itemIndexList.isNotEmpty &&
                  this._filterConfig.startTime !=
                      this._cycleList[getVisible().first].datetime) {
                setState(() {
                  this._filterConfig.startTime =
                      this._cycleList[getVisible().first].datetime!;
                });
                _buildFilterMenuTitles();
              }
              return true;
            },
            child: RectGetter(
              key: listViewKey,
              child: EasyRefresh.custom(
                scrollController: this.scrollController,
                header: BezierCircleHeader(
                    color: Colors.blue, backgroundColor: Colors.amber),
                footer: BezierBounceFooter(
                    color: Colors.blue, backgroundColor: Colors.amber),
                onRefresh: () async {
                  await this._loadCycles(next: true);
                },
                onLoad: () async {
                  await this._loadCycles(next: false);
                },
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        _keys[index] = RectGetter.createGlobalKey();
                        return RectGetter(
                          key: _keys[index],
                          child: _buildCycleCard(this._cycleList[index]),
                        );
                      },
                      childCount: this._cycleList.length,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  /// 构建历史周期记录卡片.
  _buildCycleCard(CycleRecord cycle) {
    List<RecordItem> itemList = this._doFilter(cycle);
    Widget card = Card(
      shape: RoundedRectangleBorder(
        borderRadius: RadiusConstant.k6pxRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCycleOperation(cycle),
          Divider(
            thickness: 5,
            height: 1.h,
            color: Colors.amber,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              children: itemList.isNotEmpty
                  ? ListTile.divideTiles(
                      context: context,
                      tiles: buildDetailRecordItem(
                        context: context,
                        itemList: _doFilter(cycle),
                        standard: this._standard,
                        itemDeleteCallback: this._handleItemDelete,
                        handleRecordItemEdit: this._pushItemEditPage,
                      )).toList()
                  : [
                      Container(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "暂无数据",
                            style: TextStyle(
                              color: AppColor.thirdElementText,
                              fontSize: 25.sp,
                            ),
                          ),
                        ),
                      )
                    ],
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: card,
    );
  }

  /// 构建周期的操作按钮区域.
  _buildCycleOperation(CycleRecord cycle) {
    return Container(
      height: 40.h,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            Expanded(
              child: Container(),
              flex: 2,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Builder(
                  builder: (cycleCommentContext) {
                    return InkWell(
                      onTap: () {
                        showTooltip(
                          context: cycleCommentContext,
                          content: cycle.comment ?? '',
                          preferDirection: PreferDirection.bottomCenter,
                        );
                      },
                      child: Text(
                        "${null == cycle.comment || cycle.comment!.isEmpty ? '暂无备注' : cycle.comment}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 25.sp,
                          color: AppColor.thirdElementText,
                        ),
                      ),
                    );
                  },
                ),
              ),
              flex: 6,
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton(
                  icon: Icon(
                    Icons.settings,
                    color: AppColor.thirdElementText,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: RadiusConstant.k6pxRadius,
                  ),
                  offset: Offset(0, 40.h),
                  iconSize: 30.sp,
                  itemBuilder: (BuildContext bc) {
                    const operationList = [
                      {
                        "key": "delete",
                        "title": "删除",
                        "icon": Icon(
                          Icons.delete,
                          color: Colors.red,
                        )
                      },
                      {
                        "key": "share",
                        "title": "分享",
                        "icon": Icon(
                          Icons.share,
                          color: Colors.blue,
                        )
                      },
                      {
                        "key": "medicine",
                        "title": "添加药物记录",
                        "icon": Icon(
                          Iconfont.yaowu,
                          color: Colors.amber,
                        )
                      },
                      {
                        "key": "food",
                        "title": "添加用餐记录",
                        "icon": Icon(
                          Iconfont.jinshi,
                          color: Colors.green,
                        )
                      },
                      {
                        "key": "bloodSugar",
                        "title": "添加血糖记录",
                        "icon": Icon(
                          Iconfont.xietang,
                          color: Colors.red,
                        )
                      },
                    ];
                    return operationList
                        .map((operation) => PopupMenuItem(
                              child: Row(
                                children: [
                                  operation["icon"] as Widget,
                                  Padding(
                                      padding: EdgeInsets.only(right: 10.w)),
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
                    if (value == "delete") {
                      _handleDeleteCycle(cycle);
                    } else if (value == "share") {
                      /// 删除整个周期的数据记录.
                      Share.share(CycleRecord.toShareText(cycle),
                          subject: '【血糖记录器】分享数据');
                    } else if (value == "medicine") {
                      if (!await _canAdd(cycle)) {
                        showNotification(
                            type: NotificationType.ERROR,
                            message: "一个周期内最多只能添加10条明细记录");
                        return;
                      }
                      AutoRouter.of(context).push(MedicineRecordRoute(
                          autoSave: true,
                          cycleId: cycle.id!,
                          returnWithPop: false,
                          parentRouter: MainRoute(
                              tabIndex: 1,
                              historyFilterConfig: this._filterConfig)));
                    } else if (value == "food") {
                      if (!await _canAdd(cycle)) {
                        showNotification(
                            type: NotificationType.ERROR,
                            message: "一个周期内最多只能添加10条明细记录");
                        return;
                      }
                      AutoRouter.of(context).push(FoodRecordRoute(
                          autoSave: true,
                          returnWithPop: false,
                          cycleId: cycle.id!,
                          parentRouter: MainRoute(
                              tabIndex: 1,
                              historyFilterConfig: this._filterConfig)));
                    } else if (value == "bloodSugar") {
                      if (!await _canAdd(cycle)) {
                        showNotification(
                            type: NotificationType.ERROR,
                            message: "一个周期内最多只能添加10条明细记录");
                        return;
                      }
                      AutoRouter.of(context).push(BloodSugarRecordRoute(
                        autoSave: true,
                        cycleId: cycle.id!,
                        showCloseButton: false,
                        parentRouter: MainRoute(
                            tabIndex: 1,
                            historyFilterConfig: this._filterConfig),
                        returnWithPop: false,
                      ));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////事件处理区域///////////////////////////
  /// 进行原有数据过滤
  List<RecordItem> _doFilter(CycleRecord cycle) {
    List<RecordItem> res = [];

    /// 第一步，过滤明细数据.
    if (cycle.itemList.isNotEmpty) {
      List<SortCondition> detailFilter = this
          ._filterConfig
          .detailConditions
          .where((detail) => detail.isSelected)
          .toList();

      List<Type> allowTypeList = detailFilter.map((detail) {
        if (detail.name == "药物记录") return MedicineRecordItem;
        if (detail.name == "用餐记录") return FoodRecordItem;
        if (detail.name == "血糖监测") return BloodSugarRecordItem;
        return String;
      }).toList();

      res = cycle.itemList
          .where((element) => allowTypeList.contains(element.runtimeType))
          .toList();

      /// 第二步，过滤指标数据.
      for (var value in this
          ._filterConfig
          .standardConditions
          .where((element) => !element.isSelected)) {
        /// 删除没有勾选的
        res.removeWhere((element) {
          if (element.runtimeType == BloodSugarRecordItem) {
            element as BloodSugarRecordItem;
            if (value.name == "正常") {
              /// 过滤血糖正常的数据
              if (element.fpg ?? true) {
                return element.bloodSugar! >= this._standard.fpgMin &&
                    element.bloodSugar! <= this._standard.fpgMax;
              } else {
                return element.bloodSugar! >= this._standard.hpg2Min &&
                    element.bloodSugar! <= this._standard.hpg2Max;
              }
            } else if (value.name == "高血糖") {
              /// 过滤高血糖
              if (element.fpg ?? true) {
                return element.bloodSugar! > this._standard.fpgMax;
              } else {
                return element.bloodSugar! > this._standard.hpg2Max;
              }
            } else if (value.name == "低血糖") {
              /// 过滤低血糖
              if (element.fpg ?? true) {
                return element.bloodSugar! < this._standard.fpgMin;
              } else {
                return element.bloodSugar! < this._standard.hpg2Min;
              }
            }
          }
          return false;
        });
      }
    }
    return res;
  }

  /// 获取初始化历史周期数据.
  Future<void> _initCycles() async {
    CancelFunc cancel = showLoading();

    this._standard = await ConfigService().getStandard(this._currentUser.id!);

    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");

    /// 处理时间.
    DateTime begin = this._filterConfig.startTime;
    if (format.format(begin).split(" ")[1] == "00:00:00") {
      begin = format
          .parse(
              "${DateFormat("yyyy-MM-dd").format(this._filterConfig.startTime)} 00:00:00")
          .add(Duration(days: 1));
    } else {
      begin = begin.add(Duration(seconds: 1));
    }

    this._cycleList = await CycleRecordService()
        .findPage(Global.currentUser!.id!, false, begin);
    if (mounted) {
      setState(() {});
    }
    cancel();
  }

  /// 切换用户时刷新数据.
  void _dataRefresh() {
    if (this._currentUser.id != Global.currentUser!.id) {
      this._currentUser = Global.currentUser!;
      this._initCycles();
    }
  }

  /// 获取更多周期数据.
  /// [next] 是否获取列表最早时间之前的数据.
  Future<void> _loadCycles({
    bool next = false,
  }) async {
    List<CycleRecord> newRecords = await CycleRecordService().findPage(
        Global.currentUser!.id!,
        next,
        (next
                ? this._cycleList.first.datetime
                : this._cycleList.last.datetime) ??
            DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(
                    "${DateFormat("yyyy-MM-dd").format(this._filterConfig.startTime)} 00:00:00")
                .add(Duration(days: 1)));
    if (newRecords.isEmpty) {
      showToast(msg: "没有更多数据了");
      return;
    }

    if (next) {
      /// 和当前时间越近的数据加载队列前面.
      this._cycleList.insertAll(0, newRecords);
    } else {
      /// 越早的数据加到队列后面.
      this._cycleList.addAll(newRecords);
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// 删除选定周期以及周期下的所有明细记录.
  void _handleDeleteCycle(CycleRecord cycleRecord) async {
    // 删除提示框.
    OkCancelResult res = await showOkCancelAlertDialog(
      context: this.context,
      title: "确定要删除吗？",
      message: "删除周期将一同删除周期下所有的明细记录",
      okLabel: "确定",
      cancelLabel: "取消",
      barrierDismissible: false,
    );

    if (res.index == OkCancelResult.ok.index) {
      CancelFunc cancel = showLoading();

      await CycleRecordService().deleteWithItemsById(cycleRecord.id!);

      showNotification(type: NotificationType.SUCCESS, message: "删除成功");

      cancel();

      /// 刷新页面.
      this._initCycles();
    }
  }

  Future<bool> _canAdd(CycleRecord cycle) async {
    return CycleRecordService().canAddItem(cycle.id!);
  }

  /// 某个周期中的明细被删除后的回调处理.
  /// [deleteItem] 已经从数据被删除掉的明细数据.
  _handleItemDelete(RecordItem deleteItem) {
    CycleRecord record = this
        ._cycleList
        .where((element) => element.id == deleteItem.cycleRecordId)
        .first;
    if (record.itemList.length <= 1) {
      this._cycleList.remove(record);
    } else {
      record.itemList.remove(deleteItem);
    }

    setState(() {});
  }

  /// 跳转周期内明细编辑页面.
  _pushItemEditPage(BuildContext context, RecordItem item, int index) {
    switch (item.runtimeType) {
      case MedicineRecordItem:
        {
          AutoRouter.of(context).push(MedicineRecordRoute(
            autoSave: true,
            returnWithPop: false,
            medicineRecordItem: item as MedicineRecordItem,
            cycleId: item.cycleRecordId,
            parentRouter:
                MainRoute(tabIndex: 1, historyFilterConfig: this._filterConfig),
          ));
          break;
        }
      case FoodRecordItem:
        {
          AutoRouter.of(context).push(FoodRecordRoute(
            autoSave: true,
            foodRecordItem: item as FoodRecordItem,
            returnWithPop: false,
            cycleId: item.cycleRecordId,
            parentRouter:
                MainRoute(tabIndex: 1, historyFilterConfig: this._filterConfig),
          ));
          break;
        }
      case BloodSugarRecordItem:
        {
          AutoRouter.of(context).push(BloodSugarRecordRoute(
            autoSave: true,
            bloodSugarRecordItem: item as BloodSugarRecordItem,
            returnWithPop: false,
            showCloseButton: false,
            cycleId: item.cycleRecordId,
            parentRouter:
                MainRoute(tabIndex: 1, historyFilterConfig: this._filterConfig),
          ));
          break;
        }
    }
  }

  List<int> getVisible() {
    /// 先获取整个ListView的rect信息，然后遍历map
    /// 利用map中的key获取每个item的rect,如果该rect与ListView的rect存在交集
    /// 则将对应的index加入到返回的index集合中
    var rect = RectGetter.getRectFromKey(listViewKey);
    var _items = <int>[];
    _keys.forEach((index, key) {
      var itemRect = RectGetter.getRectFromKey(key);
      if (itemRect != null &&
          !(itemRect.top > rect!.bottom || itemRect.bottom < rect.top))
        _items.add(index);
    });

    /// 这个集合中存的就是当前处于显示状态的所有item的index
    return _items;
  }
}

class SortCondition {
  String name;
  bool isSelected;

  SortCondition({
    required this.name,
    required this.isSelected,
  });
}

class HistoryFilterConfig {
  /// 记录搜索开始时间.
  DateTime startTime;

  /// 明细项过滤配置.
  List<SortCondition> detailConditions;

  /// 指标项过滤配置.
  List<SortCondition> standardConditions;

  HistoryFilterConfig({
    required this.startTime,
    required this.detailConditions,
    required this.standardConditions,
  });

  static HistoryFilterConfig byDefault() {
    return HistoryFilterConfig(
      startTime: DateTime.now(),
      detailConditions: [
        SortCondition(name: '药物记录', isSelected: true),
        SortCondition(name: '用餐记录', isSelected: true),
        SortCondition(name: '血糖监测', isSelected: true)
      ],
      standardConditions: [
        SortCondition(name: '正常', isSelected: true),
        SortCondition(name: '高血糖', isSelected: true),
        SortCondition(name: '低血糖', isSelected: true)
      ],
    );
  }
}
