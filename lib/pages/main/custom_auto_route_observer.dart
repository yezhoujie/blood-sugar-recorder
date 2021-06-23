import 'package:auto_route/auto_route.dart';

/// 配合autoRoute创建的Tab路由观察者.
/// 好像并没有什么卵用.
class CustomBottomTabAutoRouteObserver extends AutoRouteObserver {
  static int index = -1;

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    index = route.index;
  }
}
