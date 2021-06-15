import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/domain/domain.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/service/record/cycle_record.dart';
import 'package:blood_sugar_recorder/utils/picker.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// 历史周期记录页面.
class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  DateTime _startTime = DateTime.now();

  /// 总过滤菜单标题列表.
  List<String> _dropDownHeaderItemStrings = [];

  ///明细过滤子菜单.
  List<SortCondition> _detailConditions = [];

  ///指标过滤子菜单.
  List<SortCondition> _standardConditions = [];

  ///下拉过滤器控制器.
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey _stackKey = GlobalKey();

  /// 周期列表数据.
  List<CycleRecord> _cycleList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// 构建过滤菜单列表.
    this._buildFilterMenuTitles();

    /// 明细过滤菜单.
    _detailConditions.add(SortCondition(name: '药物记录', isSelected: true));
    _detailConditions.add(SortCondition(name: '用餐记录', isSelected: true));
    _detailConditions.add(SortCondition(name: '血糖监测', isSelected: true));

    /// 指标过滤菜单.
    _standardConditions.add(SortCondition(name: '正常', isSelected: true));
    _standardConditions.add(SortCondition(name: '高血糖', isSelected: true));
    _standardConditions.add(SortCondition(name: '低血糖', isSelected: true));

    _initCycles();
  }

  @override
  Widget build(BuildContext context) {
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
                      iconData: this._detailConditions[2].isSelected
                          ? Icons.keyboard_arrow_down
                          : Icons.block,
                      iconDropDownData: Icons.keyboard_arrow_up,
                      style: TextStyle(
                        color: this._detailConditions[2].isSelected
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
                        selected: this._startTime,
                        onConfirm: (picker, selected) {
                          setState(() {
                            this._startTime = DateFormat("yyyy-MM-dd HH:mm")
                                .parse(picker.adapter.text);
                          });
                          this._buildFilterMenuTitles();
                          this._initCycles();
                        });
                  } else if (index == 2) {
                    /// 如果明细过滤中，不显示血糖，那么禁用指标过滤
                    if (!this._detailConditions[2].isSelected) {
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
              ///进行现在有列表数据过滤
              _doFilter();
            },
            // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
            menus: [
              GZXDropdownMenuBuilder(
                dropDownHeight: 40 * 8.0,
                dropDownWidget: Container(),
              ),
              GZXDropdownMenuBuilder(
                dropDownHeight: 40.0 * this._detailConditions.length,
                dropDownWidget: _buildConditionListWidget(
                  this._detailConditions,
                  (value) {
                    if (this
                            ._detailConditions
                            .where((element) => element.isSelected)
                            .length >
                        1) {
                      this._detailConditions.forEach((element) {
                        if (element == value) {
                          element.isSelected = !element.isSelected;
                        }
                      });
                      setState(() {});
                    } else {
                      this._detailConditions.forEach((element) {
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
                dropDownHeight: 40.0 * this._standardConditions.length,
                dropDownWidget: _buildConditionListWidget(
                  this._standardConditions,
                  (value) {
                    if (this
                            ._standardConditions
                            .where((element) => element.isSelected)
                            .length >
                        1) {
                      this._standardConditions.forEach((element) {
                        if (element == value) {
                          element.isSelected = !element.isSelected;
                        }
                      });
                      setState(() {});
                    } else {
                      this._standardConditions.forEach((element) {
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
        DateFormat("yyyy-MM-dd").format(_startTime),
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
        : EasyRefresh.custom(
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
                    return ListTile(
                      leading: Text("test$index"),
                    );
                  },
                  childCount: this._cycleList.length,
                ),
              ),
            ],
          );
  }

  ////////////////////////事件处理区域///////////////////////////
  /// 进行原有数据过滤
  void _doFilter() {
    /// todo 对原有数据进行过滤
    setState(() {});
  }

  /// 获取初始化历史周期数据.
  Future<void> _initCycles() async {
    CancelFunc cancel = showLoading();

    this._cycleList = await CycleRecordService().findPage(
        Global.currentUser!.id!,
        false,
        DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(
                "${DateFormat("yyyy-MM-dd").format(this._startTime)} 00:00:00")
            .add(Duration(days: 1)));
    if (mounted) {
      setState(() {});
    }

    /// 根据条件过滤明细.
    this._doFilter();
    cancel();
  }

  /// 获取更多周期数据.
  /// [next] 是否获取列表最早时间之前的数据.
  Future<void> _loadCycles({
    bool next = false,
  }) async {
    List<CycleRecord> newRecords = await CycleRecordService().findPage(
        Global.currentUser!.id!,
        next,
        this._cycleList.first.datetime ??
            DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(
                    "${DateFormat("yyyy-MM-dd").format(this._startTime)} 00:00:00")
                .add(Duration(days: 1)));
    if (newRecords.isEmpty) {
      showToast(msg: "没有更多数据了");
      return;
    } else {}
    if (next) {
      /// 和当前时间越近的数据加载队列前面.
      this._cycleList = newRecords..addAll(this._cycleList);
    } else {
      /// 越早的数据加到队列后面.
      this._cycleList.addAll(newRecords);
    }
    if (mounted) {
      setState(() {});
    }

    /// 根据条件过滤明细.
    this._doFilter();
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
