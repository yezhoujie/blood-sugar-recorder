import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;

  ///距离上边组件的间隔
  final double marginTop;

  ///文本框内提示信息.
  final String hintText;

  /// 是否显示为 password.
  final bool isPassword;

  /// 手机上显示输入法显示的类型，如：字符/数字/符号等等.
  final TextInputType keyboardType;

  InputField(
      {required this.controller,
      this.marginTop = 15,
      this.hintText = 'input here',
      this.isPassword = false,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      margin: EdgeInsets.only(top: marginTop.h),

      /// 装饰，颜色和圆角.
      decoration: BoxDecoration(
        color: AppColor.secondaryElement,
        borderRadius: RadiusConstant.k6pxRadius,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,

          /// 输入的内容和输入框之间的padding 距离.
          contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 9),
          border: InputBorder.none,
        ),
        style: TextStyle(
            color: AppColor.primaryText,
            fontWeight: FontWeight.w400,
            fontSize: 18.sp),

        /// 不能换行.
        maxLines: 1,

        /// 不进行自动纠正错别字.
        autocorrect: false,

        /// 隐藏输入的内容.
        obscureText: isPassword,
      ),
    );
  }
}

Widget getInputEmailEdit({
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  String hintText = "input here",
  bool isPassword = false,
  double marginTop = 15,
  bool autoFocus = false,
}) {
  return Container(
    height: 44.h,
    margin: EdgeInsets.only(top: marginTop.h),
    decoration: BoxDecoration(
      color: AppColor.primaryBackground,
      borderRadius: RadiusConstant.k6pxRadius,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(41, 0, 0, 0),
          offset: Offset(0, 1),
          blurRadius: 0,
        ),
      ],
    ),
    child: TextField(
      autofocus: autoFocus,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 9),
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: AppColor.primaryText,
        ),
      ),
      style: TextStyle(
        color: AppColor.primaryText,
        fontWeight: FontWeight.w400,
        fontSize: 18.sp,
      ),
      maxLines: 1,
      autocorrect: false,
      obscureText: isPassword,
    ),
  );
}

Widget getInputField({
  required TextEditingController controller,
  double width = 250,
  double height = 70,
  TextInputType keyboardType = TextInputType.text,
  String hintText = "input here",
  List<TextInputFormatter> textInputFormatters = const [],

  ///输入内容校验规则
  int maxLength = 10,

  ///内容最大长度.
  MaxLengthEnforcement maxLengthEnforcement = MaxLengthEnforcement.enforced,

  /// 超过长度禁止输入.
  int maxLines = 1,
  bool isPassword = false,
  bool isValid = true,
}) {
  return Container(
    height: height,
    width: width,

    /// 装饰，颜色和圆角.
    decoration: BoxDecoration(
      color: AppColor.secondaryElement,
      borderRadius: RadiusConstant.k6pxRadius,
    ),
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: RadiusConstant.k6pxRadius as BorderRadius,
          borderSide: BorderSide(
            color: isValid ? AppColor.thirdElementText : Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RadiusConstant.k6pxRadius as BorderRadius,
          borderSide: BorderSide(
            color: isValid ? AppColor.thirdElementText : Colors.red,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 15.sp, height: 2.h),
      ),
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20.sp,
      ),
      cursorColor: AppColor.thirdElementText,
      inputFormatters: textInputFormatters,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      maxLines: maxLines,
      autocorrect: false,
      obscureText: isPassword,
      autofocus: false,
    ),
  );
}
