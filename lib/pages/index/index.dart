import 'package:blood_sugar_recorder/global.dart';
import 'package:blood_sugar_recorder/main.dart';
import 'package:blood_sugar_recorder/pages/welcome/welcome.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

///APP 入口页面, 判断欢迎页/登录页/首页跳转.
class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return getPage();
  }

  Widget getPage() {
    return Scaffold(
      body: Global.isFirstOpen
          ? WelcomePage()
          : MyHomePage(title: "homepage"),
      resizeToAvoidBottomInset: false,
    );
  }
}
