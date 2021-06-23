import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:blood_sugar_recorder/constant/constant.dart';
import 'package:blood_sugar_recorder/route/route.gr.dart';
import 'package:blood_sugar_recorder/widgets/notification.dart';
import 'package:blood_sugar_recorder/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recognition_qrcode/recognition_qrcode.dart';
import 'package:url_launcher/url_launcher.dart';

/// 应用信息页面.
class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PreferredSizeWidget _buildAppBar() {
    return transparentAppBar(
      context: this.context,
      title: Text(
        "关于血糖记录器",
        style: TextStyle(
          fontSize: 30.sp,
          color: AppColor.primaryText,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColor.primaryText,
          size: 35.sp,
        ),
        onPressed: () {
          AutoRouter.of(this.context)
              .pushAndPopUntil(MainRoute(tabIndex: 3), predicate: (_) => false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 20.h),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "应用介绍",
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '''  【血糖记录器】是作者为自己的父亲制作的一款记录日常血糖等数据的应用程序。
    \n   该程序经过作者对日常记录行为的观察以及父母实际需求的分析后拥有以下特性: 
    \n    1. 周期性数据记录，记录的数据包括【药物使用】,【用餐情况】以及【血糖检测】。对数据进行周期划分，方便数据的查看。
    \n    2. 支持快速创建餐后2小时血糖测量闹钟，避免忘记测量血糖而导致的数据准确性偏差。
    \n    3. 完全本地记录。程序使用完全不用任何流量（除非想对作者进行捐助，捐助请看页面底部）。数据完全在手机本地存储，不包含任何形式的广告。避免中老年同志由于误操作而导致的损失。
    \n    4. 快速数据筛选。程序可对历史周期记录进行快速的数据筛选。
    \n    5. 丰富的数据统计项。程序提供丰富的数据统计项，让记录有意义，血糖趋势一目了然。
    \n    6. 尽可能放大字体，照顾中老年人的老花眼。
                  ''',
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "版权说明",
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '''  【血糖记录器】为一款开源应用, 遵循MIT开源协议。
    \n   开源地址：https://github.com/yezhoujie/blood-sugar-recorder 
                  ''',
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "捐助作者",
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "   如果觉得这个程序还不错，长按识别下方图中二维码请作者喝杯咖啡吧。",
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
              ),
              Row(
                children: [
                  InkWell(
                    onLongPress: () async {
                      // ByteData imageData = await PlatformAssetBundle()
                      //     .load("resource/assets/images/qrcode_alipay.png");
                      // String base64 = Base64Encoder()
                      //     .convert(imageData.buffer.asUint8List());
                      // RecognitionQrcode.recognition(base64)
                      //     .then((result) async {
                      //   String url =
                      //       "alipayqr://platformapi/startapp?saId=10000007&qrcode=${Uri.encodeFull(result["value"])}";
                      //   // if (await canLaunch(url)) {
                      //   //   await launch(url);
                      //   // } else {
                      //   //   showNotification(
                      //   //     type: NotificationType.ERROR,
                      //   //     message: "打开支付宝失败了",
                      //   //   );
                      //   // }
                      //   await launch(url);
                      // });
                      String url =
                            "alipayqr://platformapi/startapp?saId=10000007&qrcode=https://qr.alipay.com/fkx10352hmwhzvrwnezdk40";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          showNotification(
                            type: NotificationType.ERROR,
                            message: "打开支付宝失败了，请确认手机安装了支付宝",
                          );
                        }
                    },
                    child: Image.asset(
                      "resource/assets/images/qrcode_alipay.png",
                      width: 170.w,
                      height: 180.w,
                    ),
                  ),
                  InkWell(
                    onLongPress: () async {
                      // ByteData imageData = await PlatformAssetBundle()
                      //     .load("resource/assets/images/qrcode_wechat.png");
                      // String base64 = Base64Encoder()
                      //     .convert(imageData.buffer.asUint8List());
                      // RecognitionQrcode.recognition(base64)
                      //     .then((result) async {
                      //   String url =
                      //       "${Uri.encodeFull(result["value"])}";
                      //   print(url);
                      //   if (await canLaunch(url)) {
                      //     await launch(url);
                      //   } else {
                      //     showNotification(
                      //       type: NotificationType.ERROR,
                      //       message: "打开微信失败了",
                      //     );
                      //   }
                      //   // await launch(url);
                      // });
                      showNotification(
                        type: NotificationType.ERROR,
                        message: "抱歉，微信暂不支持识别二维码支付",
                      );
                    },
                    child: Image.asset(
                      "resource/assets/images/qrcode_wechat.png",
                      width: 170.w,
                      height: 180.w,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
