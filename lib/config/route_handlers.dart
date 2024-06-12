/*
 * Sekuya Family Mobile App
 * Created by Wahyu Fatur Rizki
 * https://www.linkedin.com/in/wahyu-fatur-rizky/
 * 
 * Copyright (c) 2024 Wahyu Fatur Rizki, LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
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

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return const LoginScreenApp();
});

var privateHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  final MyArgumentsDataClass? args =
      context!.settings!.arguments as MyArgumentsDataClass?;

  return PrivateScreenApp(
    args: args,
  );
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
