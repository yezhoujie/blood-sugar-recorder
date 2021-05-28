import 'package:flutter/material.dart';

/// 透明的自定义AppBar.
PreferredSizeWidget transparentAppBar({
  required BuildContext context,
  Widget title = const Text(''),
  Widget? leading,
  List<Widget> actions = const [],
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Center(
      child: title,
    ),
    leading: leading,
    actions: actions,
  );
}
