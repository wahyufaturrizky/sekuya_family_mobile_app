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
import './route_handlers.dart';

class Routes {
  static String root = "/";
  static String demoSimple = "/demo";
  static String privateScreens = "/privateScreens";
  static String profileDetailScreens = "/profileDetailScreens";
  static String notificationScreen = "/notificationScreen";
  static String communityDetailAppScreens = "/communityDetailScreens";
  static String detailVoucherScreen = "/detailVoucherScreen";
  static String detailMissionScreen = "/detailMissionScreen";
  static String demoSimpleFixedTrans = "/demo/fixedtrans";
  static String demoFunc = "/demo/func";
  static String deepLink = "/message";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(root, handler: rootHandler);
    router.define(demoSimple, handler: demoRouteHandler);
    router.define(privateScreens, handler: privateHandler);
    router.define(profileDetailScreens, handler: profileDetailHandler);
    router.define(notificationScreen, handler: notificationlHandler);
    router.define(detailVoucherScreen, handler: voucherDetailHandler);
    router.define(detailMissionScreen, handler: missionDetailHandler);
    router.define(communityDetailAppScreens, handler: communityDetailHandler);
    router.define(demoSimpleFixedTrans,
        handler: demoRouteHandler, transitionType: TransitionType.inFromLeft);
    router.define(demoFunc, handler: demoFunctionHandler);
    router.define(deepLink, handler: deepLinkHandler);
  }
}
