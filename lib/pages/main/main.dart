import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/pages/main/custom_auto_route_observer.dart';
import 'package:blood_sugar_recorder/pages/main/user_selector.dart';
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
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    /// 注册用户切换状态监听 如果用这种监听方式，整个widget以及下面的子widget在监听数据变化时，都会重新build.
    // final UserSwitchState userSwitchState =
    //     Provider.of<UserSwitchState>(context);

    const routes = const [
      RecordRoute(),
      HistoryRoute(),
      StatsRoute(),
      SettingRoute(),
    ];

    return AutoTabsScaffold(
      // navigatorObservers: ()=>[
      //   CustomBottomTabAutoRouteObserver(),
      // ],
      resizeToAvoidBottomInset: false,
      lazyLoad: true,
      routes: routes,
      appBarBuilder: (context, tabRouter) {
        return transparentAppBar(
          context: context,
          title: getTitle(tabRouter),
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
        );
      },
      bottomNavigationBuilder: (context, tabRouter) {
        return BottomNavigationBar(
          backgroundColor: Colors.amber,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: tabRouter.activeIndex,
          onTap: (index) {
            AutoRouter.of(context)
                .navigate(MainRoute(children: [routes[index]]));
          },
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
      },
    );
  }

  Widget getTitle(TabsRouter tabRouter) {
    TextStyle style = TextStyle(fontSize: 20.sp, color: Colors.black54);
    switch (tabRouter.activeIndex) {
      case 0:
        return Text(
          '当前记录周期',
          style: style,
        );
      case 1:
        return Text(
          '历史记录',
          style: style,
        );
      case 2:
        return Text(
          '统计分析',
          style: style,
        );
      case 3:
        return Text(
          '设置',
          style: style,
        );
      default:
        return Text(
          '设置',
          style: style,
        );
    }
  }
}
