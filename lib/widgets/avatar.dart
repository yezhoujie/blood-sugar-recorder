import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget getCircleAvatarByName({
  String? name,
  Color backgroundColor = Colors.amber,
  double radius = 20,
  double fontSize = 20
}) {
  return CircleAvatar(
    radius: radius.w,
    backgroundColor: backgroundColor,
    child: Text(
      getLastLetterFromName(name),
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

String getLastLetterFromName(String? name) {
  name = name ?? "用户";
  return name.substring(name.length - 1, name.length);
}
