import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          color: Color(0xff366ad9),
          child: Column(
            children: [
              _buildTitle(),
              _buildImage(),
              _buildDesc(),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建顶部欢迎词
  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 65.h),
      child: Text(
        '欢迎',
        style: TextStyle(
          fontSize: 40.sp,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Image.asset(
        "resource/assets/images/welcome.png",
        width: 300.w,
        height: 250.h,
      ),
    );
  }

  Widget _buildDesc() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, left: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "✅ 本地记录，无需流量，放心使用",
            style: TextStyle(fontSize: 23.sp, color: Colors.white),
          ),
          Divider(),
          Text(
            "✅ 血糖，饮食，药物全方位记录",
            style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
            ),
          ),
          Divider(),
          Text(
            "✅ 大字体，拒绝老花眼",
            style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
            ),
          ),
          Divider(),
          Text(
            "✅ 统计分析，血糖变化一目了然",
            style: TextStyle(
              fontSize: 23.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      children: [
        Container(
          height: 100.h,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: seFlatButton(
              onPressed: () {},
              title: "创建用户，开始健康生活",
              width: 300.w,
              height: 70.h,
              fontSize: 20.sp,
              bgColor: Colors.amber,
              fontColor: Colors.black54,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
