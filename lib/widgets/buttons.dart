import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget seFlatButton({
  required VoidCallback onPressed,
  double width = 140,
  double height = 44,
  Color bgColor = AppColor.primaryElement,
  String title = "button",
  Color fontColor = AppColor.primaryElementText,
  double fontSize = 18,
  String fontName = 'Montserrate',
  FontWeight fontWeight = FontWeight.w400,
}) {
  return Container(
    width: width.w,
    height: height.h,
    child: TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(bgColor),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: RadiusConstant.k6pxRadius,
        )),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: fontColor,
            fontFamily: fontName,
            fontWeight: fontWeight,
            fontSize: fontSize.sp,
            height: 1),
      ),
    ),
  );
}

Widget seBorderOnlyFlatButton({
  required VoidCallback onPressed,
  double width = 88,
  double height = 44,
  String? iconName,
}) {
  return Container(
    width: width.w,
    height: height.h,
    child: TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: RadiusConstant.k6pxRadius,
        side: Borders.primaryBorder,
      ))),
      child: Image.asset("resource/assets/images/icon_${iconName}.png"),
    ),
  );
}
