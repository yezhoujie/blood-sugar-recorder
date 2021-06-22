import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/appColor.dart';
import 'package:blood_sugar_recorder/pages/config/setting.dart';
import 'package:blood_sugar_recorder/pages/history/history.dart';
import 'package:blood_sugar_recorder/pages/main/user_selector.dart';
import 'package:blood_sugar_recorder/pages/record/record.dart';
import 'package:blood_sugar_recorder/pages/stats/stats.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/utils/utils.dart';
import 'package:blood_sugar_recorder/widgets/avatar.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// 程序主骨架页面.
class MainPage extends StatefulWidget {
  /// 默认的选中的tab.
  final int tabIndex;

  /// 历史记录页保存的过滤条件.
  final HistoryFilterConfig? historyFilterConfig;

  MainPage({Key? key, required this.tabIndex, this.historyFilterConfig})
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// 页面内当前激活的tab.
  late int _tabIndex = widget.tabIndex;

  /// 页面控制器.
  late PageController _pageController;

  final List<String> _tabTitle = ["当前记录周期", "历史周期记录", "统计分析", "设置"];

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: this._tabIndex);
  }

  @override
  void dispose() {
    this._pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// 注册用户切换状态监听 如果用这种监听方式，整个widget以及下面的子widget在监听数据变化时，都会重新build.
    // final UserSwitchState userSwitchState =
    //     Provider.of<UserSwitchState>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _buildPageView(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _getTitle(int index) {
    TextStyle style = TextStyle(fontSize: 20.sp, color: Colors.black54);
    return Text(
      this._tabTitle[index],
      style: style,
    );
  }

  /// 构建appBar.
  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: context,
      title: _getTitle(this._tabIndex),
      leading: Builder(
        builder: (leadingContext) => InkWell(
          onTap: () {
            // showUserSelector(target: details.globalPosition);
            showUserSelector(context: leadingContext);
          },
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Colors.black26,
                      spreadRadius: 2,
                    ),
                  ],
                  shape: BoxShape.circle),
              child: Consumer<UserSwitchState>(
                builder: (context, state, child) =>
                    getCircleAvatarByName(name: state.currentUser!.name),
              ),
            ),
          ),
        ),
      ),
      actions: _buildAction(this._tabIndex),
    );
  }

  _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.amber,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      currentIndex: this._tabIndex,
      onTap: _handleNavBarTap,
      items: [
        /// 主页
        BottomNavigationBarItem(
          icon: Icon(Iconfont.zhuye),
          label: "主页",
        ),

        /// 历史记录
        BottomNavigationBarItem(
          icon: Icon(Iconfont.jilu),
          label: "历史",
        ),

        /// 统计分析
        BottomNavigationBarItem(
          icon: Icon(Iconfont.tongji),
          label: "统计",
        ),

        /// 设置.
        BottomNavigationBarItem(
          icon: Icon(Iconfont.shezhi),
          label: "设置",
        ),
      ],
    );
  }

  /// 构建可切换页面body.
  Widget _buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),

      /// 可切换的页面列表.
      children: <Widget>[
        RecordPage(),
        HistoryPage(
          filterConfig: widget.historyFilterConfig,
        ),
        StatsPage(),
        SettingPage(),
      ],
      controller: _pageController,
      onPageChanged: _handlePageChange,
    );
  }

  List<Widget> _buildAction(int tabIndex) {
    List<Widget> actions = [];
    if (tabIndex == 1) {
      /// 历史记录页面.
      actions = [
        IconButton(
            onPressed: () {
              AutoRouter.of(context).pushAndPopUntil(MainRoute(tabIndex: 1),
                  predicate: (_) => false);
            },
            icon: Icon(
              Icons.refresh,
              color: AppColor.thirdElementText,
              size: 30.sp,
            )),
        IconButton(
            onPressed: () {
              /// 跳转到补填周期页面.
              AutoRouter.of(context).push(HistoryAddRoute());
            },
            icon: Icon(
              Icons.add,
              color: AppColor.thirdElementText,
              size: 35.sp,
            )),
      ];
    }
    return actions;
  }

  ///////////////////////////事件处理区域////////////////////////////
  /// 处理点击下方tab,切换页面.
  void _handleNavBarTap(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  /// 处理当页面切换后，同步当前tab的index.
  void _handlePageChange(int value) {
    setState(() {
      this._tabIndex = value;
    });
  }
}
