import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/provider/user_switch_state.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  /// 确保 AppRoute() 始终只执行一次.
  final _appRouter = AppRoute();

  Global.init().then((value) => runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) =>
                UserSwitchState(currentUser: Global.currentUser),
          ),
        ],
        child: MyApp(_appRouter),
      )));
}

class MyApp extends StatelessWidget {
  final AppRoute _appRoute;

  MyApp(this._appRoute);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// 注册提示框. 不要改变这行的位置.
    final botToastBuilder = BotToastInit();
    return ScreenUtilInit(
      designSize: Size(375, 812.0 - 44 - 34),
      builder: () {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: '血糖记录器',
          builder: (context, child) {
            ///初始化 botToast 提示栏.
            child = botToastBuilder(context, child);
            /// 设置字体大小不跟随系统的字体大小.
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child,
            );
          },
          routeInformationParser: _appRoute.defaultRouteParser(),
          routerDelegate: _appRoute.delegate(
            // initialRoutes: [MyHomeRoute(title: "title")],
            navigatorObservers: () => [
              BotToastNavigatorObserver(), /** 为提示框注册路由观察者**/
            ],
          ),
        );
      },
    );
  }
}
