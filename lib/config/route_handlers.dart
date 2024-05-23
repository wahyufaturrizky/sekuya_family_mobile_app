/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:sekuya_family_mobile_app/components/tab_community/featured_community.dart';
import 'package:sekuya_family_mobile_app/components/tab_mission/mission.dart';
import 'package:sekuya_family_mobile_app/components/tab_voucher/my_voucher.dart';
import 'package:sekuya_family_mobile_app/screens/login/login_component.dart';
import 'package:sekuya_family_mobile_app/screens/private/detail_community.dart';
import 'package:sekuya_family_mobile_app/screens/private/mission_detail.dart';
import 'package:sekuya_family_mobile_app/screens/private/notification.dart';
import 'package:sekuya_family_mobile_app/screens/private/private_component.dart';
import 'package:sekuya_family_mobile_app/screens/private/profile_detail.dart';
import 'package:sekuya_family_mobile_app/screens/private/voucher_detail.dart';

import '../helpers/color_helpers.dart';
import '../components/demo/demo_simple_component.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const LoginScreenApp();
});

var privateHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  final MyArgumentsDataClass? args =
      context!.settings!.arguments as MyArgumentsDataClass?;

  return PrivateScreenApp(args: args);
});

var profileDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const ProfileDetailApp();
});

var notificationlHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const NotificationApp();
});

var communityDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  final MyArgumentsDataDetailCommunityClass? args =
      context!.settings!.arguments as MyArgumentsDataDetailCommunityClass?;

  return CommunityComponentDetailApp(args: args);
});

var voucherDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  final MyArgumentsDataDetailVoucherClass? args =
      context!.settings!.arguments as MyArgumentsDataDetailVoucherClass?;

  return VoucherDetailApp(args: args);
});

var missionDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  final MyArgumentsDataDetailMissionClass? args =
      context!.settings!.arguments as MyArgumentsDataDetailMissionClass?;

  return MissionDetailApp(args: args);
});

var demoRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? message = params["message"]?.first;
  String? colorHex = params["color_hex"]?.first;
  String? result = params["result"]?.first;
  Color color = Color(0xFFFFFFFF);
  if (colorHex != null && colorHex.length > 0) {
    color = Color(ColorHelpers.fromHexString(colorHex));
  }
  return DemoSimpleComponent(
      message: message ?? 'Testing', color: color, result: result);
});

var demoFunctionHandler = Handler(
    type: HandlerType.function,
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? message = params["message"]?.first;
      showDialog(
        context: context!,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Hey Hey!",
              style: TextStyle(
                color: const Color(0xFF00D6F7),
                fontFamily: "Lazer84",
                fontSize: 22.0,
              ),
            ),
            content: Text("$message"),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8.0, right: 8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("OK"),
                ),
              ),
            ],
          );
        },
      );
      return;
    });

/// Handles deep links into the app
/// To test on Android:
///
/// `adb shell am start -W -a android.intent.action.VIEW -d "fluro://deeplink?path=/message&mesage=fluro%20rocks%21%21" com.theyakka.fluro`
var deepLinkHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? colorHex = params["color_hex"]?.first;
  String? result = params["result"]?.first;
  Color color = Color(0xFFFFFFFF);
  if (colorHex != null && colorHex.length > 0) {
    color = Color(ColorHelpers.fromHexString(colorHex));
  }
  return DemoSimpleComponent(
      message: "DEEEEEP LINK!!!", color: color, result: result);
});
