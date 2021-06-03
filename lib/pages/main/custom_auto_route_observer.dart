import 'package:auto_route/auto_route.dart';

/// Tab 路由观察者.
class CustomBottomTabAutoRouteObserver extends AutoRouteObserver {
  static int index = -1;

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    index = route.index;
  }
}
